//
//  ArroundMe_VC.m
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "ArroundMe_VC.h"
#import "AppDelegate.h"
@interface ArroundMe_VC ()

@end
@implementation ArroundMe_VC
{

}
@synthesize _mapView;

-(void)viewWillDisappear:(BOOL)animated
{
    _mapView.showsUserLocation=NO;
    _mapView.delegate=nil;
    _mapView=nil;
    [_mapView removeFromSuperview];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    {
        
        [super viewDidLoad];
        [self.navigationItem setHidesBackButton:YES];
        self.view.backgroundColor=[UIColor whiteColor];
        self.navigationItem.title = @"Around Me";
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:globelColor}];

        //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:37.0/255.0 alpha:1.0]];
        
        _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
        _mapView.delegate=self;
        _mapView.mapType=MKMapTypeStandard;

        self.view=_mapView;
        
        _mapView.showsUserLocation=YES;
        
        /*-----------Start Location Manager----------*/
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; //
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
        }
        [locationManager startUpdatingLocation];
        
        
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];

        [self performSelector:@selector(zoomInToMyLocation)
                   withObject:nil
                   afterDelay:0];
        
    }
}
- (void)viewDidLoad
{
    
}
#pragma mark -- Zoom To user Location i

-(void)zoomInToMyLocation
{
    [self performSelector:@selector(gethotel)
               withObject:nil
               afterDelay:0.5];
}

#pragma  mark-- get nere by Hotel============
-(void)gethotel
{
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%f",_mapView.region.center.latitude] forKey:@"lat"];
    [dict setValue:[NSString stringWithFormat:@"%f",_mapView.region.center.longitude] forKey:@"lon"];
    //[dict setValue:@"64.8436884" forKey:@"lat"];
   // [dict setValue:@"-147.7277888" forKey:@"lon"];
    [dict setValue:@"" forKey:@"start"];
    
    NSLog(@"AroundByMeDict %@",dict);
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getcurrentBokking";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/getHotelAroundByMe"withParameters:dict];

}
- (void)onResult:(NSDictionary *)result
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
     NSLog(@"The result is...%@", result);
    
    if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
    {
        
        
        NSMutableArray *data =[[NSMutableArray alloc]init];
        
        data=[[[result valueForKey:@"result"]valueForKey:@"data"]mutableCopy];
        
        
//        [_mapView removeAnnotations:_mapView.annotations];
        
        for (int i=0; i<data.count; i++)
        {
            
            NSString *strlat=[[[data objectAtIndex:i]valueForKey:@"hotels" ]valueForKey:@"lat"];
            NSString *strlong=[[[data objectAtIndex:i]valueForKey:@"hotels" ]valueForKey:@"lon"];
            
            
            double lat;
            double lon;
            
            
            lat =[strlat doubleValue];
            lon=[strlong doubleValue];
            
            CLLocationCoordinate2D pinlocation;
            pinlocation.latitude = lat; //set latitude of selected coordinate ;
            pinlocation.longitude = lon;//set longitude of selected coordinate;
            
            
            NSMutableArray *anoomation =[[NSMutableArray alloc]init];
            anoomation=[_mapView.annotations mutableCopy];
//             NSLog(@"anmoctions %@",anoomation);
            
            {
                
                for (CustomAnnotation *annotation in _mapView.annotations)
                {
                    // if we don't need this one, don't add it, just return, and we'll check the next one
                    
                    if ([annotation isKindOfClass:[CustomAnnotation class]])
                        if (lat == annotation.coordinate.latitude &&
                            lon == annotation.coordinate.longitude)
                        {
                            return;
                        }
                }
                
                
                MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithCoordinate:pinlocation addressDictionary:nil];
                CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithPlacemark:mPlacemark];
                annotation.title = [[[data objectAtIndex:i]valueForKey:@"hotels" ]valueForKey:@"hotel_name"];
                annotation.phone = [NSString stringWithFormat:@"Contact:- %@",[[[data objectAtIndex:i]valueForKey:@"hotels" ]valueForKey:@"telephone"]];
                annotation.index=i;
                [anoomation addObject:annotation];
                
            }
            
            [_mapView addAnnotations:anoomation];
            
            // Create Annotation point
