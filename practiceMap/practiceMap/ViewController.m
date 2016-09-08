//
//  ViewController.m
//  02、MKMapView添加标注视图
//
//  Created by kinglinfu on 16/9/7.
//  Copyright © 2016年 tens. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) void(^geocodeComplatHandle)(NSString *name);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestAction:)];
    
    [self.mapView addGestureRecognizer:longGest];
    
    self.mapView.showsUserLocation = YES;
    
    if ([CLLocationManager instanceMethodForSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (void)longGestAction:(UILongPressGestureRecognizer *)longGest {
    
    // 1、获取触摸点所在地图上的CGPoint坐标
    CGPoint point = [longGest locationInView:self.mapView];
    
    // 2、将地图所在触摸点的坐标 CGPoint 转为对应的经纬度 CLLocationCoordinate2D
    CLLocationCoordinate2D coordinate2D = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    if (longGest.state == UIGestureRecognizerStateBegan) {
        
        // 3、创建并添加一个标注视图到mapView上
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = @"XXXX";
        annotation.coordinate = coordinate2D;
        annotation.subtitle = [NSString stringWithFormat:@"%f, %f",annotation.coordinate.latitude, annotation.coordinate.longitude];
        
        [self setGeocodeComplatHandle:^(NSString *locationName) {
            
            annotation.title = locationName;
        }];
        
        [self geocoder:coordinate2D];
        
        //4、将标注添加到地图上
        [self.mapView addAnnotation:annotation];
        
    }
}


#pragma mark - 地理位置编码
- (void)geocoder:(CLLocationCoordinate2D)coordinate2D {
    
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    // 创建一个经纬度位置 CLLocation
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    
    // 1、通过经纬度获取对应的地理位置，查询位置是一个异步操作
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSLog(@"%@ %@ %@",placemark.name, placemark.thoroughfare,placemark.subThoroughfare);
        
        // 将地理位置名称显示在标注视图上
        if (self.geocodeComplatHandle) {
            
            self.geocodeComplatHandle(placemark.name);
        }
    }];
    
}


- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
    }
    
    return _locationManager;
}


#pragma mark - <MKMapViewDelegate> {

// 用户位置发生改变后调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = {0.05,0.05};
    [mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
}

// 添加了标注视图后调用
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    NSLog(@"添加了标注视图后调用");
}

// 添加标注视图时调用，这里可以自定义标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    NSLog(@"viewForAnnotation");
    
    // 判断是否是用户当前的位置标注
    if (![annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        return nil;
    }
    
    static NSString *identifer = @"annotation";
    MKAnnotationView *annatationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    
    //大头针样式
    // MKPinAnnotationView *annatationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    
    if (!annatationView) {
        
        annatationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
        
        //annatationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
        
        // 是否显示辅助标注视图
        annatationView.canShowCallout = YES;
        
        // 设置大头针的颜色，前提是为MKPinAnnotationView类型
        // annatationView.pinTintColor = [UIColor orangeColor];
        
        //设置大头针出现的动画，前提是为MKPinAnnotationView类型
        //annatationView.animatesDrop = YES;
        
        // 使用图片作为标注
        annatationView.image = [UIImage imageNamed:@"icon"];
        
        // 是否可以拖拽
        annatationView.draggable = YES;
        
        // 设置标注视图的偏移
        annatationView.centerOffset = CGPointMake(0, -25);
        
        // 设置辅助视图的偏移
        annatationView.calloutOffset = CGPointMake(0, -10);
        
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        leftView.tag = 100;
        leftView.frame = CGRectMake(0, 0, 50, 50);
        // 设置左边的辅助视图
        annatationView.leftCalloutAccessoryView = leftView;
        
        // 设置右边的辅助视图
        annatationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
    }
    
    return annatationView;
}

// 点击标注视图时调用
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"didSelectAnnotationView");
}

// 点击左右辅助视图时调用
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"%@",control);
}

// 地图开始加载时调用
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    
    NSLog(@"地图开始加载时调用");
}

// 地图加载完成时调用
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    NSLog(@"地图加载完成时调用");
}

// 地图加载失败时调用
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    
    NSLog(@"地图加载失败时调用");
}

// 地图显示的范围将要发生改变时调用
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    NSLog(@"地图显示的范围将要发生改变时调用");
}

// 地图显示的范围改变后调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    NSLog(@"地图显示的范围改变后调用");
}

// 定位用户的位置失败
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    NSLog(@"定位用户的位置失败");
}

// 标注视图拖拽后调用
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    
    /** 拖拽的状态
     MKAnnotationViewDragStateNone = 0, 没有拖拽
     MKAnnotationViewDragStateStarting, 开始拖拽
     MKAnnotationViewDragStateDragging, 正在拖拽
     MKAnnotationViewDragStateCanceling, 取消拖拽
     MKAnnotationViewDragStateEnding 结束拖拽
     **/
    
    NSLog(@"didChangeDragState");
}


@end
