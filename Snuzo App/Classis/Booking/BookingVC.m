//
//  BookingVC.m
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "BookingVC.h"
#import "CLWeeklyCalendarView.h"
#import "hoteldetailVC.h"
#import "NotificationVC.h"
@interface BookingVC ()<CLWeeklyCalendarViewDelegate>
{
    NSDate * globalSelctedDate;
}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;

@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation BookingVC

- (void)viewDidLoad
{
    [self.view addSubview:self.calendarView];
    self.navigationController.navigationBarHidden=YES;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    pastbookArray = [[NSMutableArray alloc]init];
    
    notificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notificationBtn.frame = CGRectMake(self.view.frame.size.width-60, 20, 60, 40);
    [notificationBtn setImage:[UIImage imageNamed:@"selected-notification"] forState:UIControlStateNormal];
    [notificationBtn addTarget:self action:@selector(notificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notificationBtn];
    
    tblCurrentBook=[[UITableView alloc]initWithFrame:CGRectMake(0, 158, self.view.bounds.size.width, viewHeight-158-49)];
    tblCurrentBook.delegate=self;
    tblCurrentBook.dataSource=self;
    tblCurrentBook.separatorStyle=normal;
    tblCurrentBook.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tblCurrentBook];
    
    serviceCount = 0;
    [self refreshView];
    
     isFirstTime = YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    tblCurrentBook.hidden = YES;
     self.navigationController.navigationBarHidden=YES;
     self.navigationController.title = @"";
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [currentbookarray removeAllObjects];
     countcurrent = 0;
    serviceCount = 0;
     [self getcurrent];
  
}
-(void)viewWillDisappear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
}
//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView)
    {
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
        
    }
    return _calendarView;
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
            tblCurrentBook.frame=CGRectMake(0, 158, self.view.frame.size.width, viewHeight-158-49);
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            tblCurrentBook.frame=CGRectMake(0, 158, self.view.frame.size.width, viewHeight-158-49);
        }];
        
    }
    // NSLog(@"status bar height  %d", statusBarHeight);
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationBackgroundRefreshStatusDidChangeNotification object:nil];
}
#pragma mark - NotificationClick
-(void)notificationBtnClick
{
    NotificationVC *Notification=[[NotificationVC alloc]init];
     Notification.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Notification animated:YES];
}
#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @1,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}
-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
   
    globalSelctedDate = date;
    NSDateFormatter *dateFormate=[[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"YYYY-MM-dd"];
    NSString * dateString = [dateFormate stringFromDate:date];
    
    NSArray * temp = [dateString componentsSeparatedByString:@" "];
   
    selectedDate = [NSString stringWithFormat:@"%@",[temp objectAtIndex:0]];
    countcurrent = 0;
    serviceCount = 0;
    [currentbookarray removeAllObjects];
    [self getcurrent];
    
}
-(void)refreshView
{
    NSDateFormatter *dateFormate=[[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"YYYY-MM-dd"];
    NSString * dateString = [dateFormate stringFromDate:[NSDate date]];
    
    NSArray * temp = [dateString componentsSeparatedByString:@" "];
    
    selectedDate = [NSString stringWithFormat:@"%@",[temp objectAtIndex:0]];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Personal Info View;
-(void)pastbookView
{
    pastbookView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,scrlcontent.frame.size.height-90-65)];
    pastbookView.backgroundColor=[UIColor clearColor];
    
    lblpastbook=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,pastbookView.frame.size.height-64)];
    lblpastbook.textColor=[UIColor whiteColor];
    lblpastbook.textAlignment=NSTextAlignmentCenter;
    
    lblpastbook.hidden=NO;
    lblpastbook.numberOfLines=0;
    lblpastbook.text=@"You have no past bookings with Chillyn App";
    [pastbookView addSubview:lblpastbook];
    
    
    tblPastBooking=[[UITableView alloc]initWithFrame:CGRectMake(0,0, pastbookView.frame.size.width, pastbookView.frame.size.height)];
    tblPastBooking.delegate=self;
    tblPastBooking.dataSource=self;
    tblPastBooking.separatorStyle=normal;
    tblPastBooking.backgroundColor=[UIColor clearColor];
    [pastbookView addSubview:tblPastBooking];
    [scrlcontent addSubview:pastbookView];
    
}

