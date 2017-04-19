//
//  HomeVC.m
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "HomeVC.h"
#import <QuartzCore/QuartzCore.h>
#import "HotelListingVC.h"
#import "NotificationVC.h"
@interface HomeVC ()
@end
@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated
{
    locationsearch.text=@"";
    flag=@"";
    name=@"";
    
    [self.navigationItem setHidesBackButton:YES];
   // self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = @"";
   // [self showTabBar:self.tabBarController];
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)MoveNotificationtab
{
    NotificationVC * notify = [[NotificationVC alloc] init];
    notify.isfromNotify = YES;
    UINavigationController * navV = [[UINavigationController alloc] initWithRootViewController:notify];
        [self.navigationController presentViewController:navV animated:YES completion:nil];
//    [self.navigationController pushViewController:notify animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
//    [self completedWithNoSelection];
}
- (void)viewDidLoad
{
    serviceCount = 0;
    strHospitalName = @"";
    strHospitalId = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveNotificationtab) name:@"MoveNotificationtab" object:nil];
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bg"];
    [self.view addSubview:bg];
    
    if (IS_IPHONE_4)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-4.png"];
    }
    else if (IS_IPHONE_5)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-5.png"];
    }
    else if (IS_IPHONE_6)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-6.png"];
    }
    else
    {
        bg.image=[UIImage imageNamed:@"bg-ip-6plus.png"];
    }
    
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, self.view.frame.size.width, viewHeight);
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SearchHotelFromMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectHotel_name:) name:@"SearchHotelFromMap" object:nil];
    locationArray=[[NSMutableArray alloc]init] ;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CITYMAIN_LIST"]==Nil||[[NSUserDefaults standardUserDefaults]valueForKey:@"HOTELMAIN_LIST"]==Nil||[[NSUserDefaults standardUserDefaults]valueForKey:@"SPECIALITY_LIST"]==Nil)
    {
        
    }
    else
    {
        cityarraymain=nil;
        HotelMainarray=nil;
        SpicilizationArr=nil;
        cityarraymain=[[NSMutableArray alloc]init];
        HotelMainarray=[[NSMutableArray alloc]init];
        SpicilizationArr=[[NSMutableArray alloc]init];
        cityarraymain=[[[NSUserDefaults standardUserDefaults]valueForKey:@"CITYMAIN_LIST"]mutableCopy];
        HotelMainarray=[[NSUserDefaults standardUserDefaults]valueForKey:@"HOTELMAIN_LIST"];
        SpicilizationArr=[[NSUserDefaults standardUserDefaults]valueForKey:@"SPECIALITY_LIST"];
    }
    
    timeArray=[[NSMutableArray alloc]initWithObjects:@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM",nil];
    [self getallHospitals];
    tempTimeArr=[[NSMutableArray alloc]init];
    
    for (int i=0; i<timeArray.count; i++)
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:[timeArray objectAtIndex:i ] forKey:@"Time"];
        [dict setObject:[NSString stringWithFormat:@"%02d",i] forKey:@"ServerTime"];
        [dict setObject:[NSString stringWithFormat:@"%02d:00:00",i] forKey:@"FomateTime"];
        [tempTimeArr addObject:dict];
    }
    
    UIView *navigationRightview =[[UIView alloc] initWithFrame:CGRectMake(122, 0, 198, 44)];
    navigationRightview.backgroundColor=[UIColor clearColor];
    navigationRightview.tag=999;
    
    UIImageView * saveImg =[[UIImageView alloc] init];
    saveImg.frame=CGRectMake(16,12, 76, 25);
    saveImg.tintColor=[UIColor whiteColor];
    saveImg.image=[UIImage imageNamed:@"nursing-header"];
    
    UILabel *lblAppName=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 31)];
    lblAppName.text=@"SnapNurse";
    lblAppName.font=[UIFont boldSystemFontOfSize:18];
    lblAppName.textColor=globelColor;
    lblAppName.textAlignment=NSTextAlignmentCenter;
    [navigationRightview addSubview:lblAppName];
    self.navigationItem.titleView = lblAppName;
    
    self.navigationItem.hidesBackButton=YES;
    
    scrlContent=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (viewHeight-64-48))];
    scrlContent.backgroundColor=[UIColor clearColor];
    scrlContent.delegate=self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [scrlContent addGestureRecognizer:recognizer];
    [scrlContent setContentSize:CGSizeMake(self.view.frame.size.width, viewHeight+100)];
    scrlContent.scrollEnabled=YES;
    [self.view addSubview:scrlContent];
    
    UILabel *lblBook=[[UILabel alloc]initWithFrame:CGRectMake(33, 20, self.view.frame.size.width-66, 31)];
    lblBook.text=@"BOOK A NURSE BY THE HOUR";
    lblBook.font=[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:15];
    lblBook.textColor=globelColor;
    lblBook.textAlignment=NSTextAlignmentCenter;
    [scrlContent addSubview:lblBook];
    
    
    if (IS_IPHONE_4)
    {
        
    }
    else if (IS_IPHONE_6)
    {
        saveImg.frame=CGRectMake(-10,12, 76, 25);
        
    }
    else if (IS_IPHONE_6plus)
    {
        saveImg.frame=CGRectMake(-22,12, 76, 25);
    }
    else
    {
    }
    
    int y;
    
    if (IS_IPHONE_4)
    {
        y=75;
    }
    else
    {
        y=75;
    }
    UILabel *lblhospital=[[UILabel alloc]initWithFrame:CGRectMake(33, y-7, self.view.frame.size.width-66, 20)];
    lblhospital.text=@"Hospitals";
    lblhospital.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    lblhospital.textColor=[UIColor darkTextColor];
    lblhospital.textAlignment=NSTextAlignmentLeft;
    [scrlContent addSubview:lblhospital];
    {
        y=y+22;
    }
    UIImageView *imgHospital =[[UIImageView alloc]initWithFrame:CGRectMake(33, y-7-4, self.view.frame.size.width-66, 39)];
    imgHospital.userInteractionEnabled=true;
    imgHospital.image=[UIImage imageNamed:@"text-field.png"];
    [scrlContent addSubview:imgHospital];
    
    UIImageView *hospitalicon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 8.5,22,22)];
    hospitalicon.image=[UIImage imageNamed:@"hos._icon"];
    [imgHospital addSubview:hospitalicon];
    imgHospital.userInteractionEnabled=YES;
    
    UIImageView *downIndicator=[[UIImageView alloc]initWithFrame:CGRectMake((imgHospital.frame.size.width)-20,15.5, 14,8)];
    
    downIndicator.image=[UIImage imageNamed:@"arrow.png"];
    [imgHospital addSubview:downIndicator];
    
    hospitalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    hospitalBtn.frame=CGRectMake(30, 0, imgHospital.frame.size.width-30, 39);
    [hospitalBtn addTarget:self action:@selector(hospitalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    hospitalNameLbl=[[UILabel alloc ]initWithFrame:CGRectMake(4, 0, hospitalBtn.frame.size.width,39)];
    hospitalNameLbl.text=@"Select Hospital";
    hospitalNameLbl.textAlignment=NSTextAlignmentLeft;
    hospitalNameLbl.textColor=[UIColor blackColor];
    hospitalNameLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    [hospitalBtn addSubview:hospitalNameLbl];
    [imgHospital addSubview:hospitalBtn];
    
    y=y+40;
    
    UILabel *lblLocation=[[UILabel alloc]initWithFrame:CGRectMake(33, y-7, self.view.frame.size.width-66, 20)];
    lblLocation.text=@"Name/Specialization";
    lblLocation.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    lblLocation.textColor=[UIColor darkTextColor];
    lblLocation.textAlignment=NSTextAlignmentLeft;
    [scrlContent addSubview:lblLocation];
    {
        y=y+22;
    }
    UIImageView *imgLocation =[[UIImageView alloc]initWithFrame:CGRectMake(33, y-7-4, self.view.frame.size.width-66, 39)];
    imgLocation.userInteractionEnabled=true;
    imgLocation.image=[UIImage imageNamed:@"text-field.png"];
    [scrlContent addSubview:imgLocation];
    
    locationsearch = [[UISearchBar alloc] init];
    [locationsearch setFrame:CGRectMake(30, 1.5, imgLocation.frame.size.width-35, 36)];
    locationsearch.delegate = self;
    locationsearch.showsCancelButton = NO;
    locationsearch.tintColor=[UIColor clearColor];
    locationsearch.backgroundImage  = [UIImage new];
    locationsearch.backgroundColor = [UIColor clearColor];
    locationsearch.placeholder = @"Enter Name or Specialization       ";
    if (IS_IPHONE_6)
    {
        locationsearch.placeholder = @"Enter Name or Specialization                           ";
    }
    else if (IS_IPHONE_6plus)
    {
        locationsearch.placeholder = @"Enter Name or Specialization                                       ";
    }
    [imgLocation addSubview:locationsearch];
    
    locationsearch.showsSearchResultsButton=NO;
    
    UITextField *txfSearchField = [locationsearch valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor clearColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    txfSearchField.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    txfSearchField.clearButtonMode=UITextFieldViewModeNever;
    txfSearchField.textAlignment=NSTextAlignmentLeft;
    [txfSearchField setTintColor:[UIColor blueColor]];
    
    UIImageView *locationicon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 9,21,21)];
    locationicon.image=[UIImage imageNamed:@"find-nurse.png"];
    [imgLocation addSubview:locationicon];
    imgLocation.userInteractionEnabled=YES;
    
    tbllocation=[[UITableView alloc]initWithFrame:CGRectMake(33,63, kScreenWidth-66, 223/2) style:UITableViewStylePlain];
    tbllocation.delegate=self;
    tbllocation.separatorStyle=normal;
    tbllocation.dataSource=self;
    tbllocation.hidden=YES;
    
    tblhotel= [[UITableView alloc]initWithFrame:CGRectMake(33,63+(223/2), kScreenWidth-66, 223/2) style:UITableViewStylePlain];
    tblhotel.delegate=self;
    tblhotel.separatorStyle=normal;
    tblhotel.dataSource=self;
    tblhotel.hidden=YES;
    
    y=y+40;
    
    UILabel *lblCity=[[UILabel alloc]initWithFrame:CGRectMake(33, y-7, self.view.frame.size.width-66, 20)];
    lblCity.text=@"City";
    lblCity.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    lblCity.textColor=[UIColor darkTextColor];
    lblCity.textAlignment=NSTextAlignmentLeft;
    [scrlContent addSubview:lblCity];
    {
        y=y+22;
    }
    UIImageView *imgCity =[[UIImageView alloc]initWithFrame:CGRectMake(33, y-7-4, self.view.frame.size.width-66, 39)];
    imgCity.userInteractionEnabled=true;
    imgCity.image=[UIImage imageNamed:@"text-field.png"];
    [scrlContent addSubview:imgCity];
    
    UIImageView *cityicon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 8.5,21,22)];
    cityicon.image=[UIImage imageNamed:@"cityicon.png"];
    [imgCity addSubview:cityicon];
    imgCity.userInteractionEnabled=YES;
    
    UIImageView *downarreow1=[[UIImageView alloc]initWithFrame:CGRectMake((imgCity.frame.size.width)-20,15.5, 14,8)];
    
    downarreow1.image=[UIImage imageNamed:@"arrow.png"];
    [imgCity addSubview:downarreow1];
    
    cityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame=CGRectMake(30, 0, imgCity.frame.size.width-30, 39);
    [cityBtn addTarget:self action:@selector(cityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    cityTitleLbl=[[UILabel alloc ]initWithFrame:CGRectMake(4, 0, cityBtn.frame.size.width,39)];
    cityTitleLbl.text=@"Select City";
    cityTitleLbl.textAlignment=NSTextAlignmentLeft;
    cityTitleLbl.textColor=[UIColor blackColor];
    cityTitleLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    [cityBtn addSubview:cityTitleLbl];
    [imgCity addSubview:cityBtn];
    
    
    y=y+50+6;
    
    lblArrivalDate=[[UILabel alloc]initWithFrame:CGRectMake(33, y-11-11, self.view.frame.size.width-66, 20)];
    lblArrivalDate.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    lblArrivalDate.textColor=[UIColor darkTextColor];
    lblArrivalDate.text=@"Date";
    [scrlContent addSubview:lblArrivalDate];
    
    y=y+22;
    
    UIImageView *imgDate =[[UIImageView alloc]initWithFrame:CGRectMake(33, y-11-3-11, self.view.frame.size.width-66, 39)];
    imgDate.image=[UIImage imageNamed:@"text-field.png"];
    imgDate.userInteractionEnabled=YES;
    
    [scrlContent addSubview:imgDate];
    
    UIImageView *Dateicon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 7.5,22, 24)];
    Dateicon.image=[UIImage imageNamed:@"date"];
    [imgDate addSubview:Dateicon];
    
    UIImageView *downarreow=[[UIImageView alloc]initWithFrame:CGRectMake((imgDate.frame.size.width)-20,15.5, 14,8)];
    
    downarreow.image=[UIImage imageNamed:@"arrow.png"];
    [imgDate addSubview:downarreow];
    
    BtnarrivalDate=[UIButton buttonWithType:UIButtonTypeCustom];
    BtnarrivalDate.frame=CGRectMake(30, 0, imgDate.frame.size.width-30, 39);
    [BtnarrivalDate addTarget:self action:@selector(dateclick) forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter *formatter;
    NSString*dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    
    
    //    [df setDateFormat:@"yy-MM-dd"];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
    NSLog(@"Original time=====%@",currentTime);
    
    NSDate *mydate = [dateFormatter1 dateFromString:currentTime];
    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    
    currentTime = [dateFormatter1 stringFromDate:dateEightHoursAhead];
    NSLog(@"update time=====%@",currentTime);
    
    searchDate =dateEightHoursAhead;
    
    NSDate * finalDate =[dateFormatter1 dateFromString:currentTime];
    
    NSLog(@"finalDate==%@",finalDate);
    dateString = [formatter stringFromDate:finalDate];
    DateTitle=[[UILabel alloc ]initWithFrame:CGRectMake(4, 0, BtnarrivalDate.frame.size.width,39)];
    DateTitle.text=dateString;
    DateTitle.textAlignment=NSTextAlignmentLeft;
    DateTitle.textColor=[UIColor blackColor];
    DateTitle.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    [BtnarrivalDate addSubview:DateTitle];
    [imgDate addSubview:BtnarrivalDate];
    
    
    
    y=y+50+6;
    
    UILabel *lblArrivalTime=[[UILabel alloc]initWithFrame:CGRectMake(33, y-11-4-21, self.view.frame.size.width-66, 20)];
    lblArrivalTime.text=@"Start Time";
    lblArrivalTime.textColor=[UIColor darkTextColor];
    lblArrivalTime.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    
    [scrlContent addSubview:lblArrivalTime];
    
    y=y+22;
    
    UIImageView *imgtime =[[UIImageView alloc]initWithFrame:CGRectMake(33, y-11-4-3-21, self.view.frame.size.width-66, 39)];
    
    imgtime.image=[UIImage imageNamed:@"text-field.png"];
    imgtime.userInteractionEnabled=YES;
    
    [scrlContent addSubview:imgtime];
    
    
    UIImageView *Timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 8.5,22, 22)];
    Timeicon.image=[UIImage imageNamed:@"time.png"];
    [imgtime addSubview:Timeicon];
    
    UIImageView *downarreow2=[[UIImageView alloc]initWithFrame:CGRectMake((imgDate.frame.size.width)-20,15.5, 14,8)];
    downarreow2.image=[UIImage imageNamed:@"arrow.png"];
    [imgtime addSubview:downarreow2];
    
    y=y+5+60;
    
    BtnarrivalTime=[UIButton buttonWithType:UIButtonTypeCustom];
    BtnarrivalTime.frame=CGRectMake(30, 0, imgtime.frame.size.width-30, 39);
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:MM"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateString = [formatter stringFromDate:finalDate];
    timeTitle=[[UILabel alloc ]initWithFrame:CGRectMake(04,0, BtnarrivalTime.frame.size.width, 39)];
    timeTitle.text=@"Time";
    
    timeTitle.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    timeTitle.textAlignment=NSTextAlignmentLeft;
    timeTitle.textColor=[UIColor blackColor];
    [BtnarrivalTime addSubview:timeTitle];
    [BtnarrivalTime addTarget:self action:@selector(ArrivalTimeClick) forControlEvents:UIControlEventTouchUpInside];
    [imgtime addSubview:BtnarrivalTime];
    
    
    y=y;
    
    UILabel *lblflexhours=[[UILabel alloc]initWithFrame:CGRectMake(0, y-50 ,self.view.frame.size.width, 20)];
    lblflexhours.textColor=[UIColor darkTextColor];
    lblflexhours.text=@"FLEX HOURS";
    lblflexhours.textAlignment=NSTextAlignmentCenter;
    lblflexhours.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
    [scrlContent addSubview:lblflexhours];
    
    UILabel *noofhours=[[UILabel alloc]initWithFrame:CGRectMake(0, y-37, self.view.frame.size.width, 20)];
    ;
    
    if (IS_IPHONE_6)
    {
        lblflexhours.frame=CGRectMake(0, y-55 ,self.view.frame.size.width, 20);
        noofhours.frame=CGRectMake(0, y-30, self.view.frame.size.width, 20);
    }
    else if (IS_IPHONE_6plus)
    {
        lblflexhours.frame=CGRectMake(0, y-55 ,self.view.frame.size.width, 20);
        noofhours.frame=CGRectMake(0, y-30, self.view.frame.size.width, 20);
    }
    noofhours.textColor=[UIColor darkTextColor];
    noofhours.text=@"choose the number of hours you need";
    noofhours.textAlignment=NSTextAlignmentCenter;
    noofhours.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
    [scrlContent addSubview:noofhours];
    
    y=y+17-33-4;
    
    y=y+55;
    
    [self prepareSlider];
    
    btnsearch=[UIButton buttonWithType:UIButtonTypeCustom];
    btnsearch.frame=CGRectMake(33,y+10 ,kScreenWidth-66, 35) ;
    
    btnsearch.backgroundColor=[UIColor clearColor];
    [btnsearch addTarget:self action:@selector(SearchClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnContinue=[UIButton buttonWithType:UIButtonTypeCustom];
    btnContinue.frame=CGRectMake(33, y+10, kScreenWidth-66,35);
    btnContinue.layer.borderColor=[UIColor blackColor].CGColor;
    btnContinue.backgroundColor=globelColor;
    [btnContinue setTitle:@"FIND NURSE" forState:UIControlStateNormal];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnContinue.layer.cornerRadius=5;
    btnContinue.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12];
    
    if (IS_IPHONE_4) {
        btnsearch.frame=CGRectMake(33,y+15 ,kScreenWidth-66, 35) ;
        btnContinue.frame=CGRectMake(33, y+15, kScreenWidth-66,35);
    }
    else if (IS_IPHONE_6)
    {
        btnsearch.frame=CGRectMake(33,kScreenHeight-160 ,kScreenWidth-66, 40) ;
        btnContinue.frame=CGRectMake(33, kScreenHeight-160, kScreenWidth-66,39);
    }
    else if (IS_IPHONE_6plus)
    {
        btnsearch.frame=CGRectMake(33,kScreenHeight-160 ,kScreenWidth-66, 40) ;
        btnContinue.frame=CGRectMake(33, kScreenHeight-160, kScreenWidth-66,39);
    }
    
    [scrlContent addSubview:btnContinue];
    [self.view addSubview:tbllocation];
    [self.view addSubview:tblhotel];
    [self.view addSubview:tblTime];
    [scrlContent addSubview:btnsearch];
    
    [self currentTime];
    
    [self settimevalue];//Time to shows hopurs
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TimeChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentTime)
                                                 name:@"TimeChange"
                                               object:nil];
    
    
    if (self.isfromNotify)
    {
        [self MoveNotificationtab];
    }
   
}
-(void)currentTime
{
    [self CloseTime];
    isSearching=NO;
    [tblhotel reloadData];
    
    [tbllocation reloadData];
    
    [locationsearch resignFirstResponder];
    [scrlContent setContentOffset:CGPointMake(0,0)animated:YES];
    if (IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = YES;
    }

    NSDateFormatter *formatter;
    NSString*dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    
    
    //    [df setDateFormat:@"yy-MM-dd"];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter2 setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    NSString *currentTime1 = [dateFormatter2 stringFromDate:[NSDate date]];
     NSLog(@"Original time=====%@",currentTime1);
    
    NSDate *mydate2 = [dateFormatter2 dateFromString:currentTime1];
    NSTimeInterval secondsInEightHours2 = 1 * 60 * 60;
    
    NSDate *dateEightHoursAhead2 = [mydate2 dateByAddingTimeInterval:secondsInEightHours2];
    
    currentTime1 = [dateFormatter2 stringFromDate:dateEightHoursAhead2];
     NSLog(@"update time=====%@",currentTime1);
    
    searchDate =dateEightHoursAhead2;
    
    
    NSDate * finalDate2 =[dateFormatter2 dateFromString:currentTime1];
    NSLog(@"finalDate==%@",finalDate2);
    
    dateString = [formatter stringFromDate:finalDate2];
    
    
    DateTitle.text=dateString;
    
    NSDateFormatter *dateTime=[[NSDateFormatter alloc]init];
    [dateTime setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateTime setTimeZone:[NSTimeZone systemTimeZone]];//UTC TO GMT BY RAJU
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
     NSLog(@"Original time=====%@",currentTime);
    
    
    NSDate *mydate = [dateFormatter1 dateFromString:currentTime];
    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    
    currentTime = [dateFormatter1 stringFromDate:dateEightHoursAhead];
     NSLog(@"update time=====%@",currentTime);
    
    
    //      NSArray * tempArr1 = [currentTime componentsSeparatedByString:@" "];
    //      currentTime=[tempArr1 objectAtIndex:0];
    
//    NSString * realTimeStr = [self getRealTimeFromUTCTimeDate:dateEightHoursAhead];
    
    NSDate * finalDate =[dateFormatter1 dateFromString:currentTime];
     NSLog(@"finalDate==%@",finalDate);

    NSDate* now1 = finalDate;
    NSString *StrNow=[dateTime stringFromDate:now1];
    NSDate *now=[dateTime dateFromString:StrNow];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    if (hour>12)
    {
        am_OR_pm = @"PM";
    }
     NSLog(@"this is the same date =%@",[NSString stringWithFormat:@"%02ld:00:00", (long)hour+2]);
    
    NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
    [dFrmt setDateFormat:@"MM-dd-yyyy"];
    [dFrmt setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * str1 =DateTitle.text;
    NSString * str2 =[dFrmt stringFromDate:[NSDate date]];
    NSDate * startD =[dFrmt dateFromString:str1];
    NSDate * endD = [dFrmt dateFromString:str2];
    if ([startD isEqual:endD])
    {
         NSLog(@"this is the same date");
        maintime =[[NSMutableArray alloc] init];
        BOOL isFound = NO;
        for (int k=0; k<[tempTimeArr count]; k++)
        {
            if ([[[tempTimeArr objectAtIndex:k] valueForKey:@"ServerTime"] isEqualToString:[NSString stringWithFormat:@"%02d", hour+2]])
            {
                isFound=YES;
            }
            
            if (isFound)
            {
                
                [maintime addObject:[tempTimeArr objectAtIndex:k]];
            }
        }
    }
    else
    {
        NSLog(@"this is not same date");
        maintime =[[NSMutableArray alloc] init];
        if (hour==1)
        {
            if (tempTimeArr.count!=0)
            {
                [tempTimeArr removeObjectAtIndex:0];
            }
        }
        maintime=[tempTimeArr mutableCopy];
    }
    [self updateTimeEveryTime];
}


#pragma mark   ==== MEthod From MAP
-(void)selectHotel_name:(NSNotification*)notification
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    detailDict = (NSDictionary*)notification.object;
    NSLog(@"datingDict==%@",detailDict);
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setSerchField) userInfo:nil repeats:NO];
}
-(void)setSerchField
{
    locationsearch.text=[detailDict valueForKey:@"Title"];
    flag=@"hotel";
    name=[detailDict valueForKey:@"Title"];
}

