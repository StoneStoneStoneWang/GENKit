//
//  GENNavigationController.h
//  ZNavi
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GENBarButtonItemExtensions.h"
#import "GENNavigationBarExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GENNavigationConfig <NSObject>

@property (nonatomic ,assign) CGFloat GENFontSize;

@property (nonatomic ,strong) UIColor *GENNormalTitleColor;

@property (nonatomic ,strong) UIColor *GENLoginTitleColor;

@property (nonatomic ,strong) UIColor *GENNormalBackgroundColor;

@property (nonatomic ,strong) UIColor *GENLoginBackgroundColor;

@property (nonatomic ,copy) NSString *GENNormalBackImage;

@property (nonatomic ,copy) NSString *GENLoginBackImage;

@end

@interface GENNavigationController : UINavigationController

+ (void)initWithConfig:(id <GENNavigationConfig>) config;

@end

NS_ASSUME_NONNULL_END
