//
//  ConfirmBookVC.m
//  Snuzo App
//
//  Created by one click IT consultany on 9/2/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//
//#import "PaymentViewController.h"
//#import "Constants.h"
#import "ConfirmBookVC.h"
#import "ScrollCell.h"
#import "payment.h"

@interface ConfirmBookVC ()
{
    NSMutableArray * imgArr;
    
}

@end

@implementation ConfirmBookVC
@synthesize HotelDetailArray,searchdetailarray,imageurl,pricearray,hotelname,strContact,strLat,strlon,isfrombokking,cartDetails;

#pragma mark Life cycle methods

-(void)viewWillAppear:(BOOL)animated
{
    if([strisfromAnimity isEqualToString:@"YES"])
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        strisfromAnimity=@"NO";
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    //[self hideTabBar:self.tabBarController];
    
    [self getcartdetail];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isconform)
    {
    }
    else
    {
        if ([strisfromAnimity isEqualToString:@"YES"]) {
        }
        else
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
       // [self showTabBar:self.tabBarController];
    }
}
- (void)viewDidLoad
{
    timeArray=[[NSMutableArray alloc]initWithObjects:@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM",nil];
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
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:37.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.title=@"Booking info";
    self.view.backgroundColor=[UIColor blackColor];
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];
    
    //For main image;
    
    imghotel=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    imghotel.image=[UIImage imageNamed:@""];
    imghotel.image = [UIImage imageNamed:@"iTunesArtwork@1x"];
    if (![imageurl isEqual:[NSNull null]])
    {
        imghotel.imageURL = [NSURL URLWithString:imageurl];
    }
    [self.view addSubview:imghotel];
    
    topImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)];
    topImg.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    //    [self.view addSubview:topImg];
    
    lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(5,150+10, self.view.frame.size.width,21)];
    lbltitle.font=[UIFont boldSystemFontOfSize:18.0];
    lbltitle.textColor=[UIColor whiteColor];
    lbltitle.textAlignment=NSTextAlignmentLeft;
    lbltitle.text=hotelname;
    lbltitle.font=[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:18];
    
    [self.view addSubview:lbltitle];
    
    
    typeImg =[[UIImageView alloc] init];
    typeImg.image=[UIImage imageNamed:@"room"];
    typeImg.frame=CGRectMake(15-7.5,192-5, 12, 14);
    [self.view addSubview:typeImg];
    
    NSString *strrommdisc;
//    strrommdisc=[NSString stringWithFormat:@"%@ room with %@ bed",[pricearray valueForKey:@"room_name"] ,[pricearray valueForKey:@"no_of_beds"]];
    
    hotelTypeLbl=[[UILabel alloc]initWithFrame:CGRectMake(35-7.5, 192-7, self.view.frame.size.width-45, 20)];
    hotelTypeLbl.textColor=[UIColor whiteColor];
    hotelTypeLbl.textAlignment=NSTextAlignmentLeft;
    hotelTypeLbl.text=strrommdisc;
    hotelTypeLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
    [self.view addSubview:hotelTypeLbl];
    
    
    /* cell.Imgbad.image=[UIImage imageNamed:@"room"];
     
     NSString *strrommdisc;
     strrommdisc=[NSString stringWithFormat:@"%@ room with %@ bed",[pricearray valueForKey:@"room_name"] ,[pricearray valueForKey:@"no_of_beds"]];
     cell.lblpriceperhours.text= strrommdisc;
     cell.lblpriceperhours.textColor=[UIColor whiteColor];
     cell.lblpriceperhours.textAlignment=NSTextAlignmentLeft;
     cell.lblpriceperhours.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
     
     
     cell.Imgbad.frame=CGRectMake(15-7.5,y, 12, 14);
     cell.lblpriceperhours.frame=CGRectMake(35-7.5, y-2, cell.frame.size.width, 20);*/
    
    
    ///Main Table=
    
    /*
     
     UIButton *btnaddother=[UIButton buttonWithType:UIButtonTypeCustom];
     btnaddother.frame=CGRectMake(10,self.view.frame.size.height-64-45,(self.view.frame.size.width/2)-20, 40);
     
     [btnaddother setTitle:@"Add hours" forState:UIControlStateNormal];
     btnaddother.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"footer"]];
     
     
     [btnaddother addTarget:self action:@selector(addOntherClick) forControlEvents:UIControlEventTouchUpInside];
     
     
     [btnaddother setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     btnaddother.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:18];
     
     [self.view addSubview:btnaddother];
     
     
     */
    
    UIButton * confirmbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmbtn.frame=CGRectMake(10,self.view.frame.size.height-64-45, (self.view.frame.size.width)-20, 40);
    [confirmbtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmbtn setBackgroundColor:globelColor];
    [self.view addSubview:confirmbtn];
    [confirmbtn addTarget:self action:@selector(ConformClick) forControlEvents:UIControlEventTouchUpInside];
    confirmbtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:18];
    
    
    if ([isfrombokking isEqualToString:@"YES"])
    {
         NSLog(@"isfrom Booking Table");
        [tblcontent removeFromSuperview];
        tblcontent=nil;
        tblcontent=[[UITableView alloc]initWithFrame:CGRectMake(0,160+25+25, self.view.frame.size.width, self.view.frame.size.height-190-50)];
        tblcontent.backgroundColor=[UIColor clearColor];
        tblcontent.separatorStyle=normal;
        tblcontent.delegate=self;
        tblcontent.dataSource=self;
        [self.view addSubview:tblcontent];
    }
    else
    {
//        [self getcartdetail];
    }
}
-(void)getcartdetail
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    
    NSString *customerId;
    customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
    if (customerId!=nil)
    {
        [dict setObject:customerId forKey:@"login_user_id"];
    }
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"GetCart";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/getCartDetails" withParameters:dict];
}

