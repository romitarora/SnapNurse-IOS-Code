//
//  MapClass.h
//  Snuzo App
//
//  Created by Oneclick IT on 10/19/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomAnnotation.h"

@interface MapClass : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager * locationManager;

}
@property(nonatomic,strong)NSString *strlat;
@property(nonatomic,strong)NSString *strlon;
@property(nonatomic,strong)NSString *strname;
@property(nonatomic,strong)    MKMapView *_mapView;


@end
