//
//  MapClass.m
//  Snuzo App
//
//  Created by Oneclick IT on 10/19/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import "MapClass.h"

@interface MapClass ()


@end



@implementation MapClass
@synthesize strlat,strlon,strname,_mapView;


-(void)viewWillAppear:(BOOL)animated
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    _mapView.showsUserLocation=NO;
    
    
    _mapView.delegate=nil;
    
    _mapView=nil;
    
    [_mapView removeFromSuperview];
    strisfromAnimity=@"YES";
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor grayColor];
    
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.translucent=NO;
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];

    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;

    self.navigationItem.leftBarButtonItem=backbarBtn;
    
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    
    
    
    self.navigationItem.title=strname;
    
   UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];
    
    
    
    
    _mapView.showsUserLocation=NO;
    _mapView.delegate=nil;
    _mapView=nil;
    _mapView=nil;
    [_mapView removeFromSuperview];
    
   
    _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, viewHeight-64)];

    _mapView.delegate=self;
    _mapView.mapType=MKMapTypeStandard;
    
    self.view=_mapView;
    
    _mapView.showsUserLocation=NO;


    
    [self performSelector:@selector(dropPin)
               withObject:nil
               afterDelay:0.5];
    
    // Do any additional setup after loading the view.
}


-(void)dropPin
{
    
    double lat;
    double lon;
    
    lat =[strlat doubleValue];
    lon=[strlon doubleValue];
    CLLocationCoordinate2D pinlocation;
    pinlocation.latitude = lat;
    pinlocation.longitude = lon;
    
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:pinlocation addressDictionary:nil];
    annotation.title = strname;
    [_mapView addAnnotation:annotation];

    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.5, 0.5);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [_mapView setVisibleMapRect:zoomRect animated:YES];
    _mapView.camera.altitude *= 10.0;


}
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[CustomAnnotation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"CustomAnnotationView"];
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
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
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    

    
    
//    DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
//    controller.annotation = view.annotation;
//    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//    self.popover.delegate = self;
//    [self.popover presentPopoverFromRect:view.frame
//                                  inView:view.superview
//                permittedArrowDirections:UIPopoverArrowDirectionAny
//                                animated:YES];
}
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    
}

- (void)didReceiveMemoryWarning {
    _mapView.delegate=nil;
    
    _mapView=nil;
    
    [_mapView removeFromSuperview];
    
    [super didReceiveMemoryWarning];
    
}
#pragma mark ---Back btn Click

-(void)BackBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
