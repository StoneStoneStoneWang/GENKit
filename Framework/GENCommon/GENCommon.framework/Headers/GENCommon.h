//
//  GENCommon.h
//  GENCommon
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENCommon.
FOUNDATION_EXPORT double GENCommonVersionNumber;

//! Project version string for GENCommon.
FOUNDATION_EXPORT const unsigned char GENCommonVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENCommon/PublicHeader.h>

#define GEN_SCREEN [UIScreen mainScreen]

#define GEN_SCREEN_BOUNDS [UIScreen mainScreen].bounds

#define GEN_SCREEN_SIZE GEN_SCREEN_BOUNDS.size

#define GEN_SCREEN_WIDTH GEN_SCREEN_SIZE.width

#define GEN_SCREEN_HEIGHT GEN_SCREEN_SIZE.height

#define GEN_ISIPHONEX_UP (GEN_SCREEN_HEIGHT >= 812)

#define GEN_STATUSBAR_HEIGHT (GEN_ISIPHONEX_UP ? 44 : 20)

#define GEN_TOPLAYOUTGUARD (GEN_STATUSBAR_HEIGHT + 44)

#define GEN_TABBAR_HEIGHT (GEN_ISIPHONEX_UP ? 83 : 49)

#define GEN_SCREEN [UIScreen mainScreen]

#define GEN_VIEWCONTROLLER_HEIGHT CGRectGetHeight(self.view.bounds)

#define GEN_VIEWCONTROLLER_WIDTH CGRectGetWidth(self.view.bounds)

#define GEN_VIEW_HEIGHT CGRectGetHeight(self.bounds)

#define GEN_VIEW_WIDTH CGRectGetWidth(self.bounds)

#define GEN_DEVICE [UIDevice currentDevice]

#define GEN_DEVICE_NAME GEN_DEVICE.name

#define GEN_DEVICEOS GEN_DEVICE.systemName

#define GEN_DEVICEID GEN_DEVICE.identifierForVendor.UUIDString

#define GEN_IMAGEVIEW_NEW [UIImageView new]

#define GEN_LABEL_NEW [UILabel new]

#define GEN_VIEW_NEW [UIView new]

#define GEN_BUTTON_NEW [UIButton buttonWithType:UIButtonTypeCustom]

#define GEN_SYSTEM_FONT(fontSize) [UIFont systemFontOfSize:fontSize]

#define GEN_BOLD_FONT(fontSize) [UIFont boldSystemFontOfSize:fontSize]