#pragma mark- Clear Cart
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
#pragma mark Url menager Delegates

- (void)onResult:(NSDictionary *)result
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
     NSLog(@"The result is...%@", result);
    
    
    if ([[result valueForKey:@"commandName"]isEqualToString:@"GetCart"])
    {
        
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            HotelDetailArray=[[[[[result valueForKey:@"result"]valueForKey:@"data"]objectAtIndex:0]valueForKey:@"carts"]mutableCopy];
            
            roomtypearrray =[[NSMutableArray alloc]init];
            NSMutableArray *data=[[NSMutableArray alloc]init];
            data=[[[result valueForKey:@"result"]valueForKey:@"data"]mutableCopy];
            
            price=0;
            
            
            NSString *strroomtype;
            NSString *noofBad;
            for (int i=0; i<data.count; i++)
            {
                
                strroomtype=[[[data objectAtIndex:i]valueForKey:@"hotel_rooms"] valueForKey:@"room_name"];;
                noofBad=[[[data objectAtIndex:i]valueForKey:@"hotel_rooms"] valueForKey:@"no_of_beds"];
                
                NSString *strId=[[[data objectAtIndex:i]valueForKey:@"carts"]valueForKey:@"id"];
                
                NSString *strprice=[[[data objectAtIndex:i]valueForKey:@"carts" ]valueForKey:@"price"];
                
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:strroomtype forKey:@"room_name"];
                [dict setObject:noofBad forKey:@"no_of_beds"];
                [dict setObject:strId forKey:@"cart_id"];
                [dict setObject:strprice forKey:@"Price"];
                
                [roomtypearrray addObject:dict];
                
                strPrice=[[[data objectAtIndex:i]valueForKey:@"carts" ]valueForKey:@"price"];
                
                price=price+[[[[data objectAtIndex:i]valueForKey:@"carts" ]valueForKey:@"price"]integerValue];
                
                
            }
            
            NSString *strrommdisc;
            strrommdisc=[NSString stringWithFormat:@"%@ room with %@ bed",strroomtype ,noofBad];
            hotelTypeLbl.text=strrommdisc;
            
            
            
            NSString * startDate = [NSString stringWithFormat:@"%@",[HotelDetailArray valueForKey:@"check_in_time"]];
            
            
            NSString * endDate = [NSString stringWithFormat:@"%@",[HotelDetailArray valueForKey:@"check_out_time"]];
            
            
            NSArray * startArr = [startDate componentsSeparatedByString:@" "];
            NSArray * Endarr = [endDate componentsSeparatedByString:@" "];
            
            
            strmianTime =  [startArr objectAtIndex:1];
            strCheckoutTime=[Endarr objectAtIndex:1];
            
            for (int i=0; i<maintime.count; i++)
            {
                
                if ([[[maintime objectAtIndex:i]valueForKey:@"FomateTime"]isEqualToString:strmianTime])
                {
                    strmianTime=[[maintime objectAtIndex:i]valueForKey:@"Time"];
                    
                }
                
            }
            
            
            
            
            strHotelID=[HotelDetailArray valueForKey:@"hotel_id"];
            
            NSString *strcheckoutTime=[HotelDetailArray valueForKey:@"check_out_time"];
            
            NSMutableArray *ChechoutTime=[[NSMutableArray alloc]init];
            ChechoutTime =[[strcheckoutTime componentsSeparatedByString:@":"]mutableCopy];
            
            
            NSString *str=[NSString stringWithFormat:@"%@",[ChechoutTime objectAtIndex:0]] ;
            
            
            if (str.length==1)
            {
                str=[NSString stringWithFormat:@"0%@",str];
                
            }
            
            
            
            for (int i=0; i<maintime.count; i++)
            {
                /*
                 
                 if ([[[maintime objectAtIndex:i]valueForKey:@"FomateTime"]isEqualToString:strmianTime])
                 {
                 strmianTime=[[maintime objectAtIndex:i]valueForKey:@"Time"];
                 
                 }
                 */
                
                if ([[[maintime objectAtIndex:i]valueForKey:@"FomateTime"]isEqualToString:strCheckoutTime])
                {
                    strCheckoutTime=[[maintime objectAtIndex:i]valueForKey:@"Time"];
                    
                }
                
            }
            [tblcontent removeFromSuperview];
            tblcontent=nil;
            tblcontent=[[UITableView alloc]initWithFrame:CGRectMake(0,160+25+25, self.view.frame.size.width, self.view.frame.size.height-190-50-30)];
            tblcontent.backgroundColor=[UIColor clearColor];
            tblcontent.separatorStyle=normal;
            tblcontent.delegate=self;
            tblcontent.dataSource=self;
            [self.view addSubview:tblcontent];
            
            
        }
        
    }
    
    else if([[result valueForKey:@"commandName"]isEqualToString:@"Deletecart"])//
    {
        if (roomtypearrray.count==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
            isincart=NO;
            
            
        }
        else
        {
            [self getcartdetail];
        }
        
    }
    
}
- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    //    [app hudEndProcessMethod];
     NSLog(@"The error is...%@", error);
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
    else
    {
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        
//         [alert showWithAnimation:URBalertAnimationType];;
    }
    
    
}

