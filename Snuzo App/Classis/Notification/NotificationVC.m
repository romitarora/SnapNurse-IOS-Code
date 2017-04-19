//
//  NotificationVC.m
//  Nurse
//
//  Created by one click IT consultany on 8/17/16.
//  Copyright © 2016 com.Oneclick.apps. All rights reserved.
//

#import "NotificationVC.h"
#import "NurseDetailCell.h"
#import "NotificationListCell.h"
@interface NotificationVC ()
{
    UIActivityIndicatorView * indicatorFooter;
    int acceptCount, rejectCount;
    NSInteger acceptServerCount,rejectServerCount;
}
@end

@implementation NotificationVC
@synthesize isfromNotify;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    acceptCount = 0;
    rejectCount = 0;
    serviceCount = 0;


    self.navigationController.navigationBar.translucent = NO;
    
    //[self hideTabBar:self.tabBarController];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor=[UIColor grayColor];
    self.navigationItem.title = @"Notifications";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
    
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    
    if (self.isfromNotify)
    {
        backbarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(BackBtnClick)];
    }
    else
    {
        backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(BackBtnClick)];
    }

    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    [self.navigationItem setHidesBackButton:YES];
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
    
    NSArray *items = [[NSArray alloc] initWithObjects:@"Accepted",  @"Rejected",nil];
    
    segMentBtn = [[UISegmentedControl alloc] initWithItems:items];
    [segMentBtn addTarget:self action:@selector(segmenClicked:) forControlEvents:UIControlEventValueChanged];
    [segMentBtn setSelectedSegmentIndex:0];
    segMentBtn.frame = CGRectMake(20, 10, self.view.frame.size.width-40, 30);
    segMentBtn.layer.masksToBounds = YES;
    segMentBtn.layer.cornerRadius = 3.5f;
    [segMentBtn setTintColor:globelColor];
    segMentBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segMentBtn];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:13.0f]} forState:UIControlStateSelected];
    
    noticeLbl = [[UILabel alloc] init];
    noticeLbl.frame = CGRectMake(0,50, self.view.frame.size.width, viewHeight-64-49-50);
    noticeLbl.textColor = [UIColor blackColor];
    noticeLbl.textAlignment = NSTextAlignmentCenter;
    noticeLbl.backgroundColor =[UIColor clearColor];
    noticeLbl.hidden = YES;
    [self.view addSubview:noticeLbl];
    
    bookedDateArr = [[NSMutableArray alloc] init];
    bookedDateDict = [[NSMutableDictionary alloc] init];
    
    cancelledDateArr = [[NSMutableArray alloc] init];
    cancelledDateDict = [[NSMutableDictionary alloc] init];

      notificationTbl=[[UITableView alloc]initWithFrame:CGRectMake(0,50, self.view.frame.size.width, viewHeight-64-50)];
    notificationTbl.backgroundColor=[UIColor clearColor];
    notificationTbl.separatorStyle=NO;
    notificationTbl.delegate=self;
    notificationTbl.dataSource=self;
    notificationTbl.separatorStyle=UITableViewCellSeparatorStyleNone;
    notificationTbl.separatorColor=[UIColor clearColor];
    [self.view addSubview:notificationTbl];
    
    if (segMentBtn.selectedSegmentIndex == 0)
    {
        isFromCancel = NO;
        isFromAccepted = YES;
        serviceCount = 0;

        [self getHospitalBookedBookings];
    }
    else
    {
        isFromCancel = NO;
        isFromAccepted = NO;
        serviceCount = 0;

        [self getHospitalcancelledBookings];
    }
    
    indicatorFooter = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(notificationTbl.frame), 44)];
    [indicatorFooter setColor:[UIColor blackColor]];
   // [indicatorFooter startAnimating];
    [notificationTbl setTableFooterView:indicatorFooter];
    
    // Do any additional setup after loading the view.
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
            
            notificationTbl.frame=CGRectMake(0,50, self.view.frame.size.width, (viewHeight)-64-50);
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            notificationTbl.frame=CGRectMake(0,50, self.view.frame.size.width, (viewHeight)-64-50);
        }];
        
    }
    // NSLog(@"status bar height  %d", statusBarHeight);
}