-(void)mybooking
{
    currentBookview=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,scrlcontent.frame.size.height-90-65)];
    currentBookview.backgroundColor=[UIColor clearColor];
    
    lblcurrentbook=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,pastbookView.frame.size.height-64)];
    lblcurrentbook.text=@"You have not booked any hotel with Chillyn App";
    lblcurrentbook.textColor=[UIColor whiteColor];
    
    lblcurrentbook.textAlignment =NSTextAlignmentCenter;
    lblcurrentbook.hidden=NO;
    lblcurrentbook.numberOfLines=0;
    
    [currentBookview addSubview:lblcurrentbook];

    tblCurrentBook=[[UITableView alloc]initWithFrame:CGRectMake(0,0, currentBookview.frame.size.width, currentBookview.frame.size.height)];
    tblCurrentBook.delegate=self;
    tblCurrentBook.dataSource=self;
    tblCurrentBook.separatorStyle=normal;
    
    tblCurrentBook.backgroundColor=[UIColor clearColor];
    [currentBookview addSubview:tblCurrentBook];
    [scrlcontent addSubview:currentBookview];

}


-(void)headerclick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag==1)
    {
        countcurrent=0;
        
        [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
        {
            customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
            if ([customerId isEqualToString:@""]||customerId==nil)
            {
                
            }
            else
            {
              [self getcurrent];
                
            }

        }
    }
    else
    {
        
        countPast=0;
        
        [scrlcontent setContentOffset:CGPointMake(0, 0) animated:YES];

        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
        {
            
            customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
            if ([customerId isEqualToString:@""]||customerId==nil)
            {
                
            }
            else
            {
                [self getpastBokking];
                
                
            }

        }
        
    }
}


#pragma mark---- Get current and pastbooking

