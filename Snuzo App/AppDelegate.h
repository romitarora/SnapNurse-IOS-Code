//
//  AppDelegate.h
//  Snuzo App
//
//  Created by Oneclick IT on 8/6/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Splash_VC.h"
#import <Fabric/Fabric.h>
#import "URLManager.h"
#import "constant.h"
#import "NewLoginVC.h"
#import <Crashlytics/Crashlytics.h>

NSString *strisfromAnimity;
BOOL isincart;
BOOL iscustomer;
BOOL isRate;
BOOL isError;
BOOL isFromBackground;
NSInteger viewHeight;
NSMutableArray * hospitalListArr;

/*
NSString * AvenirNextLTProBold;
NSString * AvenirNextLTProBoldCn;
NSString * AvenirNextLTProBoldCnIt;
NSString * AvenirNextLTProCn;
NSString * AvenirNextLTProCnIt;
NSString * AvenirNextLTProDemi;
NSString * AvenirNextLTProDemiCn;
NSString * AvenirNextLTProDemiCnIt;
NSString * AvenirNextLTProDemiIt;
NSString * AvenirNextLTProHeavyCn;
NSString * AvenirNextLTProHeavyCnIt;
NSString * AvenirNextLTProIt;
NSString * AvenirNextLTProMediumCn;
NSString * AvenirNextLTProMediumCnIt;
NSString * AvenirNextLTProRegular;
NSString * AvenirNextLTProUltLtCn;
NSString * AvenirNextLTProUltLtCnIt;
 
 */
@class Splash_VC;
@class NewLoginVC;
@interface AppDelegate : UIResponder <UIApplicationDelegate,URLManagerDelegate,UITabBarDelegate,UITabBarControllerDelegate>
{
    Splash_VC *spl;
    UINavigationController *nav;
    NSInteger serviceCount;
    UITabBarController * tabBarController;
    NSTimer * _timerSplash;
    BOOL isfromNotify;
}
@property (strong, nonatomic) UIWindow *window;
-(void)hudForprocessMethod;
-(void)hudEndProcessMethod;
-(UIColor*)colorWithHexString:(NSString*)hex;
-(void)setUpTabBarController;


@end