-(void)BackBtnClick
{
    if (self.isfromNotify)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    pendingcount = 0;
    cancelledArr = 0;
    serviceCount = 0;
   // [self showTabBar:self.tabBarController];
}
-(void)viewWillAppear:(BOOL)animated
{
   
}
-(void)segmenClicked:(id)sender
{
    UISegmentedControl * segment = (UISegmentedControl*)sender;
    
    if (segment.selectedSegmentIndex == 0)
    {
        acceptCount=0;
        isFromCancel = NO;
        isFromAccepted = YES;
        serviceCount = 0;

        bookedDateArr = [[NSMutableArray alloc] init];
        bookedDateDict = [[NSMutableDictionary alloc] init];
        
        [self getHospitalBookedBookings];
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        rejectCount=0;
        isFromCancel = NO;
        isFromAccepted = NO;
        serviceCount = 0;

        cancelledDateArr = [[NSMutableArray alloc] init];
        cancelledDateDict = [[NSMutableDictionary alloc] init];
        [self getHospitalcancelledBookings];
    }
   
    [notificationTbl reloadData];
}
-(void)getHospitalBookedBookings
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        
        customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        if ([customerId isEqualToString:@""]||customerId==nil)
        {
            
        }
        else
        {
            isFromAccepted = YES;
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            serviceCount = serviceCount +1;
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:customerId forKey:@"customer_id"];
            [dict setValue:[NSString stringWithFormat:@"%d",acceptCount] forKey:@"start"];
            
            NSLog(@"%@",dict);
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"getHospitalBookedBookings";
            manager.delegate = self;//
            [manager urlCall:@"http://snapnurse.com/webservice/getHospitalBookedBookings"withParameters:dict];
        }
    }
    else
    {
    }
}
-(void)getHospitalcancelledBookings
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
        if ([customerId isEqualToString:@""]||customerId==nil)
        {
        }
        else
        {
            isFromAccepted = NO;
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            serviceCount = serviceCount +1;
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:customerId forKey:@"customer_id"];
            [dict setValue:[NSString stringWithFormat:@"%d",rejectCount] forKey:@"start"];
            
            NSLog(@"%@",dict);
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"getHospitalcancelledBookings";
            manager.delegate = self;//
            [manager urlCall:@"http://snapnurse.com/webservice/getHospitalcancelledBookings"withParameters:dict];
        }
    }
    else
    {
    }
}
#pragma mark - UITableview Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isFromAccepted == YES)
    {
       return bookedDateArr.count;
    }
    else
    {
       return cancelledDateArr.count;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFromAccepted)
    {
        NSInteger totalRows = [[bookedDateDict valueForKey:[bookedDateArr objectAtIndex:section]] count];
        return totalRows;
    }
    else
    {
        
        NSInteger totalRows = [[cancelledDateDict valueForKey:[cancelledDateArr objectAtIndex:section]] count];
        return totalRows;
        
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *  sectionHeader = [[UIView alloc]init];
    sectionHeader.frame = CGRectMake(10, 0, kScreenWidth-20, 30);
    sectionHeader.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:32.0f/255.0f blue:218.0f/255.0f alpha:0.8];
    
    UILabel * titleNameLbl = [[UILabel alloc]init];
    titleNameLbl.frame = CGRectMake(0, 0, sectionHeader.frame.size.width, 30);
    titleNameLbl.text =@"10 Aug 2016 ";
    ;
    titleNameLbl.textColor = [UIColor whiteColor];
    titleNameLbl.textAlignment = NSTextAlignmentCenter;
    titleNameLbl.backgroundColor = [UIColor clearColor];
    titleNameLbl.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12.5];
    [sectionHeader addSubview:titleNameLbl];
    NSString *strdate;
    
    id date ;
    
    if (isFromAccepted == YES)
    {
        date = [bookedDateArr objectAtIndex:section];
    }
    else
    {
        date = [cancelledDateArr objectAtIndex:section];
    }
    
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
        [dFrmt setDateFormat:@"MM-dd-yyyy"];
        NSString *strdate1=[NSString stringWithFormat:@"%@",[dFrmt stringFromDate:startD]];
        titleNameLbl.text=strdate1;
    }
    else
    {
        strdate=@"NA";
        titleNameLbl.text=strdate;
    }
    return  sectionHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NotificationListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[NotificationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
    }

    if (segMentBtn.selectedSegmentIndex == 0)
    {
        cell.msgLbl.text = @"accepted your booking request on";
    }
    else if (segMentBtn.selectedSegmentIndex == 1)
    {
        cell.msgLbl.text = @"rejected your booking request on";
    }
    
    NSDictionary * dict;
    if (isFromAccepted)
    {
         dict = [[bookedDateDict valueForKey:[bookedDateArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else
    {
         dict = [[cancelledDateDict valueForKey:[cancelledDateArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
        
        id img = [[dict valueForKey:@"0"]valueForKey:@"hotel_image"];
        NSString *imgstr = @"";
        if (img != [NSNull null])
        {
            imgstr = (NSString *)img;
            NSURL *url = [NSURL URLWithString:imgstr];
            cell.profileImg.imageURL=url;
        }
        else
        {
        }
        
        id name = [[dict valueForKey:@"hotels"]valueForKey:@"hotel_name"];
        NSString *nameStr = @"";
        if (name != [NSNull null])
        {
            nameStr = (NSString *)name;
            cell.titleLbl.text=[[dict valueForKey:@"hotels"]valueForKey:@"hotel_name"];
        }
        else
        {
            cell.titleLbl.text=@"NA";
        }
        
        NSString *strdate;;
        NSString * strStartTime;
        NSString * strEndTime;
        
        id startTime = [[dict valueForKey:@"booking_infos"]valueForKey:@"check_in_date_time"];
        NSString *startTimeStr = @"";
        
        if (startTime != [NSNull null])
        {
            startTimeStr = (NSString *)startTime;
            strdate = startTimeStr;
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter1.locale = twelveHourLocale;
            NSDate *  stopTime1 = [formatter1 dateFromString:strdate];
            [formatter1 setDateFormat:@"dd MMM, hh a"];//Jam22-09
            
            strStartTime= [formatter1 stringFromDate:stopTime1];
            cell.lblStartTime.text = strStartTime;
        }
        else
        {
        }
        
        NSString *strEnddate;;
        
        id EndTime = [[dict valueForKey:@"booking_infos"]valueForKey:@"check_out_date_time"];
        NSString *EndTimeStr = @"";
        if (EndTime != [NSNull null])
        {
            EndTimeStr = (NSString *)EndTime;
            strEnddate = EndTimeStr;
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter1.locale = twelveHourLocale;
            NSDate *  stopTime1 = [formatter1 dateFromString:strEnddate];
            [formatter1 setDateFormat:@"dd MMM, hh a"];//Jam22-09
            strEndTime = [formatter1 stringFromDate:stopTime1];
            cell.lblEndTime.text = strEndTime;
        }
        else
        {
            
        }
   
    cell.lblduration.backgroundColor = globelColor;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor=[UIColor whiteColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookDetail *hotelDetail=[[BookDetail alloc]init];
    
    NSDictionary * dict;
    if (isFromAccepted)
    {
        dict = [[bookedDateDict valueForKey:[bookedDateArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else
    {
        dict = [[cancelledDateDict valueForKey:[cancelledDateArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    id name = [[dict valueForKey:@"hotels"]valueForKey:@"hotel_name"];
    NSString *nameStr = @"";
    if (name != [NSNull null])
    {
        nameStr = (NSString *)name;
        hotelDetail.hotelname=[[dict valueForKey:@"hotels"]valueForKey:@"hotel_name"];
    }
    else
    {
        hotelDetail.hotelname=@"NA";
    }
    
    id img = [[dict valueForKey:@"0"]valueForKey:@"hotel_image"];
    NSString *imgStr = @"";
    if (img != [NSNull null])
    {
        imgStr = (NSString *)img;
        
    }
    else
    {
        imgStr=@"NA";
    }
    
    hotelDetail.imageurl=imgStr;
    hotelDetail.cartDetails=[dict mutableCopy];
    hotelDetail.strBOOKID=[[dict valueForKey:@"booking_infos"]valueForKey:@"booking_id"];
    
    id status = [[dict valueForKey:@"booking_infos"]valueForKey:@"status"];
    NSString *strstatus = @"";
    if (status != [NSNull null])
    {
        strstatus = (NSString *)status;
    }
    else
    {
        strstatus=@"NA";
    }
    
    id action = [[dict valueForKey:@"booking_infos"]valueForKey:@"action_by"];
    NSString *actionBy = @"";
    if (action != [NSNull null])
    {
        actionBy = (NSString *)action;
    }
    else
    {
        actionBy=@"NA";
    }
    
    
    if ([strstatus isEqualToString:@"0"])
    {
        strstatus=@"Pending";
        hotelDetail.isFromPast=@"NO";
    }
    else if ([strstatus isEqualToString:@"1"])
    {
        strstatus=@"Booked";
        hotelDetail.isFromPast=@"NO";
    }
    else if ([strstatus isEqualToString:@"2"])
    {
        strstatus=@"Failed";
        hotelDetail.isFromPast=@"YES";
    }
    else if ([strstatus isEqualToString:@"5"])
    {
        strstatus=@"Completed";
        hotelDetail.isFromPast=@"YES";
        
    }
    else if([strstatus isEqualToString:@"3"])
    {
        if ([actionBy isEqualToString:@"0"])
        {
            strstatus=@"Cancelled";
        }
        else if ([actionBy isEqualToString:@"1"])
        {
            strstatus=@"Rejected";
        }
        else if ([actionBy isEqualToString:@"2"])
        {
            strstatus=@"Cancelled";
        }
       
        hotelDetail.isFromPast=@"YES";
    }
    hotelDetail.strStaus=strstatus;
    id specialization = [[dict valueForKey:@"0"]valueForKey:@"specialization"];
    
    NSString *specializationStr = @"";
    if (specialization != [NSNull null])
    {
        specializationStr = (NSString *)specialization;
        NSArray *items = [specializationStr componentsSeparatedByString:@","];
        hotelDetail.specializationArr = items;
    }
    else
    {
        hotelDetail.specializationArr = [NSArray new];
    }
    
    hotelDetail.strHospitalName =[NSString stringWithFormat:@"%@",[[dict valueForKey:@"hospitals"] valueForKey:@"first_name"]];
    hotelDetail.strCustomerName =[NSString stringWithFormat:@"%@ %@",[[dict valueForKey:@"customers"] valueForKey:@"first_name"],[[dict valueForKey:@"customers"] valueForKey:@"last_name"]];
    
    hotelDetail.isFromNotification = YES;
    hotelDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotelDetail animated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    
    return YES;
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{

        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                              {
                                                  
                                                  URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Are you sure you want to delete this notification" cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                                                  [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                                                  alert.tag=0;
                                                  [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
                                                   {
                                                       [alertView hideWithCompletionBlock:^{
                                                           
                                                           if(buttonIndex==0)
                                                           {
                                                               [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                                                               
                                                               NSDictionary * dict1;
                                                               if (isFromAccepted)
                                                               {
                                                                   dict1 = [[bookedDateDict valueForKey:[bookedDateArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                                                               }
                                                               else
                                                               {
                                                                   dict1 = [[cancelledDateDict valueForKey:[cancelledDateArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                                                               }
                                                               
                                                               selectedSection = indexPath.section;
                                                               selectedIndex = indexPath.row;
                                                               serviceCount = serviceCount + 1;
                                                               deleteDict=[[NSMutableDictionary alloc]init];
                                                               [deleteDict setValue:[[dict1 valueForKey:@"booking_infos"]valueForKey:@"booking_id"] forKey:@"booking_id"];
                                                               NSLog(@"%@",deleteDict);
                                                               
                                                               URLManager *manager = [[URLManager alloc] init];
                                                               manager.commandName = @"deleteBooking";
                                                               manager.delegate = self;//
                                                               [manager urlCall:@"http://snapnurse.com/webservice/deleteBooking"withParameters:deleteDict];
                                                           }
                                                           else
                                                           {
                                                           }
                                                       }];
                                                   }];
                                                  [alert showWithAnimation:URBalertAnimationType];;
                                              }];
        
        return @[deleteAction];
   
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Are you sure you want to delete this notification" cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        alert.tag=0;
        [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
         {
             [alertView hideWithCompletionBlock:^{
                 
                 if(buttonIndex==0)
                 {
                     
                 }
                 else
                 {
                     
                 }
             }];
         }];
        [alert showWithAnimation:URBalertAnimationType];;
        
    }
}
#pragma mark - URL Manager Delegates

-(void)onResult:(NSDictionary *)result
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    [indicatorFooter stopAnimating];
    serviceCount = 0;
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"getHospitalBookedBookings"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            NSArray * tempAddArr =[[NSArray alloc] init];
            
            acceptServerCount = [[[result objectForKey:@"result"] objectForKey:@"booked"] integerValue];
           
            if ([[[result objectForKey:@"result"] objectForKey:@"data"] count]>0)
            {
                tempAddArr=[[[result objectForKey:@"result"] objectForKey:@"data"] allKeys];
                
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                NSArray *descriptors=[NSArray arrayWithObject: descriptor];
                NSArray *reverseOrder=[tempAddArr sortedArrayUsingDescriptors:descriptors];
                
                // NSLog(@"%@", reverseOrder);
                
                [bookedDateArr addObjectsFromArray:reverseOrder];
                
//                bookedDateDict =[[result valueForKey:@"result"] valueForKey:@"data"];
                [bookedDateDict addEntriesFromDictionary:[[result valueForKey:@"result"] valueForKey:@"data"]];
                
                notificationTbl.hidden = NO;
                noticeLbl.hidden = YES;
                [notificationTbl reloadData];
            }
            else
            {
                if(acceptCount == 0)
                {
                    bookedDateArr = [[NSMutableArray alloc] init];
                    bookedDateDict = [[NSMutableDictionary alloc] init];
                    [notificationTbl reloadData];
                    noticeLbl.hidden = NO;
                    noticeLbl.text = @"No data found";
                }
                else
                {
                    [notificationTbl reloadData];
                    noticeLbl.hidden = NO;
                    noticeLbl.text = @"No data found";
                }
               
            }
           
        }
        else
        {
            [notificationTbl reloadData];
            noticeLbl.hidden = YES;
            
            
            if(acceptCount == 0)
            {
                noticeLbl.hidden = NO;
                noticeLbl.text = @"No data found";
            }
            else
            {
                noticeLbl.hidden = YES;
            }
        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"getHospitalcancelledBookings"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            rejectServerCount = [[[result objectForKey:@"result"] objectForKey:@"booked"] integerValue];

            NSArray * tempAddArr =[[NSArray alloc] init];
                       
            if ([[[result objectForKey:@"result"] objectForKey:@"data"] count]>0)
            {
                tempAddArr=[[[result objectForKey:@"result"] objectForKey:@"data"] allKeys];
                
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                NSArray *descriptors=[NSArray arrayWithObject: descriptor];
                NSArray *reverseOrder=[tempAddArr sortedArrayUsingDescriptors:descriptors];
                
                [cancelledDateArr addObjectsFromArray:reverseOrder];
                
                [cancelledDateDict addEntriesFromDictionary:[[result valueForKey:@"result"] valueForKey:@"data"]];

                notificationTbl.hidden = NO;
                [notificationTbl reloadData];
                noticeLbl.hidden = YES;
            }
            else
            {
                
                if(rejectCount == 0)
                {
                    cancelledDateArr = [[NSMutableArray alloc] init];
                    cancelledDateDict = [[NSMutableDictionary alloc] init];
                    [notificationTbl reloadData];
                    noticeLbl.hidden = NO;
                    noticeLbl.text = @"No data found";
                }
                else
                {
                   // cancelledDateArr = [[NSMutableArray alloc] init];
                   // cancelledDateDict = [[NSMutableDictionary alloc] init];
                    [notificationTbl reloadData];
                    noticeLbl.hidden = NO;
                    noticeLbl.text = @"No data found";
                }

            }
           
        }
        else
        {
            [notificationTbl reloadData];
            noticeLbl.hidden = YES;
            
            if(rejectCount == 0)
            {
                noticeLbl.hidden = NO;
                noticeLbl.text = @"No data found";
            }
            else
            {
                noticeLbl.hidden = YES;
            }
        }
    }
    
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"deleteBooking"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            
            if (isFromAccepted)
            {
                
                
                [[bookedDateDict valueForKey:[bookedDateArr objectAtIndex:selectedSection]] removeObjectAtIndex:selectedIndex];
                
                if ([[bookedDateDict valueForKey:[bookedDateArr objectAtIndex:selectedSection]] count]>0)
                {
                    
                }
                else
                {
                    [bookedDateDict removeObjectForKey:[bookedDateArr objectAtIndex:selectedSection]];
                    [bookedDateArr removeObjectAtIndex:selectedSection];
                    
                }
                
                if (bookedDateDict.count > 0)
                {
                    noticeLbl.hidden = YES;
                    noticeLbl.text = @"";
                    notificationTbl.hidden = NO;
                    [notificationTbl reloadData];
                }
                else
                {
                    noticeLbl.hidden = NO;
                    noticeLbl.text = @"No data found";
                    notificationTbl.hidden = YES;
                }
            }
            else
            {
                
                [[cancelledDateDict valueForKey:[cancelledDateArr objectAtIndex:selectedSection]] removeObjectAtIndex:selectedIndex];
                
                if ([[cancelledDateDict valueForKey:[cancelledDateArr objectAtIndex:selectedSection]] count]>0)
                {
                    
                }
                else
                {
                    [cancelledDateDict removeObjectForKey:[cancelledDateArr objectAtIndex:selectedSection]];
                    [cancelledDateArr removeObjectAtIndex:selectedSection];
                    
                }
                
                if (cancelledDateDict.count > 0)
                {
                    noticeLbl.hidden = YES;
                    noticeLbl.text = @"";
                    notificationTbl.hidden = NO;
                    [notificationTbl reloadData];
                }
                else
                {
                    noticeLbl.hidden = NO;
                    noticeLbl.text = @"No data found";
                    notificationTbl.hidden = YES;
                }
            }
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Booking deleted successfully" cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            alert.tag=0;
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {
                 [alertView hideWithCompletionBlock:^{
                     
                     if(buttonIndex==0)
                     {
                         
//                         if (isFromAccepted)
//                         {
//                             [self getHospitalBookedBookings];
//                         }
//                         else
//                         {
//                             [self getHospitalcancelledBookings];
//                         }
                     }
                     else
                     {
                     }
                 }];
             }];
            [alert showWithAnimation:URBalertAnimationType];;
            // [notificationTbl reloadData];
        }
        else
        {
        }
    }
    else
    {
    }
}
- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    //    [app hudEndProcessMethod];
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
        if ([commandName isEqualToString:@"getHospitalBookedBookings"])
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
                [self getHospitalBookedBookings];
                
            }
        }
        else if ([commandName isEqualToString:@"getHospitalcancelledBookings"])
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
                [self getHospitalcancelledBookings];
                
            }
        }
        else if ([commandName isEqualToString:@"deleteBooking"])
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
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                serviceCount = serviceCount + 1;
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"deleteBooking";
                manager.delegate = self;//
                [manager urlCall:@"http://snapnurse.com/webservice/deleteBooking"withParameters:deleteDict];
                
            }
        }
    }

}
#pragma mark  SHOW TAB BAR AT BOTTOM

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


-(void)refreshTableVeiwList
{
    if (isFromAccepted)
    {
        acceptCount=acceptCount+10;

        if (acceptCount >= acceptServerCount)
        {
            
        }
        else
        {
            [self getHospitalBookedBookings];

        }
        NSLog(@"Accepted =%d",acceptCount);
    }
    else
    {
        rejectCount=rejectCount+10;

        if (rejectCount >= rejectServerCount)
        {
            
        }
        else
        {
            [self getHospitalcancelledBookings];
            
        }
        NSLog(@"Rejected =%d",rejectCount);
    }
    

    // your refresh code goes here
}
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height)
    {
        
        [self refreshTableVeiwList];
    }
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
