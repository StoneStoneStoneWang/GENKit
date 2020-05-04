//
//  GENAMap.h
//  GENAMap
//
//  Created by 王磊 on 2020/5/2.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENAMap.
FOUNDATION_EXPORT double GENAMapVersionNumber;

//! Project version string for GENAMap.
FOUNDATION_EXPORT const unsigned char GENAMapVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GENAMap/PublicHeader.h>
#import <MAMapKit/MAMapKit.h>
@import AMapFoundationKit;
NS_ASSUME_NONNULL_BEGIN


#pragma mark ---- GENAMap
NS_SWIFT_NAME(GENAMap)
@interface GENAMap : NSObject

+ (void)registerApiKey:(NSString *)apiKey;

@end

#pragma mark ---- GENSearch
@import AMapSearchKit;

typedef void(^GENRegeoSearchBlock)(NSString *city,NSString *street);

typedef void(^GENTipSearchBlock)(NSArray<AMapTip *> *tips);
NS_SWIFT_NAME(GENSearch)
@interface GENSearch : NSObject

- (void)GENGeoSearchResp:(AMapGeoPoint *)location andResp:(GENRegeoSearchBlock) resp;

/* 根据关键字来搜索POI. */
- (void)onTipSearchRespWithKeywords:(NSString *) keywords andCity:(NSString *)city andResp:(GENTipSearchBlock) resp;

/* 根据ID来搜索POI. */
- (void)GENTipSearchRespWithID:(NSString *)uid;

@property (nonatomic ,strong ,readonly) AMapSearchAPI *searchApi;

@end

#pragma mark ---- GENLocation
@import AMapLocationKit;
@import CoreLocation;
typedef void(^GENLocationBlock)(CLLocation *_Nullable location);
NS_SWIFT_NAME(GENLocation)
@interface GENLocation : NSObject

@property (nonatomic ,strong ,readonly) AMapLocationManager *GENAmlocation;

@property (nonatomic ,strong ,readonly) CLLocationManager *cllocation;

- (void)requestLocationWithReGeocodeWithCompletionBlock:(AMapLocatingCompletionBlock)completionBlock;

@property (nonatomic ,assign) CLAuthorizationStatus authStatus;

// 开始定位
- (void)GENStartLocation:(GENLocationBlock )location;

// 停止定位
- (void)GENStopLocation;

@end
#pragma mark ---- GENAMapView


NS_SWIFT_NAME(GENAMapView)
@interface GENAMapView : MAMapView

@property (nonatomic ,assign) CGFloat GENLeftResp;

@end

NS_ASSUME_NONNULL_END

