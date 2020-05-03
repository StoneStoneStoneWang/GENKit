//
//  GENLoadingViewController.h
//  TSUIKit
//
//  Created by three stone 王 on 2018/7/10.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

@import GENTransition;
typedef NS_ENUM(NSInteger,GENLoadingStatus) {
    
    GENLoadingStatusBegin,
    
    GENLoadingStatusLoading,
    
    GENLoadingStatusSucc,
    
    GENLoadingStatusFail,
    
    GENLoadingStatusReload
};

@protocol GENLoadingViewDelegate <NSObject>

- (void)onReloadItemClick;

@end

@interface GENLoadingView : UIView

+ (instancetype)loadingWithContentViewController:(GENTViewController *)contentViewController;

/*
 设置加载状态
 GENLoadingStatusBegin 请在viewwillappear里
 GENLoadingStatusLoading 请在设置begin之后 viewwillappear里
 GENLoadingStatusSucc 加载成功
 GENLoadingStatusFail 加载失败
 GENLoadingStatusReload 重新加载 屏幕上有 点击屏幕重新加载按钮
 */
@property (nonatomic ,assign ,readonly) BOOL isLoading;

@property (nonatomic ,assign)GENLoadingStatus status;

- (void)changeLoadingStatus:(GENLoadingStatus )status;

@property (nonatomic ,weak) id<GENLoadingViewDelegate> mDelegate;


@end


@interface GENLoadingViewController : GENTViewController

@property (nonatomic ,strong ,readonly) GENLoadingView *loadingView;

@property (nonatomic ,assign) GENLoadingStatus loadingStatus;

// 重新加载
- (void)onReloadItemClick;

@end
