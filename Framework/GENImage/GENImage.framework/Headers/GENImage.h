//
//  GENImage.h
//  GENImage
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENImage.
FOUNDATION_EXPORT double GENImageVersionNumber;

//! Project version string for GENImage.
FOUNDATION_EXPORT const unsigned char GENImageVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENImage/PublicHeader.h>


#import <GENImage/GENImageExtensions.h>

#define GEN_IMAGE_CREATE(name) [UIImage imageNamed: name]

#define GEN_IMAGE_CREATE_HEXVALUE(hexValue) [UIImage GENTransformFromHexValue: hexValue]

#define GEN_IMAGE_CREATE_ALPHA_HEXVALUE(hexValue) [UIImage GENTransformFromAlphaHexValue: hexValue]

#define GEN_IMAGE_CREATE_COLOR(color) [UIImage GENTransformFromColor: color]
