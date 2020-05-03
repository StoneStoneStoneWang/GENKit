//
//  GENTab.h
//  GENTab
//
//  Created by 王磊 on 2020/5/2.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENTab.
FOUNDATION_EXPORT double GENTabVersionNumber;

//! Project version string for GENTab.
FOUNDATION_EXPORT const unsigned char GENTabVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENTab/PublicHeader.h>

@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface GENTabController : UITabBarController

- (void)GENAddChildViewController:(UIViewController *)childController
                      andTitle:(NSString *)title
                andNormalColor:(NSString *)normalColor
              andSelectedColor:(NSString *)selectedColor
                andNormalImage:(NSString *)normalImage
                andSelectImage:(NSString *)selectImage;

@end

NS_ASSUME_NONNULL_END
