//
//  GENHud.h
//  GENHud
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENHud.
FOUNDATION_EXPORT double GENHudVersionNumber;

//! Project version string for GENHud.
FOUNDATION_EXPORT const unsigned char GENHudVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENHud/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GENHud)
@interface GENHud : NSObject

+ (void)configHud NS_SWIFT_NAME(configHud());

+ (void)showActivity NS_SWIFT_NAME(show());

+ (void)showInfo:(NSString *_Nonnull)msg;

+ (void)showWithStatus:(NSString * _Nullable)msg;

+ (void)pop NS_SWIFT_NAME(pop());

@end

NS_ASSUME_NONNULL_END
