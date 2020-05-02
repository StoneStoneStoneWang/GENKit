//
//  UIBarButtonItem+ZBarButtonItem.h
//  ZNavi
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (GEN)

+ (instancetype)barButtonItemWith:(UIImage *)image andTarget:(id)target andSelector:(SEL)selector;

+ (instancetype)barButtonItemWith:(NSString *)normalTitle andNormalColor:(UIColor *)normalColor andHighTitle:(NSString *)highTitle andHighColor:(UIColor *)highColor andFontSize:(CGFloat )fontSize andTarget:(id)target andSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