-(void)getcurrent
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
           // [currentbookarray removeAllObjects];
           // currentbookarray=nil;
           // currentbookarray=[[NSMutableArray alloc]init];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            serviceCount = serviceCount+1;
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:customerId forKey:@"login_user_id"];
            [dict setValue:[NSString stringWithFormat:@"%ld",(long)countcurrent] forKey:@"start"];
            [dict setValue:selectedDate forKey:@"date"];
            NSLog(@"%@",dict);
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"getcurrentBokking";
            manager.delegate = self;//
            [manager urlCall:@"http://snapnurse.com/webservice/getBookings"withParameters:dict];
        }
    }
    else
    {
        if (isFirstTime)
        {
            isFirstTime = NO;
        }
        else
        {
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Login !" message:@"Please login first." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            alert.tag=0;
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {
                 [alertView hideWithCompletionBlock:
                  ^{
                      LoginVC *SignUp=[[LoginVC alloc]init];
                      SignUp.strIsfromCalender=@"YES";
                      SignUp.hidesBottomBarWhenPushed = YES;
                      [self.navigationController pushViewController:SignUp animated:YES];
                  }];
             }];
            [alert showWithAnimation:URBalertAnimationType];;
        }
       
    }
    
}
-(void)getpastBokking
{
    
    customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
    
    if ([customerId isEqualToString:@""]||customerId==nil)
    {
        
    }
    else
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setValue:customerId forKey:@"login_user_id"];
        [dict setValue:[NSString stringWithFormat:@"%ld",(long)countPast] forKey:@"start_id"];
        URLManager *manager = [[URLManager alloc] init];
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];

        
         NSLog(@"DICT:--%@",dict);
        manager.commandName = @"getpastbokking";
        manager.delegate = self;
        [manager urlCall:@"http://snapnurse.com/webservice/getPastBooking" withParameters:dict];
    }
    
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == scrlcontent)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page==1)
        {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
            [UIView commitAnimations];
            
            [UIView animateWithDuration:.5 animations:^{
                lblLine.frame=CGRectMake( self.view.frame.size.width/2, 37, self.view.frame.size.width/2, 3);
            } completion:^(BOOL finished) {
            }];
            
        }
        else
        {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
            [UIView commitAnimations];
            
            [UIView animateWithDuration:.5 animations:^{
                lblLine.frame=CGRectMake( 0, 37, self.view.frame.size.width/2, 3);
            } completion:^(BOOL finished) {
            }];
            
        }
        
    }
    else if(scrollView==tblCurrentBook)
    {
    
            [pullToRefreshManager_Images tableViewReleased];

    }
    else if (tblPastBooking)
    {
        [PullTorefrehManager_Past tableViewReleased];

    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == scrlcontent)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page == 0)
        {
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
            {
                customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
                if ([customerId isEqualToString:@""]||customerId==nil)
                {
                    
                }
                else
                {
                    //[self getpastBokking];
                }
                
            }
            
            
            
//            [UIView animateWithDuration:0.2 animations:^{
//                lblLine.frame=CGRectMake(0, 37, self.view.frame.size.width/2, 3);
//            } completion:^(BOOL finished) {
//            }];
        }
        else if (page == 1)
        {
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
            {
                customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
                if ([customerId isEqualToString:@""]||customerId==nil)
                {
                    
                    
                }
                else
                {
                    [self getcurrent];

                    
                }
                
            }
            
            
//            [UIView animateWithDuration:0.2 animations:^{
//                lblLine.frame=CGRectMake(self.view.frame.size.width/2, 37, self.view.frame.size.width/2, 3);
//            } completion:^(BOOL finished) {
//            }];
        }
        else if (page == 2)
        {
            
        }
        
    }
}
#pragma mark - URL Manager Delegates

