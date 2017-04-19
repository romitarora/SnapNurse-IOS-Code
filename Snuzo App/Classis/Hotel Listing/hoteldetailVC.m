//
//  hoteldetailVC.m
//  Snuzo App
//
//  Created by Oneclick IT on 8/31/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "hoteldetailVC.h"
#import "ScrollCell.h"
#import "ConfirmBookVC.h"
#import "NurseDetailCell.h"
#import "AHTagTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface hoteldetailVC ()<MFMailComposeViewControllerDelegate>
{
    NSMutableArray * imgArr;
}
@end

@implementation hoteldetailVC
@synthesize titleStr,specializationArr,priceStr,isFromBookingList,nurseStartTime,imgUrlStr;

#pragma mark Life cycle methods

-(void)viewWillAppear:(BOOL)animated
{
   // [self hideTabBar:self.tabBarController];
    
    [HeaderView removeFromSuperview];
    HeaderView=nil;
    HeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,64)];
    HeaderView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_shadow"]];
    UIImage * targetImage = [UIImage imageNamed:@"cell_shadow"];
    UIGraphicsBeginImageContextWithOptions(HeaderView.frame.size, NO, 0.f);
    [targetImage drawInRect:CGRectMake(0.f, 0.f, HeaderView.frame.size.width, HeaderView.frame.size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [HeaderView setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    
    [self.navigationController.view addSubview:HeaderView];
    
    btnBackImg =[[UIImageView alloc] initWithFrame:CGRectMake(16, 30, 12, 21)];
    btnBackImg.image=[UIImage imageNamed:@"back"];
    btnBack=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    btnBack.backgroundColor=[UIColor clearColor];
    [HeaderView addSubview:btnBackImg];
    
    [HeaderView addSubview:btnBack];
    
    lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(42,30, self.view.frame.size.width-84,21)];
    lbltitle.font=[UIFont boldSystemFontOfSize:18.0];
    lbltitle.textColor=[UIColor whiteColor];
    lbltitle.textAlignment=NSTextAlignmentCenter;
    lbltitle.text=titleStr;
    lbltitle.layer.shadowColor = [[UIColor blackColor] CGColor];
    lbltitle.layer.shadowOpacity = 0.5;
    lbltitle.shadowOffset = CGSizeMake(12,12);
    [HeaderView addSubview:lbltitle];

    
    if([strisfromAnimity isEqualToString:@"YES"])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        strisfromAnimity=@"NO";
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }

}

-(void)setViewFrame
{
    serviceCount = 0;
    [self gethoteldetails];
    
    [bottomView removeFromSuperview];
    
    [mainImgHeader removeFromSuperview];
    mainImgHeader = [[UIView alloc] init];
    mainImgHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 210);
    mainImgHeader.backgroundColor = [UIColor clearColor];
    
    
    bottomView=nil;
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,imghotel.frame.size.height-40,self.view.frame.size.width,40)];
    bottomView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_shadow_down@2x copy"]];
    UIImage * targetImage1 = [UIImage imageNamed:@"cell_shadow_down@2x copy"];
    UIGraphicsBeginImageContextWithOptions(bottomView.frame.size, NO, 0.f);
    [targetImage1 drawInRect:CGRectMake(0.f, 0.f, bottomView.frame.size.width, bottomView.frame.size.height)];
    UIImage * resultImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:resultImage1]];
    
    
    rateVw = [RateView rateViewWithRating:0.0];
    rateVw.hidden=YES;
    
    rateVw.frame = CGRectMake(10,10, 120, 30);
    rateVw.starSize=15;
    rateVw.starNormalColor = [UIColor whiteColor];
    
    btnRate=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRate.frame=CGRectMake(0,10,130,30);
    [btnRate addTarget:self action:@selector(RateClicked) forControlEvents:UIControlEventTouchUpInside];
    btnRate.backgroundColor=[UIColor clearColor];
    
    priceLbl = [[UILabel alloc] init];
    priceLbl.frame = CGRectMake(self.view.frame.size.width-150, 3, 140, 30);;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textAlignment = NSTextAlignmentRight;
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    priceLbl.layer.shadowOpacity = 0.2;
    shadow.shadowOffset = CGSizeMake(0.5, 1);
    
    priceLbl.text=[NSString stringWithFormat:@"$ %@  %@ Hrs",priceStr,_hours];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:priceLbl.text];
    NSRange range2 = [priceLbl.text rangeOfString:[NSString stringWithFormat:@" %@ Hrs",_hours]];
    
    NSRange range1 = [priceLbl.text rangeOfString:[NSString stringWithFormat:@"$ %@",priceStr]];
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName : shadow}
                            range:range1];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName : shadow}
                            range:range2];
    
    priceLbl.attributedText = attributedText;
    
    
    [mainImgHeader addSubview:imghotel];
    [mainImgHeader addSubview:bottomView];
    [bottomView addSubview:rateVw];
    [bottomView addSubview:btnRate];
    [bottomView addSubview:priceLbl];
    
    [bottomView bringSubviewToFront:imghotel];
    
    [tblcontent setTableHeaderView:mainImgHeader];
}
-(void)viewWillDisappear:(BOOL)animated
{
   // [self showTabBar:self.tabBarController];
    if ([strisfromAnimity isEqualToString:@"YES"])
    {
        
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    lbltitle.text = @"";
    [HeaderView removeFromSuperview];
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarFrameWillChange:)name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    
}
- (void)statusBarFrameWillChange:(NSNotification*)notification
{
    // respond to changes
    NSLog(@"STATUS BAR UPDATED");
    NSDictionary *statusBarDetail = [notification userInfo];
    NSValue *animationCurve = statusBarDetail[UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarFrameBeginRect = [animationCurve CGRectValue];
    int statusBarHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) ? statusBarFrameBeginRect.size.height : statusBarFrameBeginRect.size.width;
    
    if (statusBarHeight == 40)
    {
        [UIView animateWithDuration:0.25 animations:^{
            bookNurseBtn.frame = CGRectMake(0, viewHeight-40, self.view.frame.size.width, 40);
            tblcontent.frame=CGRectMake(0,0, self.view.frame.size.width, (viewHeight)-40);
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            bookNurseBtn.frame = CGRectMake(0, viewHeight-40, self.view.frame.size.width, 40);
            tblcontent.frame=CGRectMake(0,0, self.view.frame.size.width, (viewHeight)-40);        }];
        
    }
    // NSLog(@"status bar height  %d", statusBarHeight);
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationBackgroundRefreshStatusDidChangeNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    timeArray=[[NSMutableArray alloc]initWithObjects:@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM",@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",nil];
    
    maintime=[[NSMutableArray alloc]init];
    for (int i=0; i<timeArray.count; i++)
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:[timeArray objectAtIndex:i ] forKey:@"Time"];
        [dict setObject:[NSString stringWithFormat:@"%02d",i] forKey:@"ServerTime"];
        if (i<24)
        {
            [dict setObject:[NSString stringWithFormat:@"%02d:00:00",i] forKey:@"FomateTime"];
        }
        else
        {
            [dict setObject:[NSString stringWithFormat:@"%02d:00:00",i-24] forKey:@"FomateTime"];
        }
        [maintime addObject:dict];
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    //For main image;
    imghotel=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)];
    imghotel.image = [UIImage imageNamed:@"iTunesArtwork@1x"];
    imghotel.backgroundColor=[UIColor whiteColor];
    imghotel.contentMode = UIViewContentModeScaleAspectFit;
