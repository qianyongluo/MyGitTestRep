//
//  LBSViewController.m
//  QylAllProducts
//
//  Created by lqy on 15/5/25.
//  Copyright (c) 2015年 lqy. All rights reserved.
//

#import "LBSViewController.h"


//edf1901e20148f5c39dc562e36ee3daa //我也是个冲突 哈哈 冲突来啦

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#define APIKey @"6ad25eb25331625e70488b4d9c6196b8"


@interface LBSViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    
    CLLocation *_currentLocation;
    UIButton *_locationButton;
    
    UIButton *_searchPOI;
    
    NSArray *_pois;
    UITableView *_tableView;
    NSMutableArray *_annotations;
}
@end

@implementation LBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    
    [self initTableView];
    [self initSearch];
    NSLog(@"bundle:%@",[NSBundle mainBundle].bundleIdentifier);
    // Do any additional setup after loading the view.
}

#pragma mark -- init
- (void)initMapView{
    [[MAMapServices sharedServices] setApiKey:APIKey];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)];
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
}

- (void)initSearch{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
}

- (void)initControls{
    _searchPOI = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, 30, 20)];
    [_searchPOI setTitle:@"附近搜索" forState:UIControlStateNormal];
    [_searchPOI addTarget:self action:@selector(searchPOI:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark -- actions
- (void)reGeoAction{
    if (_currentLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
}

- (void)searchPOI:(id)sender{
    if (_currentLocation == nil || _search == nil) {
        return;
    }
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.keywords = @"餐饮";
    [_search AMapPlaceSearch:request];
}

#pragma mark -- map delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"userLocation:%@",userLocation.location);
    _currentLocation = [userLocation.location copy];
}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated{
    
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self reGeoAction];
    }
}
#pragma mark -- amapsearch delegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"request :%@, error :%@", request, error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSString *title = response.regeocode.addressComponent.city;
    if (!title.length) {
        title = response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response{
    if (response.pois.count) {
        _pois = response.pois;
        [_tableView reloadData];
        
        [_mapView removeAnnotations:_annotations];
        [_annotations removeAllObjects];
    }
}

#pragma mark -- tableView dataSource delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndef = @"tscell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndef];
    }
    AMapPOI *poi = _pois[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    return cell;
}
@end