-(void)onResult:(NSDictionary *)result
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    serviceCount = 0;
     NSLog(@"The result is...%@", result);
    if([[result valueForKey:@"commandName"] isEqualToString:@"getpastbokking"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            tblCurrentBook.hidden = NO;
            if (countPast==0)
            {
                [pastbookArray removeAllObjects];
                pastbookArray=nil;
                pastbookArray=[[NSMutableArray alloc]init];
            }
            NSMutableArray*   tempFeedsArray=[[NSMutableArray alloc]init];
            tempFeedsArray=[[[result valueForKey:@"result"]valueForKey:@"data"]mutableCopy];
            [pastbookArray addObjectsFromArray:tempFeedsArray ];
            if ([tempFeedsArray count] >=10)
            {
                PullTorefrehManager_Past =[[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:tblPastBooking withClient:self];
                [PullTorefrehManager_Past tableViewReloadFinished];
                [PullTorefrehManager_Past setPullToRefreshViewVisible:YES];
            }
            else
            {
                [PullTorefrehManager_Past tableViewReloadFinished];
                [PullTorefrehManager_Past setPullToRefreshViewVisible:NO];
            }
            if (pastbookArray.count==0)
            {
                lblpastbook.hidden=NO;
            }
            else
            {
                lblpastbook.hidden=YES;
            }
            [tblPastBooking reloadData];
        }
        else
        {
            tblCurrentBook.hidden = YES;
            if (countPast==0)
            {
                
            }
            else
            {
                
            }
            [PullTorefrehManager_Past tableViewReloadFinished];
            [PullTorefrehManager_Past setPullToRefreshViewVisible:NO];
            [tblPastBooking reloadData];
        }
       
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getcurrentBokking"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            [lblcurrentbook removeFromSuperview];
            lblcurrentbook.hidden=YES;
           tblCurrentBook.hidden = NO;
            if (countcurrent==0)
            {
                [currentbookarray removeAllObjects];
                currentbookarray=nil;
                currentbookarray=[[NSMutableArray alloc]init];
            }
            NSMutableArray*   tempFeedsArray=[[NSMutableArray alloc]init];
            tempFeedsArray=[[[result valueForKey:@"result"]valueForKey:@"data"]mutableCopy];
            
            [currentbookarray addObjectsFromArray:tempFeedsArray ];
            if ([tempFeedsArray count] >=10)
            {
                
                pullToRefreshManager_Images =[[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:tblCurrentBook withClient:self];
                [pullToRefreshManager_Images tableViewReloadFinished];
                [pullToRefreshManager_Images setPullToRefreshViewVisible:YES];
                
            }
            else
            {
                [pullToRefreshManager_Images tableViewReloadFinished];
                [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
            }

            if (currentbookarray.count==0)
            {
                lblcurrentbook.hidden=NO;
            }
            else
            {
                lblcurrentbook.hidden=YES;
                
            }
            NSDate * date = _calendarView.selectedDate;
            NSString * strFormat = @"EEE, d MMM yyyy";
            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:strFormat];
            NSString *strDate = [dayFormatter stringFromDate:date];
            // NSString *strMonth;
            
            int bookedCount = 0, cancelledCount = 0, pendingCount = 0,completedCount = 0;//Jam22-09
            for (int i=0; i<[currentbookarray count]; i++)
            {
                id status = [[[currentbookarray objectAtIndex:i]valueForKey:@"booking_infos"]valueForKey:@"status"];
                NSString * strstatus;
                if (status != [NSNull null])
                {
                    strstatus = (NSString *)status;
                }
                else
                {
                    strstatus = @"NA";
                }
                
                if ([strstatus isEqualToString:@"0"])
                {
                    pendingCount= pendingCount +1;
                }
                else if ([strstatus isEqualToString:@"1"])
                {
                    bookedCount= bookedCount +1;
                }
                else if([strstatus isEqualToString:@"3"])
                {
                    cancelledCount=cancelledCount+1;
                }
                else if([strstatus isEqualToString:@"5"])//Jam22-09
                {
                    completedCount=completedCount+1;
                }
            }
            strDate = [NSString stringWithFormat:@"Total nurses : %lu | Booked : %d  \n%@", (unsigned long)[currentbookarray count],bookedCount,strDate ];//Jam22-09
            _calendarView.dateInfoLabel.text = strDate;
            _calendarView.dateInfoLabel.numberOfLines = 0;
            
            [tblCurrentBook reloadData];
        }
        else
        {
            
            NSDate * date = _calendarView.selectedDate;
            NSString * strFormat = @"EEE, d MMM yyyy";
            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:strFormat];
            NSString *strDate = [dayFormatter stringFromDate:date];
            // NSString *strMonth;
            
            if ([currentbookarray count]>0)
            {
                strDate = [NSString stringWithFormat:@"Total %lu nurses booked\n%@", (unsigned long)[currentbookarray count],strDate ];
                _calendarView.dateInfoLabel.text = strDate;
            }
            else
            {
                strDate = [NSString stringWithFormat:@"Total 0 nurses booked\n%@",strDate ];
                _calendarView.dateInfoLabel.text = strDate;
            }
            
            
            if (countcurrent==0)
            {
                tblCurrentBook.hidden = YES;
                [currentbookarray removeAllObjects];
                [tblCurrentBook reloadData];
                
                [lblcurrentbook removeFromSuperview];
                lblcurrentbook =nil;
                  lblcurrentbook=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,viewHeight-64)];
                lblcurrentbook.text=@"You have not booked any nurse with SnapNurse App";
                lblcurrentbook.textColor=[UIColor blackColor];
                lblcurrentbook.textAlignment =NSTextAlignmentCenter;
                lblcurrentbook.hidden=NO;
                lblcurrentbook.numberOfLines=0;
                
                [self.view addSubview:lblcurrentbook];
            }
            
            [pullToRefreshManager_Images tableViewReloadFinished];
            [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
            [tblCurrentBook reloadData];
        }
    }
    else  if([[result valueForKey:@"commandName"] isEqualToString:@"CancleBooking"])
    {
        
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];

            countPast=0;
            countcurrent=0;
            [self getcurrent];

        }
        else
        {
            
        }
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
        if ([commandName isEqualToString:@"getcurrentBokking"])
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
                [self getcurrent];
              
            }
        }
    }
}