-(void)updateTimeEveryTime
{
    NSDateFormatter *dateTime=[[NSDateFormatter alloc]init];
    [dateTime setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateTime setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    NSDate *now1 = [mydate dateByAddingTimeInterval:secondsInEightHours];
    
    
    NSString *StrNow=[dateTime stringFromDate:now1];
    NSDate *now=[dateTime dateFromString:StrNow];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    if (hour>12)
    {
        
        am_OR_pm = @"PM";
    }
    
     NSLog(@"this is the same date =%@",[NSString stringWithFormat:@"%02ld:00:00", (long)hour+1]);
    
    NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
    [dFrmt setDateFormat:@"MM-dd-YYYY"];
    [dFrmt setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * str1 =DateTitle.text;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
     NSLog(@"Original time=====%@",currentTime);
    NSTimeInterval secondsInEightHours1 = 1 * 60 * 60;
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours1];
    currentTime = [dateFormatter1 stringFromDate:dateEightHoursAhead];
     NSLog(@"update time=====%@",currentTime);
    NSString * str2 =[dFrmt stringFromDate:[NSDate date]];
    
    
    NSString *strInteger = [NSString stringWithFormat:@"%d", hour];
    if (strInteger.length==1)
    {
        //        strInteger=[NSString stringWithFormat:@"%02d", hour];
        //        hour=[strInteger integerValue];
    }
    else
    {
        
    }
    if ([str1 isEqual:str2])
    {
        if (hour==0)
        {
            
        }
        else
        {
            maintime =[[NSMutableArray alloc] init];
            BOOL isFound = NO;
            for (int k=0; k<[tempTimeArr count]; k++)
            {
                NSString *str=[NSString stringWithFormat:@"%02d",hour];
                 NSLog(@"%@",str);
                
                if ([[[tempTimeArr objectAtIndex:k] valueForKey:@"ServerTime"] isEqualToString:[NSString stringWithFormat:@"%02d",hour]])
                {
                    isFound=YES;
                }
                else
                {
                }
                if (isFound)
                {
                    [maintime addObject:[tempTimeArr objectAtIndex:k]];
                }
            }
            
            if ([maintime count]!=0)
            {
                strHours=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:0]valueForKey:@"Time"] ];
                timeTitle.text=[NSString stringWithFormat:@"%@",strHours];
                strServerTime=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:0]valueForKey:@"ServerTime"]];
            }
        }
    }
    else
    {
         NSLog(@"this is not same date");
        maintime =[[NSMutableArray alloc] init];
        maintime=[tempTimeArr mutableCopy];
        if ([maintime count]!=0)
        {
            strHours=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:0]valueForKey:@"Time"] ];
            timeTitle.text=[NSString stringWithFormat:@"%@",strHours];
            strServerTime=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:0]valueForKey:@"ServerTime"]];
        }
    }

}
#pragma mark Drow Segment


