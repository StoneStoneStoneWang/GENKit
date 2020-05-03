//
//  GENAMapViewController.h
//  ZFragment
//
//  Created by three stone 王 on 2019/8/29.
//  Copyright © 2019 three stone 王. All rights reserved.
//
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

#pragma mark ---- GENAMapViewController
@import GENTransition;


typedef NS_ENUM(NSInteger ,GENAMapLoadType) {
    
    GENAMapLoadTypeLocationLoading,
    
    GENAMapLoadTypeLocationNoneLoading
};

NS_SWIFT_NAME(GENAMapViewController)
@interface GENAMapViewController : GENTViewController <MAMapViewDelegate>

+ (instancetype)createAMapWithLat:(CLLocationDegrees )lat andLon:(CLLocationDegrees)lon andMapLoadType:(GENAMapLoadType )loadType;

@property (nonatomic ,strong ,readonly) GENAMapView *GENMapView;

@property (nonatomic ,strong ,readonly) GENLocation *GENLocation;

@property (nonatomic ,assign) CLLocationDegrees lat;

@property (nonatomic ,assign) CLLocationDegrees lon;

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation;

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views;

- (void)GENFetchLocaiton:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