//    imghotel.autoresizingMask =UIViewAutoresizingFlexibleWidth;
//    ( UIViewAutoresizingFlexibleBottomMargin
//     | UIViewAutoresizingFlexibleHeight
//     | UIViewAutoresizingFlexibleLeftMargin
//     | UIViewAutoresizingFlexibleRightMargin
//     | UIViewAutoresizingFlexibleTopMargin
//     | UIViewAutoresizingFlexibleWidth );
    imghotel.clipsToBounds=YES;
    
    topImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topImg.backgroundColor=[UIColor whiteColor];
    topImg.alpha=0.45;
    
    ///Main Table=
   tblcontent = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, (viewHeight)-40 ) style:UITableViewStylePlain];
    tblcontent.backgroundColor=[UIColor clearColor];
    tblcontent.separatorStyle=NO;
    tblcontent.delegate=self;
    tblcontent.dataSource=self;
    tblcontent.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblcontent.separatorColor=[UIColor clearColor];
    [self.view addSubview:tblcontent];
    
    
    bookNurseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
   bookNurseBtn.frame=CGRectMake(0, viewHeight-40, kScreenWidth,40);
    bookNurseBtn.layer.borderColor=[UIColor blackColor].CGColor;
    bookNurseBtn.backgroundColor=globelColor;
    [bookNurseBtn setTitle:@"BOOK NURSE" forState:UIControlStateNormal];
    [bookNurseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // bookNurseBtn.layer.cornerRadius=5;
    bookNurseBtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12];