#pragma mark Click to cala
-(void)contactclick
{
     NSLog(@"Click");
    
    NSString *phNo = strContact;//[HotelDetailArray valueForKey:@"telephone"];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}



#pragma mark Conform Button click


-(void)ConformClick
{
    
    NSString *strTime=[HotelDetailArray valueForKey:@"check_out_time"];
    
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
                    isconform=YES;
                    payment *paymentViewController = [[payment alloc] initWithNibName:nil bundle:nil];
                    paymentViewController.strHotelName=self.hotelname;
                    paymentViewController.Price=[NSString stringWithFormat:@"%@",strPrice];
                    paymentViewController.strHotelID=strHotelID;
                    [self.navigationController pushViewController:paymentViewController animated:YES];
                }
            }
            else if (([components day] <= [components1 day]))
            {
                UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry, booking time past the current time. Please try again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                isconform=YES;
                payment *paymentViewController = [[payment alloc] initWithNibName:nil bundle:nil];
                paymentViewController.strHotelName=self.hotelname;
                paymentViewController.Price=[NSString stringWithFormat:@"%@",strPrice];
                paymentViewController.strHotelID=strHotelID;
                [self.navigationController pushViewController:paymentViewController animated:YES];
                
            }
            
        }
        else if ([components month]>=[components1 month])
        {
            isconform=YES;
            payment *paymentViewController = [[payment alloc] initWithNibName:nil bundle:nil];
            paymentViewController.strHotelName=self.hotelname;
            paymentViewController.Price=[NSString stringWithFormat:@"%@",strPrice];
            paymentViewController.strHotelID=strHotelID;
            [self.navigationController pushViewController:paymentViewController animated:YES];
        }
    }
    else if ([components year] >= [components1 year])
    {
      
            isconform=YES;
            payment *paymentViewController = [[payment alloc] initWithNibName:nil bundle:nil];
            paymentViewController.strHotelName=self.hotelname;
            paymentViewController.Price=[NSString stringWithFormat:@"%@",strPrice];
            paymentViewController.strHotelID=strHotelID;
            [self.navigationController pushViewController:paymentViewController animated:YES];
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry, booking time past the current time. Please try again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
     NSLog(@"bookedHour %ld  ====  currentHour %ld",(long)bookedhour,(long)CurrentHour);
}
#pragma mark Button CLick event For Book & AddOnothe
-(void)addOntherClick
{
    if (roomtypearrray.count==0)
    {
        
    }
    else
    {
        isincart=YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
    
}

#pragma mark  back btn click


-(void)BackBtnClick
{
    
    if(roomtypearrray.count==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self clearcart];
        isincart=YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)hotelClick:(id)sender
{
    imghotel.image=[UIImage imageNamed:[imgArr objectAtIndex:[sender tag]]];
}
#pragma mark - UITableview Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return  80;
    }
    
    else if(indexPath.row==1)
    {
        return 120;
    }
    
    else if(indexPath.row==2)
    {
        return 40;
        
    }
    else if(indexPath.row==3)
    {
        return 40;
        
    }
    else
    {
        return 30;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellIdentifier = nil;//[NSString stringWithFormat:@"%ld",(long)indexPath.row];

    hoteldetailcell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[hoteldetailcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=normal;
        
    }
    if(indexPath.row==0)
    {
        
        cell.imgaddres.frame=CGRectMake(7.5, 15, 8, 13);
        cell.imgaddres.image=[UIImage imageNamed:@"address"];
        
        cell.lbladdress.frame=CGRectMake(35-7.5,13.5, cell.frame.size.width-35, 16);
        cell.lbladdress.textColor=[UIColor whiteColor];
        cell.lbladdress.font=[UIFont systemFontOfSize:12];
        
        NSInteger lenth;
        lenth=[[HotelDetailArray valueForKey:@"address"] length];
        if (lenth >= 50) {
            cell.lbladdress.frame=CGRectMake(35-7.5, 10, cell.frame.size.width-35, 32);
            cell.lbladdress.numberOfLines=2;
        }
        cell.lbladdress.text=[HotelDetailArray valueForKey:@"address"];
        
        
        cell.lbladdress.textAlignment=NSTextAlignmentLeft;
        
        
        cell.btnAddress.frame=cell.lbladdress.frame;
        [cell.btnAddress addTarget:self action:@selector(AddressClicked:)forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgcontact.frame=CGRectMake(7.5,50, 12, 12);
        cell.imgcontact.image=[UIImage imageNamed:@"contact"];
        
        
        cell.lblcontact.frame=CGRectMake(35-7.5, 45, cell.frame.size.width-35, 20);
        cell.lblcontact.textColor=[UIColor whiteColor];
        cell.lblcontact.font=[UIFont systemFontOfSize:12];
        cell.lblcontact.text=strContact;
        
        cell.lblcontact.textAlignment=NSTextAlignmentLeft;
        
        
        
        cell.btncontact.frame=CGRectMake(15, 40, cell.frame.size.width-150, 30);
        cell.btncontact.backgroundColor=[UIColor clearColor];
        [cell.btncontact addTarget:self action:@selector(contactclick) forControlEvents:UIControlEventTouchUpInside];
        
        
        double  intrate;
        NSString  *rate;
        rate=[HotelDetailArray valueForKey:@"average_ratings"];
        intrate= [rate doubleValue];

        
        cell.starImg.hidden=NO;
        cell.rateVw.hidden=NO;
        cell.rateVw.frame = CGRectMake(230, 48, 120, 30);
        cell.rateVw.starSize=15;
        cell.rateVw.rating=intrate;

       /*
        int i=0;
        for(int buttonIndex=1;buttonIndex<=5;buttonIndex++)
        {
            
            
            UIImageView * img = [UIImageView new];
            if (buttonIndex==1)
            {
                i=215;
            }
            else
            {
                i=i+16;
            }
            img.frame = CGRectMake(i,48,13,13);
            img.image=[UIImage imageNamed:@"starselected"];
            if (buttonIndex>intrate)
            {
                img.image=[UIImage imageNamed:@"star"];
                
            }
            
            [cell.contentView addSubview:img];
            
            
        }
        */
        cell.btnRate.frame=CGRectMake(215,38,80,40);
        [cell.btnRate addTarget:self action:@selector(RateClicked) forControlEvents:UIControlEventTouchUpInside];
        cell.btnRate.backgroundColor=[UIColor clearColor];
        
        
        cell.lblline.backgroundColor=[UIColor whiteColor];
        cell.lblline.frame=CGRectMake(10, 79.5, 320-05, 0.5);
        
    }
    else if (indexPath.row==1)
    {
        cell.Imgbad.hidden=YES;
        cell.lblpriceperhours.hidden=YES;
        int y=15;
        for (int k=1; k<=4; k++)
        {
            if (k==1)
            {
                cell.lblCheckinTime.frame=CGRectMake(35-7.5, y-1, cell.frame.size.width-35, 20);
                cell.lblCheckinTime.textColor=[UIColor whiteColor];
                cell.lblCheckinTime.textAlignment=NSTextAlignmentLeft;
                cell.lblCheckinTime.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.imgcheckinimg.frame=CGRectMake(15-7.5,y+2, 12, 12);
                cell.imgcheckinimg.image=[UIImage imageNamed:@"date_white"];
                cell.lblCheckinTime.text=@"Date of check-in";
                cell.lblcheckinTimeDure.frame=CGRectMake(245, y-1, 75, 20);
                cell.lblcheckinTimeDure.textColor=[UIColor whiteColor];
                cell.lblcheckinTimeDure.font=[UIFont systemFontOfSize:15];
                cell.lblcheckinTimeDure.text=@"0202 450 6788";
                cell.lblcheckinTimeDure.textAlignment=NSTextAlignmentLeft;
                cell.lblcheckinTimeDure.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                NSString *strdate=[HotelDetailArray valueForKey:@"check_in_date"];
                NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
                [dFrmt setDateFormat:@"YYYY-MM-dd"];
                NSString * str1 =strdate;
                NSDate * startD =[dFrmt dateFromString:str1];
                [dFrmt setDateFormat:@"MMM d,yyyy"];
                NSString *strdate1=[NSString stringWithFormat:@"%@",[dFrmt stringFromDate:startD]];
                cell.lblcheckinTimeDure.text=strdate1;
            }
            else if (k==2)
            {
                cell.lblcheckindateDure.frame=CGRectMake(35-7.5, y-1, cell.frame.size.width-35, 20);
                cell.lblcheckindateDure.textColor=[UIColor whiteColor];
                cell.lblcheckindateDure.textAlignment=NSTextAlignmentLeft;
                cell.lblcheckindateDure.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblcheckindateDure.text=@"Check-in time";
                
                cell.imgcheckindateimg.frame=CGRectMake(15-7.5,y+2, 12, 12);
                cell.imgcheckindateimg.image=[UIImage imageNamed:@"checkin-time"];
                
                cell.lblCheckindate.frame=CGRectMake(245, y-1, 75, 20);
                cell.lblCheckindate.textColor=[UIColor whiteColor];
                cell.lblCheckindate.font=[UIFont systemFontOfSize:15];
                cell.lblCheckindate.textAlignment=NSTextAlignmentLeft;
                cell.lblCheckindate.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                NSString *strtime=strmianTime;
                cell.lblCheckindate.text=strtime;
                
            }
            else if (k==3)
            {
                cell.lblcheckout.frame=CGRectMake(35-7.5, y-1, cell.frame.size.width-35, 20);
                cell.lblcheckout.textColor=[UIColor whiteColor];
                cell.lblcheckout.textAlignment=NSTextAlignmentLeft;
                cell.lblcheckout.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblcheckout.text=@"Check-out time";
                cell.imgcheckout.frame=CGRectMake(15-7.5,y+2, 12, 12);
                cell.imgcheckout.image=[UIImage imageNamed:@"checkout"];
                cell.lblcheckouttime.frame=CGRectMake(245, y-1, 75, 20);
                cell.lblcheckouttime.textColor=[UIColor whiteColor];
                cell.lblcheckouttime.font=[UIFont systemFontOfSize:15];
                cell.lblcheckouttime.textAlignment=NSTextAlignmentLeft;
                cell.lblcheckouttime.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                [searchdetailarray valueForKey:@"hours"];
                [searchdetailarray valueForKey:@"time"];
                cell.lblcheckouttime.text=strCheckoutTime;
            }
            else if (k==4)
            {
                cell.lblDuration.frame=CGRectMake(35-7.5, y-1, cell.frame.size.width-35, 20);
                cell.lblDuration.textColor=[UIColor whiteColor];
                cell.lblDuration.textAlignment=NSTextAlignmentLeft;
                cell.lblDuration.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblDuration.text=@"Duration";
                cell.imgduration.frame=CGRectMake(15-7.5,y+2, 12, 12);
                cell.imgduration.image=[UIImage imageNamed:@"duration"];
                cell.lbldurationTime.frame=CGRectMake(245, y-1, 75, 20);
                cell.lbldurationTime.textColor=[UIColor whiteColor];
                cell.lbldurationTime.font=[UIFont systemFontOfSize:15];
                cell.lbldurationTime.textAlignment=NSTextAlignmentLeft;
                cell.lbldurationTime.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
                NSString *strdur;
                if ([searchdetailarray valueForKey:@"hours"]==nil)
                {
                    strdur =@"5 HRS";
                }
                else
                {
                    strdur=[NSString stringWithFormat:@"%@ HRS",[searchdetailarray valueForKey:@"hours"]];
                }
                cell.lbldurationTime.text=strdur;
            }
            y=y+12+15;
            
            
        }
        cell.lblline.backgroundColor=[UIColor whiteColor];
        cell.lblline.frame=CGRectMake(10,119, 320-05, 0.5);
    }
    
    else if (indexPath.row==2)
    {
        
        int y=15;
        for (int k=1; k<=1; k++)
        {
            if (k==1)
            {
                cell.lblprice.frame=CGRectMake(9, y-5, cell.frame.size.width-35, 20);
                cell.lblprice.textColor=[UIColor whiteColor];
                cell.lblprice.font=[UIFont systemFontOfSize:12];
                cell.lblprice.text=@"0202 450 6788";
                cell.lblprice.textAlignment=NSTextAlignmentLeft;
                cell.lblprice.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblprice.text=@"Price";
                cell.lblpricevalue.frame=CGRectMake(245, y-5, 75, 20);
                cell.lblpricevalue.textColor=[UIColor whiteColor];
                cell.lblpricevalue.font=[UIFont systemFontOfSize:12];
                cell.lblpricevalue.textAlignment=NSTextAlignmentLeft;
                cell.lblpricevalue.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblpricevalue.text=[NSString stringWithFormat:@"$%@",strPrice];
            }
            else if (k==2)
            {
                cell.lblfees.frame=CGRectMake(9, y-5, cell.frame.size.width-35, 20);
                cell.lblfees.textColor=[UIColor whiteColor];
                cell.lblfees.font=[UIFont systemFontOfSize:12];
                cell.lblfees.textAlignment=NSTextAlignmentLeft;
                cell.lblfees.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblfees.text=@"Fees";
                cell.lblfeesvalue.frame=CGRectMake(245, y-5, 75, 20);
                cell.lblfeesvalue.textColor=[UIColor whiteColor];
                cell.lblfeesvalue.font=[UIFont systemFontOfSize:12];
                cell.lblfeesvalue.textAlignment=NSTextAlignmentLeft;
                cell.lblfeesvalue.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lblfeesvalue.text=@"$0.00";
            }
            else if (k==3)
            {
                
                cell.lbltext.frame=CGRectMake(9, y-5, cell.frame.size.width-35, 20);
                cell.lbltext.textColor=[UIColor whiteColor];
                cell.lbltext.font=[UIFont systemFontOfSize:12];
                cell.lbltext.textAlignment=NSTextAlignmentLeft;
                
                cell.lbltext.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lbltext.text=@"Taxes";
                cell.lbltextvalue.frame=CGRectMake(245, y-5, 75, 20);
                cell.lbltextvalue.textColor=[UIColor whiteColor];
                cell.lbltextvalue.font=[UIFont systemFontOfSize:12];
                cell.lbltextvalue.textAlignment=NSTextAlignmentLeft;
                cell.lbltextvalue.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                cell.lbltextvalue.text=@"$0.00";
            }
            y=y+12+15;
        }
        cell.lblline.backgroundColor=[UIColor whiteColor];
        cell.lblline.frame=CGRectMake(10, 39.5, 320-05, 0.5);
        
    }
    else if (indexPath.row==3)
    {
        cell.lbltotal.frame=CGRectMake(9, 10, cell.frame.size.width-35, 20);
        cell.lbltotal.textColor=[UIColor colorWithRed:209/255.0 green:0 blue:216/255.0 alpha:1];
        cell.lbltotal.font=[UIFont systemFontOfSize:12];
        cell.lbltotal.text=@"Total";
        cell.lbltotal.textAlignment=NSTextAlignmentLeft;
        cell.lbltotal.font=[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:14];
        cell.lbltotalvalue.frame=CGRectMake(245, 10, 75, 20);
        cell.lbltotalvalue.textColor=[UIColor colorWithRed:209/255.0 green:0 blue:216/255.0 alpha:1];
        cell.lbltotalvalue.font=[UIFont systemFontOfSize:12];
        cell.lbltotalvalue.text=[NSString stringWithFormat:@"$%@",strPrice];
        cell.lbltotalvalue.textAlignment=NSTextAlignmentLeft;
        cell.lbltotalvalue.font=[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:14];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor=[UIColor colorWithRed:30/255.0 green:35.0/255.0 blue:71.0/255.0 alpha:1.0];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}




#pragma mark-- swipe  to delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row==0)
    {
        return  NO;
    }
    
    else if(indexPath.row==1)
    {
        
        return  NO;
        
    }
    
    else if(indexPath.row==2+(roomtypearrray.count))
    {
        
        return  NO;
        
    }
    else if(indexPath.row==(3+(roomtypearrray.count)))
    {
        
        return  NO;
        
    }
    else
    {
        
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure to remove from cart ?" cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        alert.tag=0;
        [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
         {
             [alertView hideWithCompletionBlock:^{
                 
                 if (buttonIndex==0)
                 {
                     NSString *cartid;
                     
                     cartid = [[roomtypearrray objectAtIndex:(indexPath.row)-2]valueForKey:@"cart_id"];
                     
                     [roomtypearrray removeObjectAtIndex:(indexPath.row)-2];
                     NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                     
                     [dict setObject:cartid forKey:@"cart_id"];
                     
                     [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                     
                     URLManager *manager = [[URLManager alloc] init];
                     manager.commandName = @"Deletecart";
                     manager.delegate = self;
                     [manager urlCall:@"http://snapnurse.com/webservice/deleteCartDetails" withParameters:dict];
                     
                 }
                 else
                 {
                     [tblcontent reloadData];
                 }
                 
             }];
         }];
         [alert showWithAnimation:URBalertAnimationType];;
    }
}


#pragma mark-- Rate button Clicked

-(void)RateClicked
{
    
    strisfromAnimity=@"YES";
    
    RateVc *Rate=[[RateVc alloc]init];
    Rate.strHotelImage=imageurl;
    Rate.strId=[HotelDetailArray valueForKey:@"hotel_id"];
    
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:Rate];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark Address button clicked
-(void)AddressClicked:(id)sender
{
    strisfromAnimity=@"YES";
    MapClass *map=[[MapClass alloc]init];
    map.strlat=strLat;
    map.strlon=strlon;
    map.strname=hotelname;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:map];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark ----count Line

-(CGSize)sizeOfMultiLineLabelWithText:(NSString*)givenString andGivenWidth:(CGFloat)givenWidth withFontSize:(int)givenFontSize
{
    NSAssert(self, @"UILabel was nil");
    NSString *aLabelTextString = givenString;
    UIFont *aLabelFont = [UIFont systemFontOfSize:givenFontSize];
    
    CGFloat aLabelSizeWidth = givenWidth;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
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
    /* CGFloat yOffset   = scrollView.contentOffset.y-2;
     
     if (yOffset < 0)
     {
     imghotel.center = CGPointMake(imghotel.frame.size.width, imghotel.frame.size.height);
     CGFloat absoluteY = ABS(scrollView.contentOffset.y);
     [imghotel setFrame:CGRectMake(-absoluteY, 0, absoluteY+self.view.frame.size.width+absoluteY, absoluteY+230)];
     
     topImg.center = CGPointMake(topImg.frame.size.width, topImg.frame.size.height);
     [topImg setFrame:CGRectMake(-absoluteY, 0, absoluteY+self.view.frame.size.width+absoluteY, absoluteY+230)];
     
     }
     else
     {
     imghotel.frame=CGRectMake(0, 0, imghotel.frame.size.width,230);
     topImg.frame=CGRectMake(0, 0, imghotel.frame.size.width,230);
     
     
     }*/
    
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
