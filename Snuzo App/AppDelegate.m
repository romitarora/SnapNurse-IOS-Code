//
//  AppDelegate.m
//  Snuzo App
//
//  Created by Oneclick IT on 8/6/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GooglePlus/GooglePlus.h>
#import "Stripe.h"
#import "NotificationVC.h"
@interface AppDelegate ()
{
    MBProgressHUD * HUD;
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isError = NO;
    isFromBackground = NO;

    [self getStripeCredentials];
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        
    }
    else
    {
        [[UIApplication sharedApplication]enabledRemoteNotificationTypes];
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
   
    [self setUpTabBarController];
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
   
    [Fabric with:@[[Crashlytics class]]];
    return YES;
}
-(void)getStripeCredentials
{
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getStripeCredentials";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/getStripeCredentials" withParameters:nil];
}
-(void)clearBadgeCount
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
      NSString *  customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        if ([customerId isEqualToString:@""]||customerId==nil)
        {
        }
        else
        {
            NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
            [dict setValue:customerId forKey:@"user_id"];
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"clearBagdeCount";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/readMessage" withParameters:dict];
        }
    }
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
   /* ((UINavigationController *)((UITabBarController *)self.window.rootViewController).viewControllers[0]).navigationBarHidden=NO;
    CGSize s2 = ((UINavigationController *)((UITabBarController *)self.window.rootViewController).viewControllers[0]).navigationBar.bounds.size;
    
    [((UINavigationController *)((UITabBarController *)self.window.rootViewController).viewControllers[0]).navigationBar setFrame:CGRectMake(0, 0, s2.width, s2.height)];
    */
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""] ;
     NSLog(@"My Token =%@",deviceTokenStr);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSLog(@"content---%@", token);
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"updatedDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
   // application.applicationIconBadgeNumber = 1;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        // user has tapped notification
        NSLog(@"user has tapped notification %@", [userInfo description]);
        if (isFromBackground)
        {
            if (self.window.rootViewController.presentedViewController)
            {
                [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveNotificationtab" object:nil];
        }
        else
        {
        }
    }
    else
    {
        NSLog(@"user opened app from app icon%@", [userInfo description]);
    }
    
    NSDictionary *test =(NSDictionary *)[userInfo objectForKey:@"aps"];
    NSString *alertString =(NSString *) [test objectForKey:@"alert"];
    
    
    NSLog(@"String recieved: %@",alertString);
    NSLog(@"User Info : %@", [userInfo description]);
    NSLog(@"User Info Alert Message : %@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:ALERT_TITLE message:alertString cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView setMessageFont:[UIFont systemFontOfSize:14.0]];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        [alertView hideWithCompletionBlock:^{
        }];
    }];
    [alertView showWithAnimation:URBAlertAnimationTopToBottom];
}

