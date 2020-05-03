//
//  GENYY.h
//  GENYY
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENYY.
FOUNDATION_EXPORT double GENYYVersionNumber;

//! Project version string for GENYY.
FOUNDATION_EXPORT const unsigned char GENYYVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENYY/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN

@class YYCache;

NS_SWIFT_NAME(GENYY)
@interface GENYY : NSObject

+ (instancetype)shared;

@property (nonatomic ,strong , readonly) YYCache *cache;

- (void)createCache:(NSString *)name;

- (void)saveObj:(id<NSCoding>)obj withKey:(NSString *)key;

- (nullable id <NSCoding>)fetchObj:(NSString *)key;

- (BOOL)checkEnv;

@end

NS_ASSUME_NONNULL_END
