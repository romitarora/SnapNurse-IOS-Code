//
//  Splash_VC.m
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "Splash_VC.h"
#import "AppDelegate.h"
#import "SIgnupVC.h"
#import "ViewController.h"
#import "NotificationVC.h"
@interface Splash_VC ()

@end

@implementation Splash_VC
@synthesize isfromNotify;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    NSLog(@"My Device Token =%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] );
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, self.view.frame.size.height)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];
    
    
    isHomeclick=YES;
    isArroundclick=NO;
    isprofileclick=NO;
    isBookingclick=NO;
    
    [self finishSplash];
    
    // Do any additional setup after loading the view.
}

-(void)finishSplash
{
    
    AppDelegate * ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    home=[[HomeVC alloc]init];
    ArroundMe_VC *ArroundVC = [[ArroundMe_VC alloc]init];
    BookingVC *Booking = [[BookingVC alloc]init];
    LoginVC *ProfVC = [[LoginVC alloc]init];
    FaqVC *faqvc=[[FaqVC alloc]init];
    
    if (self.isfromNotify)
    {
        home.isfromNotify=YES;
    }
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.tintColor=[UIColor blackColor];
    tabBarController.tabBar.backgroundColor=[UIColor blackColor];
    tabBarController.delegate=self;
    tabBarController.tabBar.backgroundImage=[UIImage imageNamed:@"footer"];
   // tabBarController.tabBar.backgroundColor = globelColor;
    
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
    
    
    NSArray* controllers = [NSArray arrayWithObjects: Home,  ArroundNav,bokkingNav, ProfileNav,faqnav, nil];
    [tabBarController setViewControllers: controllers animated:NO];
    [tabBarController setSelectedIndex:3];
    [ap.window addSubview:tabBarController.view];
    
    // Set bar button tint color to app theme color
    [[UIBarButtonItem appearance] setTintColor:[UIColor clearColor]];
    // Set Tab Bar Items Selected Tint color to App Theme Color
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:37.0/255.0 alpha:1.0]];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:37.0/255.0 alpha:1.0]];
   // [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
     NSLog(@"dsfs");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