#pragma mark - Date Conversion
-(NSString *)getRealTimeFromUTCTimeDate:(NSDate *)utcDate
{
    NSTimeZone * destinationTimeZone = [NSTimeZone systemTimeZone];
    float timeZoneOffset=[destinationTimeZone secondsFromGMTForDate:utcDate];
    NSDate *finalDate =[utcDate dateByAddingTimeInterval:timeZoneOffset];
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strRealTime = [df stringFromDate:finalDate];
    return strRealTime;
}
#pragma mark Segment


-(void)prepareSlider
{
#define WIDTH  260
#define HEIGHT 44
#define X_POS  42
#define Y_POS  321+40
#define RADIUS_POINT  7
#define SPACE_BETWEEN_POINTS  30.00
#define SLIDER_LINE_WIDTH       3
#define IPHONE_4_SUPPORT      88
    CGRect sliderConrolFrame = CGRectNull;
    if (IS_IPHONE_4)
    {
        sliderConrolFrame = CGRectMake(X_POS,Y_POS+100,kScreenWidth-66,HEIGHT);
    }
    else if(IS_IPHONE_5)
    {
        sliderConrolFrame = CGRectMake(X_POS,Y_POS+90,kScreenWidth-66,HEIGHT);
    }
    else if(IS_IPHONE_6)
    {
        sliderConrolFrame = CGRectMake(55,Y_POS+105,WIDTH+10,HEIGHT);
    }
    else
    {
        sliderConrolFrame = CGRectMake(65,Y_POS+105,326,HEIGHT);
    }
    sliderControl = [[AKSSegmentedSliderControl alloc] initWithFrame:sliderConrolFrame];
    [sliderControl setDelegate:self];
    [sliderControl moveToIndex:0];
    selectedindex=0;
    sliderControl.touchEnabled=YES;
    
    if (IS_IPHONE_6plus)
    {
        [sliderControl setSpaceBetweenPoints:40];
    }
    else if (IS_IPHONE_6)
    {
        [sliderControl setSpaceBetweenPoints:35];
    }
    else
    {
        [sliderControl setSpaceBetweenPoints:SPACE_BETWEEN_POINTS];
    }
    
    [sliderControl setRadiusPoint:RADIUS_POINT];
    [sliderControl setHeightLine:SLIDER_LINE_WIDTH];
    [scrlContent addSubview:sliderControl];
}
-(void)settimevalue
{
    [timebackview removeFromSuperview];
    timebackview=nil;
    timebackview=[[UIView alloc]initWithFrame:CGRectMake(0, 321+40+70, scrlContent.frame.size.width, 10)];
    timebackview.backgroundColor=[UIColor clearColor];
    if (IS_IPHONE_4)
    {
        timebackview.frame=CGRectMake(0, 321+50+70, scrlContent.frame.size.width, 10);
    }
    else if (IS_IPHONE_6)
    {
        timebackview.frame=CGRectMake(0, scrlContent.frame.size.height-115, 375, 20);
    }
    else if (IS_IPHONE_6plus)
    {
        timebackview.frame=CGRectMake(0, scrlContent.frame.size.height-185, 414, 20);
    }
    [scrlContent addSubview:timebackview];
    
    [lblHours removeFromSuperview];
    
    lblHours=nil;
    int i = 0;
    for(int buttonIndex=1;buttonIndex<=6;buttonIndex++)
    {
        lblHours = [[UILabel alloc]init];;
        if (buttonIndex==1)
        {
            i=42;
        }
        else
        {
            i=i+44;
        }
        if (IS_IPHONE_6)
        {
            if (buttonIndex==1)
            {
                i=55;
            }
            else
            {
                i=i+05;
            }
        }
        else if (IS_IPHONE_6plus)
        {
            if (buttonIndex==1)
            {
                i=65;
            }
            else
            {
                i=i+10;
            }
        }
        
        lblHours.font=[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:10];
        
        lblHours.frame = CGRectMake(i,0,20,10);
        if (IS_IPHONE_6plus)
        {
            lblHours.frame = CGRectMake(i,0,20,20);
        }
        if (IS_IPHONE_6)
        {
            lblHours.frame = CGRectMake(i,0,20,20);
        }
        
        
        lblHours.textColor=[UIColor darkTextColor];
        lblHours.tag=buttonIndex;
        
        if (buttonIndex == 1)
        {
            lblHours.text=[NSString stringWithFormat:@"2h"];
        }
        else if (buttonIndex == 2)
        {
            lblHours.text=[NSString stringWithFormat:@"4h"];
        }
        else if (buttonIndex == 3)
        {
            lblHours.text=[NSString stringWithFormat:@"6h"];
        }
        else if (buttonIndex == 4)
        {
            lblHours.text=[NSString stringWithFormat:@"8h"];
        }
        else if (buttonIndex == 5)
        {
            lblHours.text=[NSString stringWithFormat:@"10h"];
        }
        else if (buttonIndex == 6)
        {
            lblHours.text=[NSString stringWithFormat:@"12h"];
        }
        
        if (buttonIndex==selectedindex+1)
        {
            lblHours.textColor=globelColor;
            
        }
        
        [timebackview addSubview:lblHours];
    }
    
}

