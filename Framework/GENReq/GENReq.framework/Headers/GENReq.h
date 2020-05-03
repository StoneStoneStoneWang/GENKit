//
//  GENReq.h
//  GENReq
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENReq.
FOUNDATION_EXPORT double GENReqVersionNumber;

//! Project version string for GENReq.
FOUNDATION_EXPORT const unsigned char GENReqVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENReq/PublicHeader.h>


@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const GENTokenInvalidNotification;


NS_SWIFT_NAME(GENReq)
@interface GENReq : NSObject

#pragma mark ---- 121 服务器返回的错误 122 token失效 123 其他错误 124 返回的不是json
/*
 如果操作是无返回值的成功 success是空串
 */

+ (void)postWithUrl:(NSString *)url
          andParams:(NSDictionary *)params
          andHeader:(NSDictionary *)header
            andSucc:(void (^)(id _Nonnull))success
            andFail:(void (^)(NSError * _Nonnull))failure NS_SWIFT_NAME(postWithUrl(url:params:header:succ:fail:));

+ (void)postTranslateWithParams:(NSDictionary *)params
                        andSucc:(void (^)(id _Nonnull))success
                        andFail:(void (^)(NSError * _Nonnull))failure NS_SWIFT_NAME(postTranslateWithParams(params:succ:fail:));

+ (void)postAreasWithUrl:(NSString *)url
               andParams:(NSDictionary *)params
                 andSucc:(void (^)(id _Nonnull))success
                 andFail:(void (^)(NSError * _Nonnull))failure NS_SWIFT_NAME(postAreaWithUrl(url:params:succ:fail:));

+ (void)analysisSomeThing:(NSString *)lat andLon:(NSString *)lon NS_SWIFT_NAME(s_analysis(lat:lon:));


+ (void)fetchSignedWithTag:(NSString *)tag
                   andSucc:(void (^)(id _Nonnull))success
                   andFail:(void (^)(NSError * _Nonnull))failure;

+ (void)signedWithTag:(NSString *)tag
           andContent:(NSString *)content
           andEncoded:(NSString *)encoded
              andSucc:(void (^)(id _Nonnull))success
              andFail:(void (^)(NSError * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
