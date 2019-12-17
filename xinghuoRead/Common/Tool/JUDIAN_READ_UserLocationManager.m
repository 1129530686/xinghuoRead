//
//  JUDIAN_READ_UserLocationManager.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserLocationManager.h"
#import <CoreLocation/CoreLocation.h>


@interface JUDIAN_READ_UserLocationManager()<CLLocationManagerDelegate>
@property(nonatomic, strong)CLLocationManager* locationManager;
@property(nonatomic, strong)CLGeocoder *geocoder;
@end


@implementation JUDIAN_READ_UserLocationManager


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initLocationManager];
        [self initGeocoder];
    }
    
    return self;
}



- (void)startLocationService {

    NSString* message = @"请在系统设置中,启用“位置”服务";
    CLAuthorizationStatus  authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        if([CLLocationManager locationServicesEnabled]) {

            [_locationManager startUpdatingLocation];
        }
        else {
            [JUDIAN_READ_TestHelper showSystemSettingAlert:message viewController:_viewController];
        }
    }
    else if (authStatus == kCLAuthorizationStatusAuthorizedAlways || authStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    }
    else {
        [JUDIAN_READ_TestHelper showSystemSettingAlert:message viewController:_viewController];
    }
}




- (void)initLocationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        //设置代理
        [_locationManager setDelegate:self];
        //设置定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //设置距离筛选
        [_locationManager setDistanceFilter:10];
        [_locationManager startUpdatingHeading];
    }
}



- (void)initGeocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
}




-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *loc = [locations firstObject];
    //NSLog(@"定位到了");
    //维度：loc.coordinate.latitude
    //经度：loc.coordinate.longitude
    //NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    //NSLog(@"%lu",(unsigned long)locations.count);
    
    WeakSelf(that);
    [_geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        // 包含区，街道等信息的地标对象
        CLPlacemark *placemark = [placemarks firstObject];
        
        if (that.simpleLocationBlock) {
            that.simpleLocationBlock(placemark.administrativeArea, placemark.locality, placemark.subLocality);
        }
        
        if (that.detailLocationBlock) {
            NSString *address = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
            that.detailLocationBlock(address, nil, nil);
        }
        
    }];
    
    
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [_locationManager stopUpdatingLocation];
    
}



// 定位错误的代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        //访问被拒绝
        return;
    }
    
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}


@end