-(void)timeSlider:(AKSSegmentedSliderControl *)timeSlider didSelectPointAtIndex:(int)index
{
     NSLog(@"index :--%d",index);
    selectedindex=index;
    [self settimevalue];
    
}
#pragma mark Get All City And Hotel 
-(void)getallHotel_city
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        
        customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        if ([customerId isEqualToString:@""]||customerId==nil)
        {
        }
        else
        {
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            serviceCount = serviceCount + 1;

            NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
            [dict setObject:customerId forKey:@"customer_id"];
            [dict setObject:strHospitalId forKey:@"hospital_id"];
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"GetallHotel";
            manager.delegate = self;
            // [manager urlCall:@"http://www.chillyn.com/webservice/getCity_Hotels" withParameters:nil];
            [manager urlCall:@"http://snapnurse.com/webservice/getCity_Hotels" withParameters:dict];
        }
    }
    else
    {
    }
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    
    
}
-(void)getallHospitals
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        
        customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        if ([customerId isEqualToString:@""]||customerId==nil)
        {
        }
        else
        {
            NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
            [dict setObject:customerId forKey:@"customer_id"];
            serviceCount = serviceCount + 1;
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"GetallHospitals";
            manager.delegate = self;
            // [manager urlCall:@"http://www.chillyn.com/webservice/getCity_Hotels" withParameters:nil];
            [manager urlCall:@"http://snapnurse.com/webservice/get_hospital" withParameters:dict];
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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    if([[result valueForKey:@"commandName"] isEqualToString:@"GetallHotel"])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        locationArray=nil;
        NSMutableArray *cityarray=[[NSMutableArray alloc]init];
        NSMutableArray *Hotelarray=[[NSMutableArray alloc]init];
        NSMutableArray *Spicilization=[[NSMutableArray alloc]init];

        cityarraymain=nil;
        HotelMainarray=nil;
        SpicilizationArr = nil;
        
        SpicilizationArr =[[NSMutableArray alloc] init];
        cityarraymain=[[NSMutableArray alloc]init];
        HotelMainarray=[[NSMutableArray alloc]init];
        
        
        if ([[[result valueForKey:@"result"]valueForKey:@"city_list"] isKindOfClass:[NSArray class]])
        {
            Hotelarray=[[[result valueForKey:@"result"]valueForKey:@"city_list"]mutableCopy];
            
            for (int i=0; i<Hotelarray.count; i++)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:[Hotelarray objectAtIndex:i] forKey:@"name"];
                [dict setObject:@"city" forKey:@"flag"];
                
                [cityarraymain addObject:dict];
            }
            
        }
        
        if ([[[result valueForKey:@"result"]valueForKey:@"hotel_list"] isKindOfClass:[NSArray class]])
        {
            cityarray =[[[result valueForKey:@"result"]valueForKey:@"hotel_list"]mutableCopy];
            for (int i=0; i<cityarray.count; i++)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:[cityarray objectAtIndex:i] forKey:@"name"];
                [dict setObject:@"hotel" forKey:@"flag"];
                [HotelMainarray addObject:dict];
            }
        }
        
        if ([[[result valueForKey:@"result"]valueForKey:@"speciality"] isKindOfClass:[NSArray class]])
        {
            Spicilization =[[[result valueForKey:@"result"]valueForKey:@"speciality"]mutableCopy];
            for (int i=0; i<Spicilization.count; i++)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:[Spicilization objectAtIndex:i] forKey:@"name"];
                [dict setObject:@"spec" forKey:@"flag"];
                [SpicilizationArr addObject:dict];
            }
        }
        
       
        locationArray =[SpicilizationArr mutableCopy];
        [locationArray addObjectsFromArray:HotelMainarray];
        
        [[NSUserDefaults standardUserDefaults]setObject:cityarraymain forKey:@"CITYMAIN_LIST"];
        [[NSUserDefaults standardUserDefaults]setObject:HotelMainarray forKey:@"HOTELMAIN_LIST"];
        [[NSUserDefaults standardUserDefaults]setObject:SpicilizationArr forKey:@"SPECIALITY_LIST"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [tbllocation reloadData];
        [tblhotel reloadData];
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"GetallHospitals"])
    {
        if ([[[result valueForKey:@"result"] valueForKey:@"result"] isEqualToString:@"true"])
        {
            hospitalArr = nil;
            hospitalArr = [[NSMutableArray alloc] init];
            hospitalArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
        }
        else
        {
        }
       
    }
}
- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
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
    else if(ancode == -1005)
    {
        
    }
    else
    {
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//         [alert showWithAnimation:URBalertAnimationType];;
    }
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"GetallHotel"])
        {
            if (serviceCount >=3)
            {
                serviceCount = 0;
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"" message:@"Something went wrong please try again later." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                [self getallHotel_city];
                
            }
        }
        else if ([commandName isEqualToString:@"GetallHospitals"])
        {
            if (serviceCount >=3)
            {
                serviceCount = 0;
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"" message:@"Something went wrong please try again later." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                [self getallHospitals];
                
            }
        }

    }
}
#pragma mark - Show Arrival Date Picker
-(void)dateclick
{
    if (isdateClick)
    {
        
    }
    else
    {
        [scrlContent setContentOffset:CGPointMake(0, 80+50)animated:YES];
        if(IS_IPHONE_4)
        {
            [scrlContent setContentOffset:CGPointMake(0,140+50)animated:YES];
        }
        [self CloseTime];
        tblTime.hidden=YES;
        isFromCityPicker = NO;
        isFromHospital = NO;
        istimeClick=false;
        [self ArrivalDateClick];
        [UIView animateWithDuration:0.25 animations:^{
            bgView.frame=CGRectMake(0,0, self.view.frame.size.width, viewHeight);
        }];
        isdateClick =YES;
    }
    
}
-(void)cityBtnClick
{
    if ([hospitalNameLbl.text isEqualToString:@"Select Hospital"] || [strHospitalName isEqualToString:@""])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Alert" message:@"Please select hospital first" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
        return;
    }
    if (cityarraymain.count>0)
    {
        isFromCityPicker = YES;
        isdateClick=NO;
        isFromHospital = NO;
        [bgTimeView removeFromSuperview];
        if(IS_IPHONE_4)
        {
            scrlContent.scrollEnabled = NO;
            [scrlContent setContentOffset:CGPointMake(0,90+50)animated:YES];
            //[scrlContent setContentOffset:CGPointMake(0, 75)animated:YES];
        }
        else
        {
            [scrlContent setContentOffset:CGPointMake(0, 50)animated:YES];
        }
        [bgView removeFromSuperview];
        
        bgTimeView=nil;
        
        btnsearch.enabled=false;
        
       bgTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
        bgTimeView.frame=CGRectMake(0, viewHeight, self.view.frame.size.width, viewHeight);
        bgTimeView.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.8];
        
        UILabel *titleForTimePicker=[[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
        titleForTimePicker.text=@"Select City";
        titleForTimePicker.backgroundColor=globelColor;
        titleForTimePicker.textColor =[UIColor whiteColor];
        titleForTimePicker.textAlignment=NSTextAlignmentCenter;
        titleForTimePicker.font=[UIFont boldSystemFontOfSize:15];
        titleForTimePicker.userInteractionEnabled=true;
        
        [bgTimeView addSubview:titleForTimePicker];
        
        UIButton *DoneTime=[UIButton buttonWithType:UIButtonTypeCustom];
        [DoneTime setFrame:CGRectMake(self.view.frame.size.width-45,-2.5, 45, 45)];
        [DoneTime setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        DoneTime.titleLabel.textColor =[UIColor whiteColor];
        DoneTime.titleLabel.font=[UIFont systemFontOfSize:14.0];
        
        DoneTime.backgroundColor=[UIColor clearColor];
        [DoneTime addTarget:self action:@selector(SeleectCity) forControlEvents:UIControlEventTouchUpInside];
        
        [titleForTimePicker addSubview:DoneTime];
        
        [self.view addSubview:bgTimeView];
        UIPickerView *timePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40,self.view.frame.size.width,0)];
        timePickerView.frame=CGRectMake(0,40, self.view.frame.size.width, 216);
        timePickerView.backgroundColor=[UIColor whiteColor];
        [timePickerView setDataSource: self];
        [timePickerView setDelegate: self];
        [bgTimeView addSubview:timePickerView];
        
        int selectedPicker=0;
        
        for (int i=0; i<[cityarraymain count]; i++)
        {
            if([[[cityarraymain objectAtIndex:i] objectForKey:@"name"] isEqualToString:cityTitleLbl.text])
            {
                selectedPicker=i;
            }
        }
        [timePickerView selectRow:selectedPicker inComponent:0 animated:YES];
        [timePickerView selectRow:selectedPicker inComponent:0 animated:YES];
        [self pickerView:timePickerView didSelectRow:selectedPicker inComponent:0];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if (IS_IPHONE_4) {
                bgTimeView.frame=CGRectMake(0, self.view.frame.size.height-280, 320, 216);
                
            }
            else
            {
                bgTimeView.frame=CGRectMake(0, self.view.frame.size.height-280, self.view.frame.size.width, 216);
                
            }
        }];
        [bgTimeView addSubview:titleForTimePicker];
    }
    else
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Alert" message:@"city not found" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
    }
   
}
-(void)hospitalBtnClick
{
    [locationsearch resignFirstResponder];
    
    if (hospitalArr.count>0)
    {
        isFromCityPicker = NO;
        isdateClick=NO;
        isFromHospital = YES;
        [bgTimeView removeFromSuperview];
        if(IS_IPHONE_4)
        {
            scrlContent.scrollEnabled = NO;
            [scrlContent setContentOffset:CGPointMake(0,90)animated:YES];
            //[scrlContent setContentOffset:CGPointMake(0, 75)animated:YES];
        }
        else
        {
            [scrlContent setContentOffset:CGPointMake(0, 0)animated:YES];
        }
        [bgView removeFromSuperview];
        
        bgTimeView=nil;
        
        btnsearch.enabled=false;
        
        bgTimeView = [[UIView alloc] initWithFrame:self.view.frame];
        bgTimeView.frame=CGRectMake(0, viewHeight, self.view.frame.size.width, viewHeight);
        bgTimeView.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.8];
        
        UILabel *Picker=[[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
        Picker.text=@"Select Hospital";
        Picker.backgroundColor=globelColor;
        Picker.textColor =[UIColor whiteColor];
        Picker.textAlignment=NSTextAlignmentCenter;
        Picker.font=[UIFont boldSystemFontOfSize:15];
        Picker.userInteractionEnabled=true;
        
        [bgTimeView addSubview:Picker];
        
        UIButton *Done=[UIButton buttonWithType:UIButtonTypeCustom];
        [Done setFrame:CGRectMake(self.view.frame.size.width-45,-2.5, 45, 45)];
        [Done setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        Done.titleLabel.textColor =[UIColor whiteColor];
        Done.titleLabel.font=[UIFont systemFontOfSize:14.0];
        
        Done.backgroundColor=[UIColor clearColor];
        [Done addTarget:self action:@selector(hospitalDoneClick) forControlEvents:UIControlEventTouchUpInside];
        
        [Picker addSubview:Done];
        
        [self.view addSubview:bgTimeView];
        UIPickerView *timePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40,self.view.frame.size.width,0)];
        timePickerView.frame=CGRectMake(0,40, self.view.frame.size.width, 216);
        timePickerView.backgroundColor=[UIColor whiteColor];
        [timePickerView setDataSource: self];
        [timePickerView setDelegate: self];
        [bgTimeView addSubview:timePickerView];
        
        int selectedPicker=0;
        
        for (int i=0; i<[hospitalArr count]; i++)
        {
            if([[[[hospitalArr objectAtIndex:i]valueForKey:@"hospitals"] valueForKey:@"first_name"] isEqualToString:hospitalNameLbl.text])
            {
                selectedPicker=i;
            }
        }
        [timePickerView selectRow:selectedPicker inComponent:0 animated:YES];
        [timePickerView selectRow:selectedPicker inComponent:0 animated:YES];
        [self pickerView:timePickerView didSelectRow:selectedPicker inComponent:0];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if (IS_IPHONE_4) {
                bgTimeView.frame=CGRectMake(0, self.view.frame.size.height-280, 320, 216);
                
            }
            else
            {
                bgTimeView.frame=CGRectMake(0, self.view.frame.size.height-280, self.view.frame.size.width, 216);
                
            }
        }];
        [bgTimeView addSubview:Picker];
    }
    else
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Alert" message:@"Hospital not found" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
    }
    
}
-(void)ArrivalDateClick
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, self.view.frame.size.width, viewHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.alpha=1;
    [self.view addSubview:bgView ];
    calVC = [[OCCalendarViewController alloc] initAtPoint:CGPointMake(0, 20) inView:self.view arrowPosition:OCArrowPositionNone];
    calVC.delegate = self;
    calVC.selectionMode = OCSelectionSingleDate;
    [bgView addSubview:calVC.view];
}
#pragma mark - Time Picke
-(void)ArrivalTimeClick
{
    NSDateFormatter *dateTime=[[NSDateFormatter alloc]init];
    [dateTime setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateTime setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    NSDate *now1 = [mydate dateByAddingTimeInterval:secondsInEightHours];
    NSString *StrNow=[dateTime stringFromDate:now1];
    NSDate *now=[dateTime dateFromString:StrNow];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    if (hour>12)
    {
        
        am_OR_pm = @"PM";
    }
    
     NSLog(@"this is the same date =%@",[NSString stringWithFormat:@"%02ld:00:00", (long)hour+1]);
    NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
    [dFrmt setDateFormat:@"MM-dd-YYYY"];
    [dFrmt setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * str1 =DateTitle.text;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
     NSLog(@"Original time=====%@",currentTime);
    NSTimeInterval secondsInEightHours1 = 1 * 60 * 60;
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours1];
    currentTime = [dateFormatter1 stringFromDate:dateEightHoursAhead];
     NSLog(@"update time=====%@",currentTime);
    NSString * str2 =[dFrmt stringFromDate:[NSDate date]];
    
    
    NSString *strInteger = [NSString stringWithFormat:@"%d", hour];
    if (strInteger.length==1)
    {
       
//        strInteger=[NSString stringWithFormat:@"%02d", hour];
//        hour=[strInteger integerValue];
    }
    else
    {
        
    }
    
    if ([str1 isEqual:str2])
    {
        if (hour==0)
        {

        }
        else
        {
            [tempTimeArr removeAllObjects];
            tempTimeArr=nil;
            [timeArray removeAllObjects];
            timeArray =nil;
            
            timeArray=[[NSMutableArray alloc]initWithObjects:@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM",nil];
            
            tempTimeArr=[[NSMutableArray alloc]init];
            for (int i=0; i<timeArray.count; i++)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:[timeArray objectAtIndex:i ] forKey:@"Time"];
                [dict setObject:[NSString stringWithFormat:@"%02d",i] forKey:@"ServerTime"];
                [dict setObject:[NSString stringWithFormat:@"%02d:00:00",i] forKey:@"FomateTime"];
                [tempTimeArr addObject:dict];
            }

            maintime =[[NSMutableArray alloc] init];
            BOOL isFound = NO;
            for (int k=0; k<[tempTimeArr count]; k++)
            {
                NSString *str=[NSString stringWithFormat:@"%02d",hour];
                 NSLog(@"%@",str);
                
                if ([[[tempTimeArr objectAtIndex:k] valueForKey:@"ServerTime"] isEqualToString:[NSString stringWithFormat:@"%02d",hour]])
                {
                    isFound=YES;
                }
                else
                {
                    
                }
                if (isFound)
                {
                    [maintime addObject:[tempTimeArr objectAtIndex:k]];
                }
                
            }
           
        }
    }
    else
    {
         NSLog(@"this is not same date");
        maintime =[[NSMutableArray alloc] init];
        maintime=[tempTimeArr mutableCopy];
    }
    isdateClick=NO;
    isFromCityPicker = NO;
    isFromHospital = NO;
    [bgTimeView removeFromSuperview];
    if(IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = NO;
        [scrlContent setContentOffset:CGPointMake(0,190+60)animated:YES];
        //[scrlContent setContentOffset:CGPointMake(0, 75)animated:YES];
    }
    else
    {
        [scrlContent setContentOffset:CGPointMake(0, 75+70)animated:YES];
    }
    [bgView removeFromSuperview];
    
    bgTimeView=nil;
    
    btnsearch.enabled=false;
    
    bgTimeView = [[UIView alloc] initWithFrame:self.view.frame];
    bgTimeView.frame=CGRectMake(0, viewHeight, self.view.frame.size.width, viewHeight);
    bgTimeView.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.8];
    
    UILabel *titleForTimePicker=[[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
    titleForTimePicker.text=@"Select start time";
    titleForTimePicker.backgroundColor=globelColor;
    titleForTimePicker.textColor =[UIColor whiteColor];
    titleForTimePicker.textAlignment=NSTextAlignmentCenter;
    titleForTimePicker.font=[UIFont boldSystemFontOfSize:15];
    titleForTimePicker.userInteractionEnabled=true;
    
    [bgTimeView addSubview:titleForTimePicker];
    
    UIButton *DoneTime=[UIButton buttonWithType:UIButtonTypeCustom];
    [DoneTime setFrame:CGRectMake(self.view.frame.size.width-45,-2.5, 45, 45)];
    [DoneTime setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    DoneTime.titleLabel.textColor =[UIColor whiteColor];
    DoneTime.titleLabel.font=[UIFont systemFontOfSize:14.0];
    
    DoneTime.backgroundColor=[UIColor clearColor];
    [DoneTime addTarget:self action:@selector(SeleectTime) forControlEvents:UIControlEventTouchUpInside];
    
    [titleForTimePicker addSubview:DoneTime];
    
    [self.view addSubview:bgTimeView];
    
    Hours=nil;
    Minutes=nil;
    Minutes=[[NSArray alloc]init];
    Hours=[[NSArray alloc]init];
    
    Hours = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    Minutes = [NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",
               @"05",@"06",@"07",@"08",@"09",
               @"10",@"11",@"12",@"13",@"14",
               @"15",@"16",@"17",@"18",@"19",
               @"20",@"21",@"22",@"23",@"24",
               @"25",@"26",@"27",@"28",@"29",
               @"30",@"31",@"32",@"33",@"34",
               @"35",@"36",@"37",@"38",@"39",
               @"40",@"41",@"42",@"43",@"44",
               @"45",@"46",@"47",@"48",@"49",
               @"50",@"51",@"52",@"53",@"54",
               @"55",@"56",@"57",@"58",@"59",nil] ;
    UIPickerView *timePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40,self.view.frame.size.width,0)];
    timePickerView.frame=CGRectMake(0,40, self.view.frame.size.width, 216);
    timePickerView.backgroundColor=[UIColor whiteColor];
    [timePickerView setDataSource: self];
    [timePickerView setDelegate: self];
    [bgTimeView addSubview:timePickerView];
    
    int selectedPicker=0;

    for (int i=0; i<[maintime count]; i++)
    {
        if([[[maintime objectAtIndex:i] objectForKey:@"Time"] isEqualToString:timeTitle.text])
        {
            selectedPicker=i;
        }
    }
    
    [timePickerView selectRow:selectedPicker inComponent:0 animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (IS_IPHONE_4) {
            bgTimeView.frame=CGRectMake(0, self.view.frame.size.height-280, 320, 216);
            
        }
        else
        {
            bgTimeView.frame=CGRectMake(0, self.view.frame.size.height-280, self.view.frame.size.width, 216);
            
        }
    }];
    [bgTimeView addSubview:titleForTimePicker];
     NSLog(@"%@",[[maintime objectAtIndex:selectedPicker]valueForKey:@"Time"]);
     NSLog(@"server time   %@",[[maintime objectAtIndex:selectedPicker]valueForKey:@"Time"]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *date = [dateFormatter dateFromString:[[maintime objectAtIndex:selectedPicker]valueForKey:@"Time"]];
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    strHours=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:selectedPicker]valueForKey:@"Time"] ];
    timeTitle.text=[NSString stringWithFormat:@"%@",strHours];
    strServerTime=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:selectedPicker]valueForKey:@"ServerTime"]];
}
#pragma mark - NEXT/SEARCH CLICK

