//
//  GENString.h
//  GENString
//
//  Created by 王磊 on 2020/5/2.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENString.
FOUNDATION_EXPORT double GENStringVersionNumber;

//! Project version string for GENString.
FOUNDATION_EXPORT const unsigned char GENStringVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENString/PublicHeader.h>


#import <GENString/GENStringExtensions.h>

#define GEN_COLOR_FORMAT_STRING(arg1,arg2) [NSString stringWithFormat:@"%@%@",arg1,arg2]