#pragma mark SetFontMethod
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookEnable" object:nil];
    
    if ([[url scheme] caseInsensitiveCompare:@"fb524169904447505"] == NSOrderedSame)
    {
        return  [[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation];
    }
    else
    {
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    // naively parse url
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    isFromBackground = YES;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TimeChange" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveCalendor" object:nil];
    [self clearBadgeCount];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Hud Method
-(void)hudForprocessMethod
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    [HUD show:YES];
    
}
-(void)hudEndProcessMethod
{
    [HUD hide:YES];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
#pragma mark UrlManager Delegates
- (void)onResult:(NSDictionary *)result
{
    if([[result valueForKey:@"commandName"] isEqualToString:@"getStripeCredentials"])
    {
        if ([[[result valueForKey:@"result"] valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[result valueForKey:@"result"] valueForKey:@"data"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[[[tempArr objectAtIndex:0] valueForKey:@"stripe_global_settings"] valueForKey:@"publish_key"] forKey:@"StripPkey"];
            [[NSUserDefaults standardUserDefaults] setValue:[[[tempArr objectAtIndex:0] valueForKey:@"stripe_global_settings"] valueForKey:@"secret_key"] forKey:@"StripSkey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *Str=[[[tempArr objectAtIndex:0]valueForKey:@"stripe_global_settings"] valueForKey:@"publish_key"];
            
            NSLog(@"StripPkey %@",StripPkey);
            NSLog(@"StripSkey %@",StripSkey);
            
            [Stripe setDefaultPublishableKey:Str];
        }
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"clearBagdeCount"])
    {
         [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}
- (void)onError:(NSError *)error
{
    NSLog(@"The error is...%@", error);
    NSInteger ancode = [error code];
    if (ancode == -1009)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:@"There is no network connectivity. This application requires a network connection." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
        
    }
    else if(ancode == -1001)
    {
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:@"The request time out." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        [alert showWithAnimation:URBalertAnimationType];;
    }
    else if(ancode == -1005)
    {
        
    }
    else
    {
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        [alert showWithAnimation:URBalertAnimationType];;
    }
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    
}
#pragma mark - SetUp Tabbar
-(void)setUpTabBarController
{
    HomeVC* home=[[HomeVC alloc]init];
    ArroundMe_VC *ArroundVC = [[ArroundMe_VC alloc]init];
    BookingVC *Booking = [[BookingVC alloc]init];
    LoginVC *ProfVC = [[LoginVC alloc]init];
    FaqVC *faqvc=[[FaqVC alloc]init];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.tintColor=[UIColor blackColor];
    tabBarController.tabBar.backgroundColor=[UIColor blackColor];
    tabBarController.delegate=self;
    tabBarController.tabBar.backgroundImage=[UIImage imageNamed:@"footer"];
    // tabBarController.tabBar.backgroundColor = globelColor;
    
    if (isfromNotify)
    {
        home.isfromNotify=YES;
    }
    
    //Home Tab Bar Item And Icon
    UIImage *HomeIcon = [UIImage imageNamed:@"home-selected"];
    UIImage *HomeIconUnselected = [UIImage imageNamed:@"home"];
    UITabBarItem *HomeItem = [[UITabBarItem alloc] initWithTitle:@"" image:HomeIconUnselected selectedImage:HomeIcon];
    //    HomeItem.imageInsets = UIEdgeInsetsMake(5, 0, -6, 0);
    UINavigationController *Home = [[UINavigationController alloc] initWithRootViewController:home];
    [Home.navigationBar setTranslucent:NO];
    Home.tabBarItem = HomeItem;
    
    Home.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);;
    HomeItem.selectedImage = [HomeIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HomeItem.image =[HomeIconUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //Arround Me Tab Bar Item And Icon
    UIImage *ArroundIcon = [UIImage imageNamed:@"selected-nurse"];//
    UIImage *ArroundIconUnselected = [UIImage imageNamed:@"nurse"];
    
    UITabBarItem *ArroundMeItem = [[UITabBarItem alloc] initWithTitle:nil image:ArroundIconUnselected selectedImage:ArroundIcon];
    
    //    ArroundMeItem.imageInsets = UIEdgeInsetsMake(5, 0, -6, 0);
    
    UINavigationController *ArroundNav = [[UINavigationController alloc] initWithRootViewController:ArroundVC];
    
    [ArroundNav.navigationBar setTranslucent:NO];
    ArroundNav.tabBarItem = ArroundMeItem;
    
    ArroundNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);;
    
    ArroundMeItem.selectedImage = [ArroundIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ArroundMeItem.image =[ArroundIconUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    //Booking Tabbar Icon
    UIImage *Bookingicon = [UIImage imageNamed:@"book-selected"];//
    UIImage *BookingiconUnselected = [UIImage imageNamed:@"book"];
    UITabBarItem *BookingItem = [[UITabBarItem alloc] initWithTitle:nil image:BookingiconUnselected selectedImage:Bookingicon];
    
    UINavigationController *bokkingNav = [[UINavigationController alloc] initWithRootViewController: Booking];
    [bokkingNav.navigationBar setTranslucent:NO];
    bokkingNav.tabBarItem = BookingItem;
    bokkingNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);;
    
    BookingItem.selectedImage = [Bookingicon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BookingItem.image =[BookingiconUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //Profile Icon
    UIImage *ProfileIcon = [UIImage imageNamed:@"selected-profile.png"];//
    UIImage *ProfileIconUnselected = [UIImage imageNamed:@"Profile.png"];//
    UITabBarItem *ProfileItem = [[UITabBarItem alloc] initWithTitle:nil image:ProfileIconUnselected selectedImage:ProfileIcon];
    UINavigationController *ProfileNav = [[UINavigationController alloc] initWithRootViewController: ProfVC];
    
    [ProfileNav.navigationBar setTranslucent:NO];
    ProfileNav.tabBarItem = ProfileItem;
    
    ProfileNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);;
    ProfileItem.selectedImage = [ProfileIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ProfileItem.image =[ProfileIconUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //Faq Icon
    
    
    UIImage *faqIcon = [UIImage imageNamed:@"help-selected"];//
    UIImage *faqIconUnselected = [UIImage imageNamed:@"help"];//
    UITabBarItem *faqeItem = [[UITabBarItem alloc] initWithTitle:nil image:faqIconUnselected selectedImage:faqIcon];
    UINavigationController *faqnav = [[UINavigationController alloc] initWithRootViewController:faqvc];
    faqeItem.imageInsets = UIEdgeInsetsMake(5, 0, -6, 0);
    
    [faqnav.navigationBar setTranslucent:NO];
    faqnav.tabBarItem = faqeItem;
    faqnav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);;
    faqeItem.selectedImage = [faqIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    faqeItem.image =[faqIconUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //[tabBarController setSelectedIndex:0];
    
    NSArray* controllers = [NSArray arrayWithObjects: Home,  ArroundNav,bokkingNav, ProfileNav,faqnav, nil];
    [tabBarController setViewControllers: controllers animated:NO];
     [tabBarController setSelectedIndex:3];
    // Set bar button tint color to app theme color
    [[UIBarButtonItem appearance] setTintColor:[UIColor clearColor]];
    // Set Tab Bar Items Selected Tint color to App Theme Color
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:37.0/255.0 alpha:1.0]];
    // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:37.0/255.0 alpha:1.0]];
    // [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.window addSubview:tabBarController.view];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame __TVOS_PROHIBITED;   // in screen coordinates
{
    if (newStatusBarFrame.size.height == 40)
    {
        viewHeight = kScreenHeight - 20;
    }
    else
    {
        viewHeight = kScreenHeight ;
        
    }
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"dsfs");
    
}
@end
