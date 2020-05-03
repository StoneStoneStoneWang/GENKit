//
//  FBSign.h
//  FBSign
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for FBSign.
FOUNDATION_EXPORT double FBSignVersionNumber;

//! Project version string for FBSign.
FOUNDATION_EXPORT const unsigned char FBSignVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FBSign/PublicHeader.h>

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,GENSignType) {
    /** 游泳  */
    GENSignTypeLock NS_SWIFT_NAME(lock) = 0,
};

NS_ASSUME_NONNULL_BEGIN

@interface GENSign : NSObject

/** 初始化所有组件产品
 @param appKey 开发者在官网申请的appKey.
 @param domain 请求主地址
 @param ptype 类型 1.花店
 */
+ (void)initWithAppKey:(NSString * _Nonnull)appKey
                domain:(NSString * _Nonnull)domain
                 pType:(GENSignType)ptype;

+ (NSString *)createSign:(NSDictionary *_Nonnull)json;

/**
 @result signature
 */
+ (NSString *)fetchSignature;

+ (NSString *)fetchAppKey;

+ (NSString *)fetchDomain;

+ (NSString *)fetchSmsSign;

+ (NSString *)fetchSmsLogin;

+ (NSString *)fetchSmsPwd;

+ (GENSignType )fetchPType;

@end

NS_ASSUME_NONNULL_END