-(void)SearchClick
{
    NSInteger intindex=(sliderControl.currentIndex)+1;
    if (sliderControl.currentIndex == 0)
    {
        intindex = 2;
    }
    else if (sliderControl.currentIndex == 1)
    {
        intindex = 4;
    }
    else if (sliderControl.currentIndex == 2)
    {
        intindex = 6;
    }
    else if (sliderControl.currentIndex == 3)
    {
        intindex = 8;
    }
    else if (sliderControl.currentIndex == 4)
    {
        intindex = 10;
    }
    else if (sliderControl.currentIndex == 5)
    {
        intindex = 12;
    }
    
    NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
    [dFrmt setTimeZone:[NSTimeZone systemTimeZone]];
    [dFrmt setDateFormat:@"yy-MM-dd"];
    NSString * str1 =DateTitle.text;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
    NSLog(@"Original time=====%@",currentTime);
    
    NSDate *mydate = [dateFormatter1 dateFromString:currentTime];
    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    
    currentTime = [dateFormatter1 stringFromDate:dateEightHoursAhead];
    NSLog(@"update time=====%@",currentTime);
    
    
    //      NSArray * tempArr1 = [currentTime componentsSeparatedByString:@" "];
    //      currentTime=[tempArr1 objectAtIndex:0];
    
    //    NSString * realTimeStr = [self getRealTimeFromUTCTimeDate:dateEightHoursAhead];
    
    NSDate * finalDate =[dateFormatter1 dateFromString:currentTime];
    NSLog(@"finalDate==%@",finalDate);
    
    NSString * str2 =[dFrmt stringFromDate:finalDate];
    NSDate * startD =[dFrmt dateFromString:str1];
    NSDate * endD = [dFrmt dateFromString:str2];
    
    
    HotelListingVC * listVc= [[HotelListingVC alloc]init];
    if ([strHospitalName isEqualToString:@""]||[hospitalNameLbl.text isEqualToString:@""])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please select hospital" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([locationsearch.text isEqualToString:@""]||locationsearch.text.length  ==0)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please enter nurse name or specialization" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];
        
    }
    else if([DateTitle.text isEqualToString:@"date"])
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please select date" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];
        
    }
    else if([timeTitle.text isEqualToString:@"Time"])
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please select time" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];
    }
    else if([endD compare:startD] == NSOrderedDescending)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please enter future date and time" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([cityTitleLbl.text isEqualToString:@"Select City"])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please select city" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([strCityName isEqualToString:@""])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Searching !" message:@"Please select city" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        [alert showWithAnimation:URBalertAnimationType];;
    }
    else
    {
        
        if (flag==nil)
        {
            listVc.flag=@"hotel";
        }
        else
        {
            listVc.flag=flag;
        }
        listVc.strHospitalName = strHospitalName;
        listVc.strHospitalId = strHospitalId;
        listVc.name=locationsearch.text;
        listVc.NOofhours=[NSString stringWithFormat:@"%ld",(long)intindex];
        listVc.Time=strServerTime;
        listVc.timevalue=[[maintime objectAtIndex:0]valueForKey:@"Time"];
        NSLog(@"%@",DateTitle.text);
        listVc.searchStr = [NSString stringWithFormat:@"Result for %@, %@ & %ld Flex Hours",DateTitle.text,timeTitle.text,(long)intindex];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        // @"MM-dd-yyyy"
        NSLog(@"startDate:%@", [df stringFromDate:searchDate]);
        NSString *DateStr=[NSString stringWithFormat:@"%@",[df stringFromDate:searchDate]];
        listVc.date=DateStr;
        listVc.cityStr = strCityName;
        listVc.nurseStartTime = timeTitle.text;
        self.navigationItem.title = @"Back";
        listVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:listVc animated:YES];
        
    }
}
#pragma mark - set time

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *v=[[UIView alloc]
               initWithFrame:CGRectMake(0,0,
                                        [self pickerView:pickerView widthForComponent:component],
                                        [self pickerView:pickerView rowHeightForComponent:component])];
    [v setOpaque:TRUE];
    [v setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbl=nil;
    lbl= [[UILabel alloc]
          initWithFrame:CGRectMake(8,0,
                                   [self pickerView:pickerView widthForComponent:component]-16,
                                   [self pickerView:pickerView rowHeightForComponent:component])];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
    NSString *ret=@"";
    
    if (isFromCityPicker)
    {
        ret=[[cityarraymain objectAtIndex:row]valueForKey:@"name"];
    }
    else if (isFromHospital)
    {
        ret=[[[hospitalArr objectAtIndex:row]valueForKey:@"hospitals"] valueForKey:@"first_name"];
    }
    else
    {
        ret=[[maintime objectAtIndex:row]valueForKey:@"Time"];
    }
    
    [lbl setText:ret];
    
    [lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [v addSubview:lbl];
    return v;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component==0)
    {
        
        if (isFromCityPicker)
        {
            strCityName=[NSString stringWithFormat:@"%@",[[cityarraymain objectAtIndex:row]valueForKey:@"name"] ];
            cityTitleLbl.text = strCityName;
        }
        else if (isFromHospital)
        {
            strHospitalName=[NSString stringWithFormat:@"%@",[[[hospitalArr objectAtIndex:row]valueForKey:@"hospitals"] valueForKey:@"first_name"] ];
            strHospitalId=[NSString stringWithFormat:@"%@",[[[hospitalArr objectAtIndex:row]valueForKey:@"hospitals"] valueForKey:@"hospital_id"] ];
            hospitalNameLbl.text = strHospitalName;
            ;
        }
        else
        {
            NSLog(@"%@",[[maintime objectAtIndex:row]valueForKey:@"Time"]);
            NSLog(@"server time   %@",[[maintime objectAtIndex:row]valueForKey:@"Time"]);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            //@"HH:mm";
            NSDate *date = [dateFormatter dateFromString:[[maintime objectAtIndex:row]valueForKey:@"Time"]];
            
            dateFormatter.dateFormat = @"hh:mm a";
            NSString *pmamDateString = [dateFormatter stringFromDate:date];
            
            strHours=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:row]valueForKey:@"Time"] ];
            
            timeTitle.text=[NSString stringWithFormat:@"%@",strHours];
            
            strServerTime=[NSString stringWithFormat:@"%@",[[maintime objectAtIndex:row]valueForKey:@"ServerTime"]];
        }
        
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    float ret=40;
    switch (component)
    {
        case 0:
            ret=self.view.frame.size.width;
            break;
        case 2:
            ret=50;
            break;
        default:
            break;
    }
    return ret;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isFromCityPicker)
    {
         return [cityarraymain count];
    }
    else if (isFromHospital)
    {
        return [hospitalArr count];
    }
    else
    {
         return [maintime count];
    }
   
            
}

