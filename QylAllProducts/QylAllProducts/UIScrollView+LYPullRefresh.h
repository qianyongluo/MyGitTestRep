//
//  UIScrollView+LYPullRefresh.h
//  QylAllProducts
//
//  Created by lqy on 15/5/24.
//  Copyright (c) 2015年 lqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

static CGFloat const LYPullRefreshViewHeight = 60.0f;

typedef NS_ENUM(NSUInteger, LYPullRefreshPosition) {
    LYPullRefreshPositionTop = 0,
    LYPullRefreshPositionBottom,
    LYPullRefreshPositionLeft,
    LYPullRefreshPositionRight
};
@class LYPullRefreshView;

@interface UIScrollView (LYPullRefresh)

@property (nonatomic,strong,readonly) LYPullRefreshView *pullRefreshView;

- (void)addPullRefreshWithActionHandler:(void(^)(void))actionHandler;
- (void)addPullRefreshWithActionHandler:(void (^)(void))actionHandler position:(LYPullRefreshPosition)position;
- (void)addPullRefreshWithActionHandler:(void (^)(void))actionHandler position:(LYPullRefreshPosition)position refreshView:(LYPullRefreshView *)refreshView;

- (void)triggerPullRefresh;

@property (nonatomic,assign,readonly) LYPullRefreshPosition refreshPostion;

@end


#pragma mark UIView for pullRefresh 

typedef NS_ENUM(NSUInteger, LYPullRefreshState) {
    LYPullRefreshStateStopped = 0,
    LYPullRefreshStateTriggered,
    LYPullRefreshStateLoading,
    LYPullRefreshStateAll = 10
};
@interface LYPullRefreshView : UIView
/**
 *  if you want to custom your refreshView you  should overwirte this method
 */
@property (nonatomic) LYPullRefreshState state;

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,weak,readonly) UIScrollView *scrollView;
- (instancetype)initWithPostion:(LYPullRefreshPosition)position;

@end