//            MKPointAnnotation *Pin = [[MKPointAnnotation alloc]init];
//            Pin.coordinate = pinlocation;
//            Pin.title = ;
//            Pin.subtitle =[NSString stringWithFormat:@"Contact:- %@",[[[data objectAtIndex:i]valueForKey:@"hotels" ]valueForKey:@"telephone"]];
//        
//            
//            ;
//            
//            [_mapView addAnnotation:Pin];
            
            
            
//            
//            
//            MKCoordinateRegion region;
//            MKCoordinateSpan span;
//            span.longitudeDelta = 0.10;
//            span.latitudeDelta=0.10;
//            
//            
//            region.span = span;
//            region.center = pinlocation;
//            
//            
//            [_mapView setRegion:region animated:TRUE];
//            [_mapView regionThatFits:region];
//            
//            
            
//            NSString *strlat=[[[data objectAtIndex:i]valueForKey:@"hotels" ]valueForKey:@"lat"];
//             NSLog(@"%@",strlat);
//            
//            
//            
//            CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
//            annotation.location=CLLocationCoordinate2DMake(10.0, 20.0);
//            
//            //initWithPlacemark:item.placemark
//            annotation.title = @"name";
//            
//            annotation.phone = @"phone";
//            
//            [_mapView addAnnotation:annotation];
        }
        
    }
    
}
- (void)onError:(NSError *)error
{
    
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName;
{
    NSLog(@"onDidFailNetwork Call");
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    NSInteger ancode = [error code];
    if(ancode == -1005)
    {
        if (serviceCount >= 3)
        {
            serviceCount = 0;
        }
        else
        {
            [self gethotel];
        }
        
    }
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self gethotel];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[CustomAnnotation class]])
    {
        return nil;
    }
    else
    {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                           reuseIdentifier:@"CustomAnnotationView"];
        
        annotationView.canShowCallout = YES;
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.canShowCallout = YES;
//        NSString *Index=annotation.index;
        
//        rightButton.tag=;
        
        annotationView.draggable = NO;
//        rightButton.backgroundColor=[UIColor redColor];
//        rightButton;
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        return annotationView;
    }
   
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    
//    [annotationView addSubview:imageView];

    
    
    
//    annotationView.canShowCallout = YES;
//    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
//    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{
    if (![view.annotation isKindOfClass:[CustomAnnotation class]])
        return;
    CustomAnnotation *annotation = (CustomAnnotation *)view.annotation;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:annotation.title forKey:@"Title"];
    [self.tabBarController setSelectedIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchHotelFromMap" object:dict];
    
}

// Animation from http://stackoverflow.com/a/7045872/1271826
-(void)writeSomething:(UIButton *)sender
{
    NSLog(@"sendr tag==%ld",(long)[sender tag]);
    
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView;
    
    for (annotationView in views) {
        
        if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        MKMapPoint point =  MKMapPointForCoordinate(annotationView.annotation.coordinate);
        if (!MKMapRectContainsPoint(_mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = annotationView.frame;
        
         annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - viewHeight, annotationView.frame.size.width, annotationView.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.4
                              delay:0.04*[views indexOfObject:annotationView]
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             annotationView.frame = endFrame;
                             
                             // Animate squash
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [UIView animateWithDuration:0.05
                                                  animations:^{
                                                      annotationView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                                                      
                                                  }
                                                  completion:^(BOOL finished){
                                                      if (finished) {
                                                          [UIView animateWithDuration:0.1 animations:^{
                                                              annotationView.transform = CGAffineTransformIdentity;
                                                          }];
                                                      }
                                                  }];
                             }
                         }];
    }
}

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    
}

- (void)didReceiveMemoryWarning
{
    _mapView.delegate=nil;
    
    _mapView=nil;
    
    [_mapView removeFromSuperview];
    
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