#pragma mark - Close View Methods

-(void)SeleectTime
{
    if (IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = YES;
    }
    [scrlContent setContentOffset:CGPointMake(0, 0)animated:YES];
    btnsearch.enabled=YES;
    
    NSString *strTimeFormate=[NSString stringWithFormat:@"%@",strHours];
    
    timeTitle.text=strTimeFormate;
    
    [UIView animateWithDuration:0.25 animations:^{
       bgTimeView.frame=CGRectMake(0,viewHeight, self.view.frame.size.width, viewHeight);
    }];
}
-(void)hospitalDoneClick{
    [scrlContent setContentOffset:CGPointMake(0, 0)animated:YES];
    btnsearch.enabled=YES;
    
    hospitalNameLbl.text=strHospitalName;
    
    [UIView animateWithDuration:0.25 animations:^{
       bgTimeView.frame=CGRectMake(0,viewHeight, self.view.frame.size.width, viewHeight);
    }];
    [self getallHotel_city];
}
-(void)CloseTime
{
    btnsearch.enabled=YES;

    [UIView animateWithDuration:0.25 animations:^{
        bgTimeView.frame=CGRectMake(0,viewHeight, self.view.frame.size.width, viewHeight);
    }];
    //    [bgTimeView removeFromSuperview];
    
   
}
-(void)SeleectCity
{
    if (IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = YES;
    }
    [scrlContent setContentOffset:CGPointMake(0, 0)animated:YES];
    btnsearch.enabled=YES;
    
    cityTitleLbl.text=strCityName;
    
    [UIView animateWithDuration:0.25 animations:^{
        bgTimeView.frame=CGRectMake(0,viewHeight, self.view.frame.size.width, viewHeight);
    }];

}
#pragma mark - Table View Data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    
    UILabel *lbl = [[UILabel alloc] init];