#pragma mark --Tableview Delegate And Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentbookarray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100+3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = nil;
    pastbookingcell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[pastbookingcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"";
    cell.selectionStyle=normal;
    cell.lblNurseName.text = @"";
    
    id img = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"hotel_image"];
    NSString *imgstr = @"";
    if (img != [NSNull null])
    {
        imgstr = (NSString *)img;
         NSURL *url = [NSURL URLWithString:imgstr];
        cell.imgNurse.imageURL=url;
    }
    else
    {
       
    }
    
    id name = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"hotels"]valueForKey:@"hotel_name"];
    NSString *nameStr = @"";
    if (name != [NSNull null])
    {
        nameStr = (NSString *)name;
        cell.lblNurseName.text=[[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"hotels"]valueForKey:@"hotel_name"];
    }
    else
    {
        cell.lblNurseName.text=@"NA";
    }
    
    NSString *strdate;;
    NSString * strStartTime;
    NSString * strEndTime;
    NSDate * checkInDate;
    NSDate * checkOutDate;
    NSString * cmpStar, *cmpEnd, *cmpToday;
    
    
    id startTime = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"check_in_date_time"];
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
        [formatter1 setDateFormat:@"hh a"];//Jam22-09
        checkInDate = stopTime1;
        strStartTime= [formatter1 stringFromDate:stopTime1];
        cell.lblStartTime.text = strStartTime;
        [formatter1 setDateFormat:@"dd"];
        cmpStar= [formatter1 stringFromDate:stopTime1];
    }
    else
    {
       
    }
    
    NSString *strEnddate;;
    
    id EndTime = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"check_out_date_time"];
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
        checkOutDate =stopTime1;
        [formatter1 setDateFormat:@"hh a"];//Jam22-09
        strEndTime = [formatter1 stringFromDate:stopTime1];
        cell.lblEndTime.text = strEndTime;
        [formatter1 setDateFormat:@"dd"];
        cmpEnd= [formatter1 stringFromDate:stopTime1];
    }
    else
    {
        
    }
    
    
    id hour = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"package_hours"]valueForKey:@"actual_hours"];
    NSString *hourStr = @"";
    if (hour != [NSNull null])
    {
        hourStr = (NSString *)hour;
        cell.lblHrs.text = [NSString stringWithFormat:@"%@ HRS",hourStr];
    }
    else
    {
        cell.lblHrs.text=@"NA";
    }
   
    
    NSDate *currentDate = globalSelctedDate;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    cmpToday= [NSString stringWithFormat:@"%02ld",(long)[components day]];
    
    
    if ([cmpStar isEqualToString:cmpEnd])
    {
        cell.lblduration.frame = CGRectMake(90, 70+3,235-95, 18);
        cell.lblStartTime.frame = CGRectMake(90, 70+3, 50, 18);
        cell.sepratorLineImg.frame = CGRectMake(140, 70+3+6, 42, 6);
        cell.lblEndTime.frame = CGRectMake(182, 70+3, 50, 18);
    }
    else
    {
        if ([cmpStar isEqualToString:cmpToday])
        {
            cell.lblduration.frame = CGRectMake(90, 70+3,170, 18);
            cell.lblStartTime.frame = CGRectMake(90, 70+3, 50, 18);
            cell.sepratorLineImg.frame = CGRectMake(140, 70+3+6, 42, 6);
            cell.lblEndTime.frame = CGRectMake(182, 70+3,80, 18);
            cell.lblEndTime.text = [NSString stringWithFormat:@"%@(Next)",strEndTime];
            
        }
        else
        {
            cell.lblduration.frame = CGRectMake(90, 70+3,170, 18);
            cell.lblStartTime.frame = CGRectMake(90, 70+3, 80, 18);
            cell.sepratorLineImg.frame = CGRectMake(140+30, 70+3+6, 42, 6);
            cell.lblEndTime.frame = CGRectMake(182+30, 70+3, 50, 18);
            
            cell.lblStartTime.text = [NSString stringWithFormat:@"%@(Prev)",strStartTime];
            
        }
    }
   /* id specialization = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"specialization"];
    
    NSString *specializationStr = @"";
    if (specialization != [NSNull null])
    {
        specializationStr = (NSString *)specialization;
//        NSArray *items = [specializationStr componentsSeparatedByString:@","];
//         [cell specialization:items atIndexPath:indexPath];
    }
    else
    {
        
    }*/
    
    NSString *strstatus;
    NSString *actionbyStr;
    
    id status = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"status"];
    
    id action_by = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"action_by"];
    
    if (status != [NSNull null])
    {
        strstatus = (NSString *)status;
    }
    else
    {
        strstatus = @"NA";
    }
    
    if (action_by != [NSNull null])
    {
        actionbyStr = (NSString *)action_by;
    }
    else
    {
        actionbyStr = @"0";
    }
    cell.lblStatus.textColor = [UIColor whiteColor];
    if ([strstatus isEqualToString:@"0"])
    {
        cell.lblStatus.text=@"Pending";
        cell.lblStatus.backgroundColor = [UIColor orangeColor];
    }
    else if ([strstatus isEqualToString:@"1"])
    {
        cell.lblStatus.text=@"Booked";
        cell.lblStatus.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:127.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        
    }
    else if ([strstatus isEqualToString:@"2"])
    {
        cell.lblStatus.text=@"Failed";
    }
    else if ([strstatus isEqualToString:@"5"])
    {
        cell.lblStatus.text=@"Completed";
        cell.lblStatus.backgroundColor = [UIColor grayColor];
    }
    else if([strstatus isEqualToString:@"3"])
    {
        if ([actionbyStr isEqualToString:@"0"])
        {
             cell.lblStatus.text=@"Cancelled";
        }
        else if ([actionbyStr isEqualToString:@"1"])
        {
             cell.lblStatus.text=@"Rejected";
        }
        else if ([actionbyStr isEqualToString:@"2"])
        {
             cell.lblStatus.text=@"Cancelled";
        }
       
        cell.lblStatus.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        BookDetail *hotelDetail=[[BookDetail alloc]init];
        
        id name = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"hotels"]valueForKey:@"hotel_name"];
        NSString *nameStr = @"";
        if (name != [NSNull null])
        {
            nameStr = (NSString *)name;
             hotelDetail.hotelname=[[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"hotels"]valueForKey:@"hotel_name"];
        }
        else
        {
            hotelDetail.hotelname=@"NA";
        }
      
    
        hotelDetail.cartDetails=[[currentbookarray objectAtIndex:indexPath.row]mutableCopy];
        hotelDetail.strBOOKID=[[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"booking_id"];
    
    id img = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"hotel_image"];
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
    
    id status = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"status"];
    NSString *strstatus = @"";
    if (status != [NSNull null])
    {
        strstatus = (NSString *)status;
    }
    else
    {
        strstatus=@"NA";
    }
    
    id action = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"booking_infos"]valueForKey:@"action_by"];
    NSString *actionBy = @"";
    if (action != [NSNull null])
    {
        actionBy = (NSString *)action;
    }
    else
    {
        actionBy=@"NA";
    }

    
        if ([strstatus isEqualToString:@"0"]) {
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
        id specialization = [[[currentbookarray objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"specialization"];
    
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
    
       hotelDetail.strHospitalName =[NSString stringWithFormat:@"%@",[[[currentbookarray objectAtIndex:indexPath.row] valueForKey:@"hospitals"] valueForKey:@"first_name"]];
       hotelDetail.strCustomerName =[NSString stringWithFormat:@"%@ %@",[[[currentbookarray objectAtIndex:indexPath.row] valueForKey:@"customers"] valueForKey:@"first_name"],[[[currentbookarray objectAtIndex:indexPath.row] valueForKey:@"customers"] valueForKey:@"last_name"]];
       hotelDetail.isFromNotification = NO;
        hotelDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hotelDetail animated:YES];
    
}

#pragma  mark Cancle Service

-(void)cancelClick:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSInteger Tag;
    Tag=button.tag;
    if ([customerId isEqualToString:@""]||customerId==nil)
    {
    }
    else
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"sign up" message:@"Are you sure to cancel booking ?" cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        alert.tag=0;
        [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
         {
             [alertView hideWithCompletionBlock:^{
                 
                 if (buttonIndex==0)
                 {
                     
                     NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                     
                     [dict setObject:customerId forKey:@"login_user_id"];
                     [dict setObject:[[[currentbookarray objectAtIndex:Tag]valueForKey:@"booking_infos"]valueForKey:@"booking_id"] forKey:@"booking_id"];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];

                  
                     URLManager *manager = [[URLManager alloc] init];
                     manager.commandName = @"CancleBooking";
                     manager.delegate = self;//
                     [manager urlCall:@"http://snapnurse.com/webservice/cancelBooking"withParameters:dict];
                 }
                 else
                 {
                     
                 }
             }];
         }];
         [alert showWithAnimation:URBalertAnimationType];;
        
        
      }
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [pullToRefreshManager_Images tableViewReleased];
//}
#pragma mark MNMBottomPullToRefreshManagerClient


- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5f];

}


#pragma mark MNMBottomPullToRefreshManagerClient


-(void)loadTable
{
     NSLog(@"Load");
    
    countcurrent=countcurrent+10;
    [self getcurrent];
    
    
    //    if ([hotellistarray count] == 10)
    //    {
    //        [pullToRefreshManager_Images tableViewReloadFinished];
    //        [pullToRefreshManager_Images setPullToRefreshViewVisible:YES];
    //    }else{
    //
    //        [pullToRefreshManager_Images tableViewReloadFinished];
    //        [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
    //    }
    
    
    
}
-(void)LoadPastTable
{
    countPast=countPast+10;
    [self getpastBokking];

}

#pragma mark - Set Attribute Strings
-(void)setAttributedTextForGivenString:(NSString*)givenString AndLabel:(UILabel*)label AndTextAlignment:(NSTextAlignment)alignment AndLineSpacing:(CGFloat)lineSpacing AndFontName:(NSString*)fontName AndFontSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style};
    label.attributedText = [[NSAttributedString alloc] initWithString:givenString attributes:attributtes];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textAlignment = alignment;
}
-(NSMutableArray *)sortArrayBasedOndate:(NSMutableArray *)arraytoSort
{
   
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setDateFormat:@"HH:mm"];
    
    
    NSComparator compareTimes = ^(id string1, id string2)
    {
        NSDate *time1 = [fmtTime dateFromString:string1];
        NSDate *time2 = [fmtTime dateFromString:string2];
        
        return [time1 compare:time2];
    };
    
    
    NSSortDescriptor * sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"check_in_date_time" ascending:YES comparator:compareTimes];
    [arraytoSort sortUsingDescriptors:@[sortDesc2]];
    
    return arraytoSort;
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
