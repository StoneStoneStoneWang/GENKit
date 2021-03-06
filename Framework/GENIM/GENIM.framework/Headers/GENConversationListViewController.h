//
//  GENConversationListViewController.h
//  GENIM
//
//  Created by 王磊 on 2020/4/27.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GENConversationListViewController : RCConversationListViewController

@property(nonatomic,strong,readonly) UIPercentDrivenInteractiveTransition *GENInteractivePopTransition;

@property (nonatomic ,assign) BOOL canPanResponse;

@end

NS_ASSUME_NONNULL_END
