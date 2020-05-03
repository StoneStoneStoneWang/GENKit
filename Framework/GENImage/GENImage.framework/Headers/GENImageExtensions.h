//
//  GENImageCata.h
//  GENImage
//
//  Created by 王磊 on 2020/4/26.
//  Copyright © 2020 王磊. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GENCast)

+ (UIImage *)GENTransformToImageForView:(UIView *)view;

+ (UIImage *)GENTransformFromHexValue:(NSString *)hexValue;

+ (UIImage *)GENTransformFromAlphaHexValue:(NSString *)hexValue;

+ (UIImage *)GENTransformFromColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
