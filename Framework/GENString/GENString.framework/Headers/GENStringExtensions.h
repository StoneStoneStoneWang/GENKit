//
//  NSString+GEN.h
//  GENString
//
//  Created by 王磊 on 2020/4/25.
//  Copyright © 2020 王磊. All rights reserved.
//


@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GENQR)

+ (CIImage *)createQRCodeWithUrlString:(NSString *)urlString;

+ (UIImage *)createNonInterpolatedUIImageWithCIImage:(CIImage *)image
                                             andSize:(CGFloat) size;

@end

@interface NSString (GENEmpty)

- (BOOL)GENEmpty;

//bool GENisEmpty(NSString *argu);

- (BOOL)GENEmptyByTrimming;

@end

@interface NSString (GENValid)
/*
 @param phone
 @result 长度11 首位为1的手机号为真
 */
+ (BOOL)GENValidPhone:(NSString *)phone;

- (BOOL)GENValidPhone;

/*
 @param email
 @result 正则表达式
 */
+ (BOOL)GENValidEmail:(NSString *)email;

- (BOOL)GENValidEmail;


@end

typedef NS_ENUM(NSInteger ,GENDateType) {

    GENDateTypeFull , // yyyy-MM-dd hh:mm:ss

    GENDateTypeLong, // yyyy-MM-dd hh:mm

    GENDateTypeDate  // 下一个是时间 几分钟前。。 昨天 几天前
};

@interface NSString (GENDateConvert)

- (NSString *)GENConvertToDate;

- (NSString *)GENConvertToDate:(GENDateType )type;


@end
NS_ASSUME_NONNULL_END
