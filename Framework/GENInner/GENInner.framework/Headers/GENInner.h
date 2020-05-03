//
//  GENInner.h
//  GENInner
//
//  Created by 王磊 on 2020/5/2.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENInner.
FOUNDATION_EXPORT double GENInnerVersionNumber;

//! Project version string for GENInner.
FOUNDATION_EXPORT const unsigned char GENInnerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENInner/PublicHeader.h>

@import GENLoading;

NS_ASSUME_NONNULL_BEGIN

@interface GENInnerViewController : GENLoadingViewController

- (void)GENLoadHtmlString:(NSString *)htmlString NS_SWIFT_NAME(GENLoadHtmlString(htmlString:));

@property (nonatomic ,strong ,readonly) UITextView *textView;

@end

NS_ASSUME_NONNULL_END
