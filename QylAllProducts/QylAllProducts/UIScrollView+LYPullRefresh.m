//
//  UIScrollView+LYPullRefresh.m
//  QylAllProducts
//
//  Created by lqy on 15/5/24.
//  Copyright (c) 2015年 lqy. All rights reserved.
//

#import "UIScrollView+LYPullRefresh.h"

@interface LYPullRefreshView ()

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation LYPullRefreshView

@synthesize state = _state;

- (instancetype)initWithPostion:(LYPullRefreshPosition)position{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initViews{
    _indicatorView = [[UIActivityIndicatorView alloc] init];
}

- (void)startAnimation{
    [_indicatorView startAnimating];
}

- (void)stopAnimation{
    [_indicatorView stopAnimating];
}

- (void)setState:(LYPullRefreshState)state{
    switch (state) {
        case LYPullRefreshStateStopped:
            
            break;
        case LYPullRefreshStateLoading:
            
            break;
        case LYPullRefreshStateTriggered:
            
            break;
        case LYPullRefreshStateAll:
            
            break;
            
        default:
            break;
    }
}

#pragma mark keypath for UIScrollView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}

@end


#pragma mark UIScrollView to refresh

#import <objc/runtime.h>

static char UIScrollViewLYPullRefreshView;
@implementation UIScrollView (LYPullRefresh)

#pragma mark runtime for add pullRefreshView
@dynamic pullRefreshView,refreshPostion;

- (void)setPullRefreshView:(LYPullRefreshView *)pullRefreshView{
    
    [self willChangeValueForKey:@"pullRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewLYPullRefreshView, pullRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pullRefreshView"];
    
}
- (LYPullRefreshView *)pullRefreshView{
    return objc_getAssociatedObject(self, &UIScrollViewLYPullRefreshView);
}

#pragma mark private funtions
- (void)addPullRefreshWithActionHandler:(void (^)(void))actionHandler{
    [self addPullRefreshWithActionHandler:actionHandler position:LYPullRefreshPositionTop];
}
- (void)addPullRefreshWithActionHandler:(void (^)(void))actionHandler position:(LYPullRefreshPosition)position{
    
    [self addPullRefreshWithActionHandler:actionHandler position:position refreshView:nil];
}
- (void)addPullRefreshWithActionHandler:(void (^)(void))actionHandler position:(LYPullRefreshPosition)position refreshView:(LYPullRefreshView *)refreshView{
    if (!refreshView) {
        LYPullRefreshView *refreshView = [[LYPullRefreshView alloc] initWithPostion:position];
        self.pullRefreshView = refreshView;
        
        CGFloat yOrigin = 0, xOrigin = 0;
        switch (position) {
            case LYPullRefreshPositionTop:
                yOrigin = -LYPullRefreshViewHeight;
                break;
            case LYPullRefreshPositionBottom:
                yOrigin = self.contentSize.height;
                break;
            case LYPullRefreshPositionLeft:
                
                break;
            case LYPullRefreshPositionRight:
                break;
            default:
                return;
        }
        refreshView.frame = CGRectMake(xOrigin, yOrigin, self.bounds.size.width,LYPullRefreshViewHeight);
        refreshView.scrollView = self;
        [self addSubview:refreshView];
        
        // 需要设置观察
    }
    
    NSAssert(refreshView && [refreshView isKindOfClass:[LYPullRefreshView class]], @"必须设置并且为LYPullRefreshView 类型view");
    
}

- (void)setEnablePullRefresh:(BOOL)enableRefresh{
    self.pullRefreshView.hidden = !enableRefresh;
    
    if (enableRefresh) {
        //obversing
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}



@end


