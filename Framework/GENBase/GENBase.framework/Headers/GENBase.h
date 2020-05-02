//
//  GENBase.h
//  GENBase
//
//  Created by 王磊 on 2020/5/2.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENBase.
FOUNDATION_EXPORT double GENBaseVersionNumber;

//! Project version string for GENBase.
FOUNDATION_EXPORT const unsigned char GENBaseVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENBase/PublicHeader.h>


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GENBaseViewController)
@interface GENBaseViewController  : UIViewController

- (void)configNaviItem NS_SWIFT_NAME(configNaviItem());

- (void)configOwnProperties NS_SWIFT_NAME(configOwnProperties());

- (void)addOwnSubViews NS_SWIFT_NAME(addOwnSubViews());

- (void)configOwnSubViews NS_SWIFT_NAME(configOwnSubViews());

- (void)configLoading NS_SWIFT_NAME(configLoading());

- (void)configViewModel NS_SWIFT_NAME(configViewModel());

- (void)prepareData NS_SWIFT_NAME(s_prepareData());

- (void)configAuto NS_SWIFT_NAME(configAuto());

- (void)addOwnSubViewController NS_SWIFT_NAME(addOwnSubViewController());

@end

NS_ASSUME_NONNULL_END
