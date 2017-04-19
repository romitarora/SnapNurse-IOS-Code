//
//  PastBokkingView.m
//  Snuzo App
//
//  Created by Oneclick IT on 9/3/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "PastBokkingView.h"
#import "AppDelegate.h"
@interface PastBokkingView ()

@end

@implementation PastBokkingView
-(void)viewWillAppear:(BOOL)animated
{
   // [self hideTabBar:self.tabBarController];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor=[UIColor grayColor];
    
    self.navigationItem.title = @"Past Booking";
    
   
    
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];

    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
  

    
    
    
    
     pastbookView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,viewHeight-157)];
    pastbookView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:pastbookView];
    
    
    int y=0;
    AsyncImageView *imghotel=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 159)];
    imghotel.image=[UIImage imageNamed:@""];
    imghotel.image = [UIImage imageNamed:@"iTunesArtwork@1x"];
    if (![self.strURl isEqual:[NSNull null]])
    {
        NSURL *url=[NSURL URLWithString:self.strURl];
        imghotel.imageURL=url;
    }
 
    [pastbookView addSubview:imghotel];
    
    y=y+169;
    
    lblHotelname=[[UILabel alloc]initWithFrame:CGRectMake(8, y, self.view.frame.size.width-8, 15)];
    lblHotelname.textColor=[UIColor whiteColor];
    lblHotelname.text=self.strname;
    lblHotelname.font=[UIFont fontWithName:@"AvenirNextLTPro-bold" size:16];
    [pastbookView addSubview:lblHotelname];
    
    y=y+31;
    
    UIImageView *imgaddress=[[UIImageView alloc]initWithFrame:CGRectMake(8, y, 8, 13)];
    imgaddress.image=[UIImage imageNamed:@"address"];
    [pastbookView addSubview:imgaddress];
    
    lblHoteladdress=[[UILabel alloc]initWithFrame:CGRectMake(28, y-1,self.view.frame.size.width-28, 17)];
    lblHoteladdress.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:10];
    lblHoteladdress.textColor=[UIColor whiteColor];
    
    lblHoteladdress.text=self.straddress;
        NSString *straddress=self.straddress;
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:straddress];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3.5];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [straddress length])];
    lblHoteladdress.attributedText = attrString;
    
    [pastbookView addSubview:lblHoteladdress];
    
    
    y=y+40;
    
    UIImageView *imgcontact=[[UIImageView alloc]initWithFrame:CGRectMake(8, y, 12,12)];
    imgcontact.image=[UIImage imageNamed:@"contact"];
    [pastbookView addSubview:imgcontact];
    y=y+1;
    
    
    
    lblContact=[[UILabel alloc]initWithFrame:CGRectMake(28, y, self.view.frame.size.width-20, 10)];
    lblContact.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:10];
    lblContact.text=@"0202 450 6788";
    
    
    
    lblContact.textColor=[UIColor whiteColor];
    //    lblHoteladdress.backgroundColor=[UIColor redColor];
    
    lblContact.numberOfLines=2;
    [pastbookView addSubview:lblContact];
    
    
    
    
    
    
    
    
    
    
    
    

    
    // Do any additional setup after loading the view.
}



#pragma mark --- Back buttonClick

-(void)BackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
     //[self showTabBar:self.tabBarController];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) hideTabBar:(UITabBarController *) tabbarcontroller
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 568, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 667, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 736, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 568)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 667)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 736)];
            }
        }
    }
    
    [UIView commitAnimations];
    
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 519, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 618, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 687, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 519)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 618)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 687)];
            }
        }
    }
    [UIView commitAnimations];
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
