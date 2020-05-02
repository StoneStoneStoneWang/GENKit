//
//  GENColor.h
//  GENColor
//
//  Created by 王磊 on 2020/5/2.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENColor.
FOUNDATION_EXPORT double GENColorVersionNumber;

//! Project version string for GENColor.
FOUNDATION_EXPORT const unsigned char GENColorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENColor/PublicHeader.h>


#import <GENColor/GENColorExtensions.h>

#define GEN_COLOR_CREATE(hexValue) [UIColor GEN_transformToColorByHexValue:hexValue]

#define GEN_ALPHA_COLOR_CREATE(hexValue) [UIColor GEN_transformTo_AlphaColorByHexValue:hexValue]