//    [bookNurseBtn addTarget:self action:@selector(bookclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookNurseBtn];
    

    
    if (isFromBookingList)
    {
        [bookNurseBtn setTitle:@"CANCEL BOOKING" forState:UIControlStateNormal];
        [bookNurseBtn addTarget:self action:@selector(cancelBooking:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [bookNurseBtn setTitle:@"BOOK NURSE" forState:UIControlStateNormal];
         [bookNurseBtn addTarget:self action:@selector(bookclick:) forControlEvents:UIControlEventTouchUpInside];
    }

    imgArr =[[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg", nil];
    [self clearcart];
    
    UINib *nib = [UINib nibWithNibName:@"AHTagTableViewCell" bundle:nil];
    [tblcontent registerNib:nib forCellReuseIdentifier:@"cell"];
   
    [self setViewFrame];
}

#pragma mark -- Set Scroll Image

-(void)setscroll
{
    double  intrate;
    NSString  *rate;
    rate=[hoteldetail valueForKey:@"average_ratings"];
    intrate= [rate doubleValue];
    rateVw.hidden=NO;
    rateVw.rating=intrate;
}

#pragma mark Click to cala
-(void)contactclick
{
     NSLog(@"Click");
    
    NSString *phNo = [hoteldetail valueForKey:@"telephone"];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

#pragma mark GetHotel Details

-(void)gethoteldetails
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        
       NSString * customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        if ([customerId isEqualToString:@""]||customerId==nil)
        {
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            
            serviceCount = serviceCount + 1;
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:self.strid forKey:@"hotel_id"];
            [dict setObject:self.date forKey:@"date"];
            [dict setObject:self.hours forKey:@"hours"];
            [dict setObject:self.time forKey:@"time"];
            [dict setObject:self.strHospitalId forKey:@"hospital_id"];
            [dict setObject:customerId forKey:@"customer_id"];
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"GetallHoteldetail";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/hotelDetails" withParameters:dict];
        }
    }
    else
    {
    }
    
}

#pragma mark UrlManager Delegates

- (void)onResult:(NSDictionary *)result
{
    serviceCount = 0;
     NSLog(@"The result is...%@", result);
    if([[result valueForKey:@"commandName"] isEqualToString:@"GetallHoteldetail"])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            hoteldetail =[[NSMutableArray alloc]init];
            hoteldetail=[[[result valueForKey:@"result"]valueForKey:@"result_data"]valueForKey:@"hotels"];
            
            imagearray=[[[result valueForKey:@"result"]valueForKey:@"result_data"]valueForKey:@"photos"];
            
            Roomarray=[[[result valueForKey:@"result"]valueForKey:@"result_data"]valueForKey:@"rooms"];
            

            NSURL *url = [NSURL URLWithString:[[[[[result valueForKey:@"result"]valueForKey:@"result_data"]valueForKey:@"photos"]objectAtIndex:0]valueForKey:@"main" ]];
            
           // imghotel.contentMode = UIViewContentModeScaleAspectFit;
            if (![url isEqual:[NSNull null]])
            {
                imghotel.imageURL=url;
                imgUrlStr = [NSString stringWithFormat:@"%@",url];
            }
            else
            {
                imghotel.imageURL=@"NA";
                imgUrlStr = [NSString stringWithFormat:@"NA"];
            }
            
            lbltitle.text=[hoteldetail valueForKey:@"hotel_name"];
            strdesc=[hoteldetail valueForKey:@"description"];
            strEmail=[hoteldetail valueForKey:@"hotel_email"];
            strAddress=[hoteldetail valueForKey:@"address"];
            strMobileNo=[hoteldetail valueForKey:@"telephone"];

            latStr = [hoteldetail valueForKey:@"lat"];
            lonStr = [hoteldetail valueForKey:@"lon"];
            
            CGSize totalLengh =[self sizeOfMultiLineLabelWithText:[hoteldetail valueForKey:@"description"] andGivenWidth:300  withFontSize:12];
            
            if (totalLengh.height>40)
            {
                tablehieght=totalLengh.height;
            }
            else
            {
                tablehieght=totalLengh.height;
            }
            [tblcontent reloadData];
            [self setscroll];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        }
        else
        {
            [tblcontent reloadData];
            [self setscroll];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if([[result valueForKey:@"commandName"]isEqualToString:@"addtocart"])
    {
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];

        if ([[[result valueForKey:@"result"] valueForKey:@"result"]isEqualToString:@"true"])
        {
            
            payment *paymentViewController = [[payment alloc] initWithNibName:nil bundle:nil];
            paymentViewController.strHotelName=titleStr;
            paymentViewController.Price=priceStr;
            paymentViewController.hours=_hours;
            paymentViewController.strHotelID=self.strid;
            paymentViewController.strProfileUrl = imgUrlStr;
            paymentViewController.strHospitalId = self.strHospitalId;
            [self.navigationController pushViewController:paymentViewController animated:YES];
            
            /*ConfirmBookVC *confBook = [[ConfirmBookVC alloc]init];
            confBook.searchdetailarray=[self.searchdetailarray mutableCopy];
            confBook.hotelname=[hoteldetail valueForKey:@"hotel_name"];
            confBook.strContact=[hoteldetail valueForKey:@"telephone"];
            confBook.strLat=[hoteldetail valueForKey:@"lat"];
            confBook.strlon=[hoteldetail valueForKey:@"lon"];
            confBook.imageurl=[[imagearray objectAtIndex:0]valueForKey:@"main"];
            [self.navigationController pushViewController:confBook animated:YES];*/
        }
        else
        {
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[[result valueForKey:@"result"]valueForKey:@"msg"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
             [alert showWithAnimation:URBalertAnimationType];;
        }
    }
    else if([[result valueForKey:@"commandName"]isEqualToString:@"Clearcart"])
    {
        if ([[[result valueForKey:@"result"] valueForKey:@"result"]isEqualToString:@"true"])
        {
//            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];

        }
        
    }
    else if ([[result valueForKey:@"commandName"]isEqualToString:@"NurseSpecilaization"])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        if ([[[result valueForKey:@"result"] valueForKey:@"result"]isEqualToString:@"true"])
        {
            
            specializationArr = [[result valueForKey:@"result"] valueForKey:@"service"];
            [tblcontent reloadData];
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        }
    }
}
- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    //    [app hudEndProcessMethod];
     NSLog(@"Hotel detail The error is...%@", error);
    
    NSInteger ancode = [error code];
    
    if (ancode == -1009)
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:@"There is no network connectivity. This application requires a network connection." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
        
    }
    else if(ancode == -1001)
    {
        if (isError == NO)
        {
            isError = YES;
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:@"The request time out." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
                [alertView hideWithCompletionBlock:^{
                    isError = NO;
                }];
            }];
            
            [alert showWithAnimation:URBalertAnimationType];;
            
        }
        else
        {
            
        }
    }
    else if(ancode == -1005)
    {
        
    }
    else
    {
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        
//         [alert showWithAnimation:URBalertAnimationType];;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"GetallHoteldetail"])
        {
            if (serviceCount >=3)
            {
                serviceCount = 0;
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"" message:@"Something went wrong please try again later." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                [self gethoteldetails];
                
            }
        }
    }

}
#pragma mark ----amininty Click

