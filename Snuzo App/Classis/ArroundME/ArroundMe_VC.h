//
//  ArroundMe_VC.h
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Constant.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAnnotation.h"
#import "URLManager.h"
//#import "AppDelegate.h"

@interface ArroundMe_VC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,URLManagerDelegate>
{
    CLLocationManager * locationManager;
    NSInteger tags;
    NSInteger previosTag;
    NSInteger serviceCount;

    
    
}

@property(nonatomic,strong)    MKMapView *_mapView;
;

@end
