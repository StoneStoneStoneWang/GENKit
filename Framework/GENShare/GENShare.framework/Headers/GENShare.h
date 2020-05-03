//
//  GENShare.h
//  GENShare
//
//  Created by 王磊 on 2020/4/25.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENShare.
FOUNDATION_EXPORT double GENShareVersionNumber;

//! Project version string for GENShare.
FOUNDATION_EXPORT const unsigned char GENShareVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENShare/PublicHeader.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(GENShare)
@interface GENShare : NSObject

+ (void)GENShareDownloadWithFrom:(UIViewController * _Nonnull)from
                      andAppleId:(NSString * _Nonnull)appleId
                    andShareIcon:(NSString * _Nonnull)shareIcon;


+ (void)GENShareWithFrom:(UIViewController * _Nonnull)from
            andUrlString:(NSString * _Nonnull)urlString
            andShareIcon:(NSString * _Nonnull)shareIcon;
@end

NS_ASSUME_NONNULL_END
