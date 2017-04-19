//
//  Splash_VC.h
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"
#import "BookingVC.h"
#import "ProfileVC.h"
#import "ArroundMe_VC.h"
#import "FaqVC.h"
#import "LoginVC.h"
#import "payment.h"
#import "Thanks_VC.h"


@interface Splash_VC : UIViewController<UITabBarControllerDelegate,UITabBarDelegate>
{
    HomeVC *home;
    ArroundMe_VC *arroundVC;
    UITabBarController *tabBarController;
    
    UINavigationController *nav;
    UIView *MenuView;
    BOOL isHomeclick,isArroundclick,isBookingclick,isprofileclick;
}
@property BOOL isfromNotify;
@end