//    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    if (tableView==tblhotel)
    {
        lbl.text = @" Specialization";
    }
    else
    {
        lbl.text = @" Name";
    }
    lbl.textColor = globelColor;
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.alpha = 0.9;
    return lbl;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        return @"city";
    
//    return [animalSectionTitles objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    if(tableView==tblTime)
    {
        return [timeArray count];
        
    }
    else if(tableView==tbllocation)
    {
        if (isSearching)
        {
            if ([filteredContentArray count]==0)
            {
                
                if(IS_IPHONE_4)
                {
                    tblhotel.frame=CGRectMake(33,32,  scrlContent.frame.size.width-66, 85);
                    tbllocation.frame=CGRectMake(tbllocation.frame.origin.x, tbllocation.frame.origin.y
                                                 , tbllocation.frame.size.width,0);
                    
                

                }
                else
                {
                    tblhotel.frame=CGRectMake(33,63,  scrlContent.frame.size.width-66, 223/2);
//
                    tbllocation.frame=CGRectMake(tbllocation.frame.origin.x, tbllocation.frame.origin.y
                                             , tbllocation.frame.size.width,0);
                }
            }
            else
            {
               
                
                if(IS_IPHONE_4)
                {
                }
                else
                {
                    tblhotel.frame= CGRectMake(33,63+(223/2),  scrlContent.frame.size.width-66, 223/2);
                
                    tbllocation.frame=CGRectMake(33,63,  scrlContent.frame.size.width-66, 223/2);
                }
                
            }
            
            return [filteredContentArray count];
            
        }
        else
        {

            if (IS_IPHONE_4)
            {
                
                tbllocation.frame=CGRectMake(33,32,  scrlContent.frame.size.width-66, 85);
                tblhotel.frame= CGRectMake(33,32+(85),  scrlContent.frame.size.width-66, 85);
            }
            else
            {
                tblhotel.frame= CGRectMake(33,63+(223/2), scrlContent.frame.size.width-66, 223/2);
                
                tbllocation.frame=CGRectMake(33,63, scrlContent.frame.size.width-66, 223/2);
            }
            return  HotelMainarray.count;
        }
    }
    else
    {
        if (isSearching)
        {
            if ([filteredhotelarray count]==0)
            {
                
                if (IS_IPHONE_4)
                {
                    tblhotel.frame=CGRectMake(tblhotel.frame.origin.x, tblhotel.frame.origin.y, tblhotel.frame.size.width, 0);
                }
                else
                {
                    tblhotel.frame=CGRectMake(tblhotel.frame.origin.x, tblhotel.frame.origin.y, tblhotel.frame.size.width, 0);
                }
            }
            else
            {
                
            }
            
            return [filteredhotelarray count];
            
        }
        else
        {
            
            if(IS_IPHONE_4)
            {
                tbllocation.frame=CGRectMake(33,32,  scrlContent.frame.size.width-66, 85);

                tblhotel.frame= CGRectMake(33,32+(85),  scrlContent.frame.size.width-66, 85);

                //tblhotel.frame= CGRectMake(40,63+(223/2),  scrlContent.frame.size.width-80, 223/2);
            }
            else
            {
                tblhotel.frame= CGRectMake(33,63+(223/2),  scrlContent.frame.size.width-66, 223/2);
                
                tbllocation.frame=CGRectMake(33,63,  scrlContent.frame.size.width-33, 223/2);
            }
            return  SpicilizationArr.count;
            
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbllocation)
    {
        return 25;
    }
    if (tableView==tblhotel)
    {
        return 25;
    }
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *stringForCell;
    if (tableView==tblTime)
    {
        stringForCell= [NSString stringWithFormat:@"%@",[timeArray objectAtIndex:indexPath.row]];
        cell.textLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:15];
    }
    else
    {
        if (tableView==tblhotel)
        {
            
                if (isSearching)
                {
                    stringForCell= [NSString stringWithFormat:@"%@",[[filteredhotelarray objectAtIndex:indexPath.row] valueForKey:@"name"]];
                }
                else
                {
                    if (indexPath.section==0)
                    {
                        
                        stringForCell= [NSString stringWithFormat:@"%@",[[SpicilizationArr objectAtIndex:indexPath.row]valueForKey:@"name" ]];
                    }
                    else
                    {
                        /*
                         NSMutableArray *cityarray=[[NSMutableArray alloc]init];
                         
                         
                         for (int i=0; i<locationArray.count; i++)
                         {
                         if ([[[locationArray objectAtIndex:i ] valueForKey:@"flag"]isEqualToString:@"hotel"])
                         {
                         [cityarray addObject:[locationArray objectAtIndex:i ]];
                         
                         
                         }
                         
                         }
                         stringForCell= [NSString stringWithFormat:@"%@",[[cityarray objectAtIndex:indexPath.row]valueForKey:@"name" ]];
                         */
                    }
                }
            
        }
        else
        {
            if (isSearching)
            {
                stringForCell= [NSString stringWithFormat:@"%@",[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
            }
            else
            {
                stringForCell= [NSString stringWithFormat:@"%@",[[HotelMainarray objectAtIndex:indexPath.row]valueForKey:@"name" ]];
            }
        }
       
        if ([stringForCell isEqualToString:@"ER"]||[stringForCell isEqualToString:@"LABOR AND DELIVERY"]||[stringForCell isEqualToString:@"MED-SURG"]||[stringForCell isEqualToString:@"TELEMETRY"]||[stringForCell isEqualToString:@"ICU"]||[stringForCell isEqualToString:@"DIALYSIS"]||[stringForCell isEqualToString:@"GASTROENTEROLOGY"]||[stringForCell isEqualToString:@"OR"]||[stringForCell isEqualToString:@"PSYCHIATRY"]||[stringForCell isEqualToString:@"CCU"]||[stringForCell isEqualToString:@"PACU"]||[stringForCell isEqualToString:@"PEDIATRICS"])
        {
            cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        }
        else
        {
           cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
        }
        
        [cell.textLabel setText:stringForCell];
    
        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    return cell;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *strlocation=[NSString stringWithFormat:@"%@",cell.textLabel.text];
    
    if (tableView==tblTime)
    {
        tblTime.hidden=YES;
        timeTitle.text=strlocation;
        istimeClick=false;
    }
    else if(tableView==tbllocation)
    {
        if (isSearching)
        {
            
            flag=[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"flag"];
            name=[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"name"];
            
        }
        else
        {
            flag=[[HotelMainarray objectAtIndex:indexPath.row]valueForKey:@"flag"];
            name=[[HotelMainarray objectAtIndex:indexPath.row]valueForKey:@"name"];
        }
        
        locationsearch.text=strlocation;
        btnclose.hidden=YES;
        tbllocation.hidden=YES;
        tblhotel.hidden=YES;
        
        [locationsearch resignFirstResponder];
        
    }
    else
    {
        if (isSearching)
        {
            flag=[[filteredhotelarray objectAtIndex:indexPath.row]valueForKey:@"flag"];
            name=[[filteredhotelarray objectAtIndex:indexPath.row]valueForKey:@"name"];
        }
        else
        {
            flag=[[SpicilizationArr objectAtIndex:indexPath.row]valueForKey:@"flag"];
            name=[[SpicilizationArr objectAtIndex:indexPath.row]valueForKey:@"name"];
        }
        
        locationsearch.text=strlocation;
        btnclose.hidden=YES;
        tbllocation.hidden=YES;
        tblhotel.hidden=YES;
        [locationsearch resignFirstResponder];
        
    }
    
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Textfield Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    btnclose.hidden=YES;
    tbllocation.hidden=NO;
    tblhotel.hidden=NO;
    tblhotel.frame= CGRectMake(33,63+(223/2), kScreenWidth-66, 223/2);
    tbllocation.frame=CGRectMake(33,63, kScreenWidth-66, 223/2);
    return YES;
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    btnclose.hidden=YES;
    tbllocation.hidden=YES;
    tblhotel.hidden=YES;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark OCCalendarDelegate Methods

- (void)completedWithStartDate:(NSDate *)startDate2 endDate:(NSDate *)endDate
{

    isdateClick=NO;
    if (IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = YES;
    }
    [scrlContent setContentOffset:CGPointMake(0, 0)animated:YES];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterNoStyle];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"MM-dd-yyyy"];
    searchDate=startDate2;
     NSLog(@"startDate:%@", [df stringFromDate:startDate2]);
    NSString *DateStr=[NSString stringWithFormat:@"%@",[df stringFromDate:startDate2]];
    DateTitle.text=DateStr;
    [calVC.view removeFromSuperview];
    calVC.delegate = nil;
    calVC = nil;
    [bgView removeFromSuperview];
    [titleForDatePicker removeFromSuperview];
    titleForDatePicker=nil;
    bgView =nil;

    [self ArrivalTimeClick];
    
}
-(void) completedWithNoSelection
{
    isdateClick=NO;

    [calVC.view removeFromSuperview];
    calVC.delegate = nil;
    calVC = nil;
    [bgView removeFromSuperview];
    [titleForDatePicker removeFromSuperview];
    titleForDatePicker=nil;
    bgView =nil;
    [scrlContent setContentOffset:CGPointMake(0, 0)animated:YES];
    if (IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = YES;
    }
}
#pragma mark Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint insertPoint = [touch locationInView:self.view];
    
    calVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self.view arrowPosition:OCArrowPositionNone selectionMode:OCSelectionSingleDate];
    calVC.delegate = self;
    [self.view addSubview:calVC.view];
    
    return YES;
}
#pragma mark -  UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchBar *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText1
{
    if ([searchText1 length]>0)
    {
        [self filterContentForSearchText:searchText1];
        searchBar.showsCancelButton = NO;
        
    }else
    {
        //         NSLog(@"Hello");
        searchBar.showsCancelButton = NO;
        [searchBar resignFirstResponder];
        isSearching = NO;
        [tbllocation reloadData];
        [tblhotel reloadData];
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchStr1 = [NSString stringWithFormat:@"%@",searchBar.text];
    
    if (searchStr1.length >0)
    {
        
        //        [HUD show:YES];
        
        //        [self searchUserWebService:searchStr1];
        searchBar.showsCancelButton = NO;
        
    }
    [searchBar resignFirstResponder];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([hospitalNameLbl.text isEqualToString:@"Select Hospital"] || [strHospitalName isEqualToString:@""])
    {
//        searchBar.showsCancelButton = NO;
//        [searchBar resignFirstResponder];
//        isSearching = NO;
//        scrlContent.scrollEnabled = YES;
//        
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Alert" message:@"Please select hospital first" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        [alert showWithAnimation:URBalertAnimationType];;
//        return;
    }
    else
    {
        BtnarrivalDate.enabled=NO;
        BtnarrivalTime.enabled=NO;
        
        [self CloseTime];
        
        if (IS_IPHONE_4)
        {
            scrlContent.scrollEnabled = NO;
            [scrlContent setContentOffset:CGPointMake(0, 90+55)];
        }
        else
        {
            [scrlContent setContentOffset:CGPointMake(0, 68+55)];
        }
        
        searchBar.showsCancelButton = NO;
        searchBar.text=@"";
        tblTime.hidden=YES;
        istimeClick=false;
        
        isSearching=NO;
        
        tbllocation.hidden=NO;
        tblhotel.hidden=NO;
        
        [tblhotel reloadData];
        [tbllocation reloadData];
    }
   
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    BtnarrivalDate.enabled=YES;
    BtnarrivalTime.enabled=YES;
    
    [scrlContent setContentOffset:CGPointMake(0, 0)];
    if (IS_IPHONE_4)
    {
        scrlContent.scrollEnabled = YES;
    }
    else
    {
    }
    searchBar.showsCancelButton = NO;
    
    
    [searchBar resignFirstResponder];
    tbllocation.hidden=YES;
    tblhotel.hidden=YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    // if you want the keyboard to go away
    searchBar.text = @"";
    isSearching=NO;
    [tbllocation reloadData];
    [tblhotel reloadData];
    [searchBar resignFirstResponder];
    
}

-(void)filterContentForSearchText:(NSString *)searchText
{
    // Remove all objects from the filtered search array
    [filteredContentArray removeAllObjects];
    [filteredhotelarray removeAllObjects];
    
    // Filter the array using NSPredicate
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self[cd] %@",searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
//    NSPredicate *predicateHotel=[NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
    
    NSArray *filterdArr =[[NSArray alloc] init];
     NSArray *filterdhotel =[[NSArray alloc] init];
    
    filterdArr = [HotelMainarray filteredArrayUsingPredicate:predicate];
    filterdhotel=[SpicilizationArr filteredArrayUsingPredicate:predicate];
    
    if (filteredContentArray)
    {
        filteredContentArray = nil;
    }
    filteredContentArray = [[NSMutableArray alloc] initWithArray:filterdArr];
    
    
    if (filteredhotelarray)
    {
        filteredhotelarray = nil;

    }
    filteredhotelarray = [[NSMutableArray alloc] initWithArray:filterdhotel];

    //     NSLog(@"filteredListContent:%@",filteredContentArray);
    
    if (searchText == nil || [searchText isEqualToString:@""])
        isSearching = NO;
    else
        isSearching = YES;
    
    [tbllocation reloadData];
    [tblhotel reloadData];
    
}


#pragma mark Is date checke

- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}

#pragma mark Touch event
-(void)touch
{
    isSearching=NO;
    
    [tblhotel reloadData];
    
    [tbllocation reloadData];
    
    [locationsearch resignFirstResponder];
    
}
- (void)showTabBar:(UITabBarController *) tabbarcontroller
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

#pragma  mark delegate for tab
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return viewController != tabBarController.selectedViewController;
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