-(void)btnanimityClick
{
    
    
    strisfromAnimity=@"YES";
    
     NSLog(@"Click");
    
    /*animitysView *anmity=[[animitysView alloc]init];
    anmity.strHotelId=self.strid;
    [self.navigationController pushViewController:anmity animated:YES];
    
    */
    
    
    
    animitysView *anmity=[[animitysView alloc]init];
    anmity.strHotelId=self.strid;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:anmity];
    
    

    
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark  back btn click

-(void)btnBackClick
{
    if (isincart)
    {
            if (isClicked)
            {
                isClicked=YES;
            }
            else
            {
                isClicked=YES;
                [self clearcart];
                isincart=NO;
                [self.navigationController popViewControllerAnimated:YES];
            }
    }
    else
    {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)clearcart
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        NSString *customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setValue:customerId forKey:@"login_user_id"];
        URLManager *manager = [[URLManager alloc] init];
        manager.commandName = @"Clearcart";
        manager.delegate = self;
        [manager urlCall:@"http://snapnurse.com/webservice/clearAllCartDetails" withParameters:dict];
    }
    else
    {
        
    }
}
-(void)hotelClick:(id)sender
{
    
    NSURL *url1 = [NSURL URLWithString:[[imagearray objectAtIndex:[sender tag]]valueForKey:@"main" ]];
    imghotel.imageURL=url1;
    
//    imghotel.image=[UIImage imageWithData:data];

}
#pragma mark - UITableview Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.row==0 || indexPath.row == 2 || indexPath.row == 7|| indexPath.row == 9 ||indexPath.row == 11)
    {
        return 30;
    }
    else if (indexPath.row == 1)
    {
         CGSize totalLengh =[self sizeOfMultiLineLabelWithText:strdesc andGivenWidth:300  withFontSize:12];;
        if (totalLengh.height <80)
        {
            return totalLengh.height+20;
        }
        else
        {
            return totalLengh.height+10;
        }
        
    }
    else if(indexPath.row == 10)
    {
        return 100;
    }
    
    else if(indexPath.row ==12)
    {
         return UITableViewAutomaticDimension;
    }
    else
    {
        return 35;
    }
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5)
    {
        return 50;
    }
    return 30;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
//    v.textLabel.textColor = [UIColor clearColor];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NurseDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[NurseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
            
    }
    
    if (indexPath.row == 0)
    {
        cell.titleLbl.text = @"Description";
        cell.titleLbl.hidden = NO;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
    }
    else if (indexPath.row == 1)
    {
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
        cell.descriptionLbl.backgroundColor = [UIColor clearColor];
        cell.descriptionLbl.text = strdesc;
        
         CGSize totalLengh =[self sizeOfMultiLineLabelWithText:cell.descriptionLbl.text andGivenWidth:cell.frame.size.width-20  withFontSize:12];
        
        if (totalLengh.height <80)
        {
              cell.descriptionLbl.frame = CGRectMake(15, 0, cell.frame.size.width-15, totalLengh.height+20);
        }
        else
        {
              cell.descriptionLbl.frame = CGRectMake(15, 0, cell.frame.size.width-15, totalLengh.height+10);
        }
    }
    else if (indexPath.row == 2)
    {
        cell.titleLbl.text = @"Contact Detail";
        cell.titleLbl.hidden = NO;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
        
    }
    else if (indexPath.row == 3)
    {
        id name = titleStr ;
        NSString *nameStr = @"";
        if (name != [NSNull null])
        {
            nameStr = (NSString *)name;
            
        }
        else
        {
            nameStr = @"NA";
        }
        
        cell.descriptionLbl.text = nameStr;
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = NO;
        cell.linelbl.hidden = NO;
        cell.linelbl.frame = CGRectMake(40, 34, tableView.frame.size.width-40, 1);
        cell.iconImgView.frame = CGRectMake(10, 7.5, 20, 20);
        cell.iconImgView.image = [UIImage imageNamed:@"f-l-name"];
        cell.descriptionLbl.frame = CGRectMake(40, 0, tableView.frame.size.width-40,35);
    }
    else if (indexPath.row == 4)
    {
        id email = strEmail ;
        NSString *emailStr = @"";
        if (email != [NSNull null])
        {
            emailStr = (NSString *)email;
            
        }
        else
        {
            emailStr = @"NA";
        }
        
        
        cell.descriptionLbl.text = emailStr;
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = NO;
        cell.linelbl.hidden = NO;
        cell.linelbl.frame = CGRectMake(40, 34, tableView.frame.size.width-40, 1);
        cell.iconImgView.frame = CGRectMake(10, 10.5, 20, 14);
        cell.iconImgView.image = [UIImage imageNamed:@"email.png"];
        cell.descriptionLbl.frame = CGRectMake(40, 0, tableView.frame.size.width-40,35);
    }
    else if (indexPath.row == 5)
    {
        id mobile = strMobileNo ;
        NSString *mobileStr = @"";
        if (mobile != [NSNull null])
        {
            mobileStr = (NSString *)mobile;
            
        }
        else
        {
            mobileStr = @"NA";
        }
        cell.descriptionLbl.text = mobileStr;
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = NO;
        cell.linelbl.hidden = NO;
        cell.linelbl.frame = CGRectMake(40, 34, tableView.frame.size.width-40, 1);
        cell.iconImgView.frame = CGRectMake(15, 7, 10, 21);
        cell.iconImgView.image = [UIImage imageNamed:@"phone.png"];
        cell.descriptionLbl.frame = CGRectMake(40, 0, tableView.frame.size.width-40,35);
    }
    else if (indexPath.row == 6)
    {
        id address = strAddress ;
        NSString *addressStr = @"";
        if (address != [NSNull null])
        {
            addressStr = (NSString *)address;
            
        }
        else
        {
            addressStr = @"NA";
        }
        cell.descriptionLbl.text = addressStr;
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = NO;
        cell.linelbl.hidden = NO;
        cell.linelbl.frame = CGRectMake(40, 34, tableView.frame.size.width-40, 1);
        cell.iconImgView.frame = CGRectMake(14, 7.5, 14, 20);
        cell.iconImgView.image = [UIImage imageNamed:@"destination.png"];
        cell.descriptionLbl.frame = CGRectMake(40, 0, tableView.frame.size.width-40,35);
    }
    else if (indexPath.row == 7)
    {
        cell.titleLbl.text = @"Hospital Details";
        cell.titleLbl.hidden = NO;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
    }
    else if (indexPath.row == 8)
    {
        id hospital = self.strHospitalName ;
        NSString *hospitalStr = @"";
        if (hospital != [NSNull null])
        {
            hospitalStr = (NSString *)hospital;
        }
        else
        {
            hospitalStr = @"NA";
        }
        cell.descriptionLbl.text = hospitalStr;
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = NO;
        cell.linelbl.hidden = NO;
        cell.linelbl.frame = CGRectMake(40, 34, tableView.frame.size.width-40, 1);
        cell.iconImgView.frame = CGRectMake(12, 6.5, 22, 22);
        cell.iconImgView.image = [UIImage imageNamed:@"hos._icon.png"];
        cell.descriptionLbl.frame = CGRectMake(40, 0, tableView.frame.size.width-40,35);
    }
    else if (indexPath.row == 9)
    {
        cell.titleLbl.text = @"Details";
        cell.titleLbl.hidden = NO;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
    }
    else if (indexPath.row == 10)
    {
        cell.titleLbl.hidden = YES;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
        
            int y=15;
            for (int k=1; k<=3; k++)
            {
                if (k==1)
                {
                    cell.lblCheckinTime.frame=CGRectMake(40, y-1, tableView.frame.size.width-35, 20);
                    cell.lblCheckinTime.textColor=globelColor;
                    cell.lblCheckinTime.textAlignment=NSTextAlignmentLeft;
                    cell.lblCheckinTime.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                    
                    cell.imgcheckinimg.frame=CGRectMake(12,y, 16, 16);
                    cell.imgcheckinimg.image=[UIImage imageNamed:@"date_white"];
                    cell.lblCheckinTime.text=@"Date";
                    
                    cell.lblcheckinTimeDure.frame=CGRectMake(tableView.frame.size.width-80, y-1, 80, 20);
                    cell.lblcheckinTimeDure.textColor=[UIColor blackColor];
                    cell.lblcheckinTimeDure.font=[UIFont systemFontOfSize:15];
                    cell.lblcheckinTimeDure.textAlignment=NSTextAlignmentLeft;
                    cell.lblcheckinTimeDure.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                    
                    NSString *strdate;
                    
                    id date = self.date;
                    
                    if (date != [NSNull null])
                    {
                        strdate = (NSString *)date;
                        NSArray * startArr = [strdate componentsSeparatedByString:@" "];
                        
                        NSString *stryear;
                        stryear=[startArr objectAtIndex:0];
                        NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
                        [dFrmt setDateFormat:@"YYYY-MM-dd"];
                        NSString * str1 =stryear;
                        NSDate * startD =[dFrmt dateFromString:str1];
                        [dFrmt setDateFormat:@"MM-dd-YYYY"];
                        NSString *strdate1=[NSString stringWithFormat:@"%@",[dFrmt stringFromDate:startD]];
                        cell.lblcheckinTimeDure.text=strdate1;
                    }
                    else
                    {
                        strdate=@"NA";
                        cell.lblcheckinTimeDure.text=strdate;
                    }
                    
                    
                    
                }
                else if (k==2)
                {
                    cell.lblcheckindateDure.frame=CGRectMake(40, y-1, tableView.frame.size.width-35, 20);
                    cell.lblcheckindateDure.textColor=globelColor;
                    cell.lblcheckindateDure.textAlignment=NSTextAlignmentLeft;
                    cell.lblcheckindateDure.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                    cell.lblcheckindateDure.text=@"Time";
                    
                    cell.imgcheckindateimg.frame=CGRectMake(12,y, 16, 16);
                    cell.imgcheckindateimg.image=[UIImage imageNamed:@"checkin-time.png"];
                    
                    cell.lblCheckindate.frame=CGRectMake(tableView.frame.size.width-80, y-1, 80, 20);
                    cell.lblCheckindate.textColor=[UIColor blackColor];
                    cell.lblCheckindate.font=[UIFont systemFontOfSize:15];
                    cell.lblCheckindate.textAlignment=NSTextAlignmentLeft;
                    cell.lblCheckindate.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                    
                    NSString *strdate;
                    id date = nurseStartTime;
                    
                    if (date != [NSNull null])
                    {
                        strdate = (NSString *)date;
                       
                        cell.lblCheckindate.text=strdate;
                    }
                    else
                    {
                        strdate=@"NA";
                        cell.lblCheckindate.text=strdate;
                    }
                    
                }
                else if (k==3)
                {
                    
                    cell.lblDuration.frame=CGRectMake(40, y-1, tableView.frame.size.width-35, 20);
                    cell.lblDuration.textColor=globelColor;
                    cell.lblDuration.textAlignment=NSTextAlignmentLeft;
                    cell.lblDuration.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                    cell.lblDuration.text=@"Duration";
                    cell.imgduration.frame=CGRectMake(12,y, 16, 16);
                    cell.imgduration.image=[UIImage imageNamed:@"duration.png"];
                    cell.lbldurationTime.frame=CGRectMake(tableView.frame.size.width-80, y-1, 80, 20);
                    cell.lbldurationTime.textColor=[UIColor blackColor];
                    cell.lbldurationTime.font=[UIFont systemFontOfSize:15];
                    cell.lbldurationTime.textAlignment=NSTextAlignmentLeft;
                    cell.lbldurationTime.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                    NSString *strdur = @"";
                    
                    id time = self.hours;
                    
                    if (time != [NSNull null])
                    {
                        strdur = (NSString *)time;
                        if ([strdur isEqualToString:@"1"])
                        {
                            cell.lbldurationTime.text=[NSString stringWithFormat:@"%@ Hr",strdur];
                        }
                        else
                        {
                            cell.lbldurationTime.text=[NSString stringWithFormat:@"%@ Hrs",strdur];
                        }
                        
                       
                    }
                    else
                    {
                        strdur=@"NA";
                        cell.lbldurationTime.text=strdur;
                    }
                    
                }
                y=y+12+15;
                
                
            }
        
        
    }
    else if (indexPath.row == 11)
    {
        cell.titleLbl.text = @"Specialization";
        cell.titleLbl.hidden = NO;
        cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
    }
    else if (indexPath.row == 12)
    {
        cell.titleLbl.hidden = YES;
         cell.iconImgView.hidden = YES;
        cell.linelbl.hidden = YES;
        
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell1.selectionStyle= UITableViewCellSelectionStyleNone;
       [self configureCell:cell1 atIndexPath:indexPath];
        return cell1;
    }
   
    
    return cell;
}
- (void)configureCell:(id)object atIndexPath:(NSIndexPath *)indexPath {
//    if (![object isKindOfClass:[AHTagTableViewCell class]])
//    {
//        return;
//    }
    AHTagTableViewCell *cell = (AHTagTableViewCell *)object;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.label.tags = specializationArr;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 || indexPath.row == 2 || indexPath.row == 7 || indexPath.row == 9|| indexPath.row == 11)
    {
        cell.backgroundColor=[UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 4)
    {
        id email = strEmail ;
        NSString *emailStr = @"";
        if (email != [NSNull null])
        {
            emailStr = (NSString *)email;
            [self sendEmailTo:emailStr withSubject:@"" withMessage:@"" forNavController:self.navigationController];
        }
        else
        {
            emailStr = @"NA";
        }

    }
    else if (indexPath.row == 5)
    {
        id mobile = strMobileNo ;
        NSString *mobileStr = @"";
        if (mobile != [NSNull null])
        {
            mobileStr = (NSString *)mobile;
            NSString * tempStr=[NSString stringWithFormat:@"tel://%@",mobileStr];
            tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            tempStr = [tempStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            tempStr = [tempStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            tempStr = [tempStr stringByReplacingOccurrencesOfString:@"-" withString:@""];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[tempStr stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        }
        else
        {
            mobileStr = @"NA";
        }

        
    }
    else if (indexPath.row == 6)
    {
        id lattitudeValue = latStr ;
        NSString * lat, * lon;
        if (lattitudeValue != [NSNull null])
        {
            lat = (NSString *)lattitudeValue;
        }
        
        id longitudeValue = lonStr ;
        if (longitudeValue != [NSNull null])
        {
            lon = (NSString *)longitudeValue;
        }
        
        MapClass *map=[[MapClass alloc]init];
        map.strlat=lat;
        map.strlon=lon;
        map.strname=titleStr;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:map];
        [self presentViewController:nav animated:YES completion:nil];

    }
}

- (void)sendEmailTo:(NSString *)emailId withSubject:(NSString*)subject withMessage:(NSString*)message forNavController:(UINavigationController *)nav
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc]init];
        [emailComposer setMailComposeDelegate:self];
        
        [[emailComposer navigationBar] setTintColor:globelColor];//Oneclick07-06-2016
        [[emailComposer navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];//Oneclick07-06-2016
        
        [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        if (emailId)
        {
            [emailComposer setToRecipients:@[emailId]];
        }
        [emailComposer setSubject:subject];
        
        [emailComposer setMessageBody:message isHTML:NO];
        
        [nav presentViewController:emailComposer animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Device does not have email functionality");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"mail cencelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"mail cencelled");
            break;
        case MFMailComposeResultSent:
            NSLog(@"mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"mail failed");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark-- Rate button Clicked

-(void)RateClicked
{
    
    strisfromAnimity=@"YES";

    RateVc *Rate=[[RateVc alloc]init];
//    if (imagearray.count>0)
//    {
        Rate.strHotelImage=imgUrlStr;
   // }
    
    Rate.strId=_strid;
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:Rate];
    [self presentViewController:nav animated:YES completion:nil];
   
}
#pragma mark Address button clicked
-(void)AddressClicked:(id)sender
{
    strisfromAnimity=@"YES";
    MapClass *map=[[MapClass alloc]init];
    map.strlat=[hoteldetail valueForKey:@"lat"];
    map.strlon=[hoteldetail valueForKey:@"lon"];
    map.strname=[hoteldetail valueForKey:@"hotel_name"];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:map];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark ----count Line
-(void)bookclick:(id)sender
{
    UIButton *button = (UIButton *)sender;
     NSLog(@"%ld",(long)button.tag);
    NSString *customerId;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
    }
    else
    {
        customerId=Nil;
    }
    if (customerId==nil||customerId.length==0)
    {
         URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Login !" message:@"Please login first." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
         alert.tag=0;
         [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
         {
             [alertView hideWithCompletionBlock:
              ^{
                  LoginVC *SignUp=[[LoginVC alloc]init];
                  SignUp.isfromBooking=@"YES";
                  [self.navigationController pushViewController:SignUp animated:YES];
              }];
         }];
          [alert showWithAnimation:URBalertAnimationType];;
    }
    else
    {
        NSMutableArray * startArr=[[NSMutableArray alloc]init];
        startArr= [[self.time componentsSeparatedByString:@":"]mutableCopy];
        if (self.hours.length==1)
        {
            self.hours=[NSString stringWithFormat:@"0%@",self.hours];
        }
        NSString *strtime;
        for (int i=0; i<maintime.count; i++)
        {
            if ([[[maintime objectAtIndex:i]valueForKey:@"ServerTime"]isEqualToString:self.time])
            {
                strtime=[[maintime objectAtIndex:i]valueForKey:@"FomateTime"];
                
            }
        }
        NSString *strdate=[self.searchdetailarray valueForKey:@"date"];
        NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
        [dFrmt setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dFrmt setDateFormat:@"YYYY-MM-dd"];
        NSString * str1 =strdate;
        NSDate * startD =[dFrmt dateFromString:str1];
        NSString *strdate1=[NSString stringWithFormat:@"%@",startD];
        NSMutableArray * datearaay=[[NSMutableArray alloc]init];
        datearaay= [[strdate1 componentsSeparatedByString:@" "]mutableCopy];
        strdate1=[NSString stringWithFormat:@"%@",[datearaay objectAtIndex:0]];
        strtime = [strdate1 stringByAppendingString:[NSString stringWithFormat:@" %@",strtime]];
        NSDateFormatter *df =[[NSDateFormatter alloc]init];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *checkout=[df dateFromString:strtime];
        int duration = [self.hours  intValue];
        NSTimeInterval secondsInEightHours = duration * 60 * 60;
        NSDate *checkoutdate = [checkout dateByAddingTimeInterval:secondsInEightHours];
        NSString *strcheckoutdate=[NSString stringWithFormat:@"%@",checkoutdate];
        NSString * strcheck = strcheckoutdate;
        NSArray * strcheckoutarray = [strcheck componentsSeparatedByString:@" "];
        strcheckoutdate=[NSString stringWithFormat:@"%@ %@",[strcheckoutarray objectAtIndex:0],[strcheckoutarray objectAtIndex:1]];
         NSLog(@"%@",strcheckoutdate);
        
        NSString *strTime=strcheckoutdate;
        
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *bookdate=[formater dateFromString:strTime];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:strTime];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitDay|NSCalendarCalendarUnit|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
        
        NSDate *now = [[NSDate alloc] init];
        NSString *strEndDate=[dateFormatter stringFromDate:now];
        NSDate *currentDate = [dateFormatter dateFromString:strEndDate];
        NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
        NSDateComponents *components1 = [calendarCurrent components:(NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitDay|NSCalendarCalendarUnit|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:currentDate];
        
        
        NSInteger bookedhour = [components hour];
        NSInteger CurrentHour = [components1 hour];
        
        if ([components year] == [components1 year])
        {
            
            if ([components month]==[components1 month])
            {
                
                if ([components day] == [components1 day])
                {
                    
                    if (CurrentHour+1>=bookedhour)
                    {
                        
                        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry, booking time past the current time. Please try again.." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else
                    {
                        
                        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                        [dict setObject:self.strid forKey:@"hotel_id"];
                        [dict setObject:customerId forKey:@"customer_id"];
                        [dict setObject:@"1" forKey:@"room_id"];
                        [dict setObject:[[Roomarray objectAtIndex:button.tag]valueForKey:@"price"]forKey:@"price"];
                        [dict setObject:strdate1 forKey:@"check_in_date"];
                        [dict setObject:strtime forKey:@"check_in_time"];
                        [dict setObject:strcheckoutdate forKey:@"check_out_time"];
                        [dict setObject:[NSString stringWithFormat:@"%d",duration] forKey:@"duration"];
                        [dict setObject:@"0" forKey:@"room_beds"];
                        [dict setObject:self.strHospitalId forKey:@"hospital_id"];
                        
                        NSLog(@"%@",dict);
                        
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                        URLManager *manager = [[URLManager alloc] init];
                        manager.commandName = @"addtocart";
                        manager.delegate = self;
                        [manager urlCall:@"http://snapnurse.com/webservice/addCarts" withParameters:dict];//Jam02-08-2016
                    }
                }
                else if (([components day] <= [components1 day]))
                {
                    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry, booking time past the current time. Please try again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                    [dict setObject:self.strid forKey:@"hotel_id"];
                    [dict setObject:customerId forKey:@"customer_id"];
                    [dict setObject:@"1" forKey:@"room_id"];
                    [dict setObject:[[Roomarray objectAtIndex:button.tag]valueForKey:@"price"]forKey:@"price"];
                    [dict setObject:strdate1 forKey:@"check_in_date"];
                    [dict setObject:strtime forKey:@"check_in_time"];
                    [dict setObject:strcheckoutdate forKey:@"check_out_time"];
                    [dict setObject:[NSString stringWithFormat:@"%d",duration] forKey:@"duration"];
                    [dict setObject:@"0" forKey:@"room_beds"];
                    [dict setObject:self.strHospitalId forKey:@"hospital_id"];
                    
                    NSLog(@"%@",dict);
                    
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                    URLManager *manager = [[URLManager alloc] init];
                    manager.commandName = @"addtocart";
                    manager.delegate = self;
                    [manager urlCall:@"http://snapnurse.com/webservice/addCarts" withParameters:dict];//Jam02-08-2016
                    
                }
                
            }
            else if ([components month]>=[components1 month])
            {
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:self.strid forKey:@"hotel_id"];
                [dict setObject:customerId forKey:@"customer_id"];
                [dict setObject:@"1" forKey:@"room_id"];
                [dict setObject:[[Roomarray objectAtIndex:button.tag]valueForKey:@"price"]forKey:@"price"];
                [dict setObject:strdate1 forKey:@"check_in_date"];
                [dict setObject:strtime forKey:@"check_in_time"];
                [dict setObject:strcheckoutdate forKey:@"check_out_time"];
                [dict setObject:[NSString stringWithFormat:@"%d",duration] forKey:@"duration"];
                [dict setObject:@"0" forKey:@"room_beds"];
                [dict setObject:self.strHospitalId forKey:@"hospital_id"];
                
                NSLog(@"%@",dict);
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"addtocart";
                manager.delegate = self;
                [manager urlCall:@"http://snapnurse.com/webservice/addCarts" withParameters:dict];//Jam02-08-2016
            }
        }
        else if ([components year] >= [components1 year])
        {
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:self.strid forKey:@"hotel_id"];
            [dict setObject:customerId forKey:@"customer_id"];
            [dict setObject:@"1" forKey:@"room_id"];
            [dict setObject:[[Roomarray objectAtIndex:button.tag]valueForKey:@"price"]forKey:@"price"];
            [dict setObject:strdate1 forKey:@"check_in_date"];
            [dict setObject:strtime forKey:@"check_in_time"];
            [dict setObject:strcheckoutdate forKey:@"check_out_time"];
            [dict setObject:[NSString stringWithFormat:@"%d",duration] forKey:@"duration"];
            [dict setObject:@"0" forKey:@"room_beds"];
            [dict setObject:self.strHospitalId forKey:@"hospital_id"];
            
            NSLog(@"%@",dict);
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"addtocart";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/addCarts" withParameters:dict];//Jam02-08-2016
        }
        else
        {
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry, booking time past the current time. Please try again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}
-(void)ConformClick
{
    
    
   
}
#pragma mark - cancel booking
-(void)cancelBooking:(id)sender
{
    
}
#pragma mark ----count Line

-(CGSize)sizeOfMultiLineLabelWithText:(NSString*)givenString andGivenWidth:(CGFloat)givenWidth withFontSize:(int)givenFontSize
{
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = givenString;
    
    //Label font
    UIFont *aLabelFont = [UIFont systemFontOfSize:givenFontSize];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = givenWidth;

    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        //Return the calculated size of the Label
        return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : aLabelFont } context:nil].size;
    }
    else
    {
        //version < 7.0
        return [aLabelTextString sizeWithFont:aLabelFont constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
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
