//
//  Thanks_VC.m
//  Snuzo App
//
//  Created by Oneclick IT on 10/28/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import "Thanks_VC.h"
#import "pastbookingcell.h"
#import "Constant.h"
#import "AppDelegate.h"
@interface Thanks_VC ()

@end

@implementation Thanks_VC
@synthesize arrData;


-(void)viewWillDisappear:(BOOL)animated
{
  // [self showTabBar:self.tabBarController];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton=YES;
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"SnapNurse";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self hideTabBar:self.tabBarController];
    
    UIView *navigationRightview =[[UIView alloc] initWithFrame:CGRectMake(122, 0, 198, 44)];
    navigationRightview.backgroundColor=[UIColor clearColor];
    navigationRightview.tag=999;
   
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];

    
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
    
     UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, (viewHeight-64-50)-120)];
    UIImageView *baseImage=[[UIImageView alloc]initWithFrame:CGRectMake(20,0,baseView.frame.size.width-40, baseView.frame.size.height-40)];
    baseImage.image=[UIImage imageNamed:@"base"];
//    [baseView addSubview:baseImage];

    
    UIImageView *imgTick=[[UIImageView alloc]initWithFrame:CGRectMake(35+20+8,20+60-25, 32, 32)];
    if (IS_IPHONE_4) {
        imgTick.frame=CGRectMake(35+20+8,20+60-45, 32, 32);
    }
    else if (IS_IPHONE_6)
    {
         imgTick.frame=CGRectMake(35+20+8+40,20+60-25, 32, 32);
    }
    else if (IS_IPHONE_6plus)
    {
        imgTick.frame=CGRectMake(35+20+8+51,20+60-25+65, 32, 32);
    }

    
    imgTick.image=[UIImage imageNamed:@"tick"];
    [self.view addSubview:imgTick];
    
    UILabel *lblThanks=[[UILabel alloc]initWithFrame:CGRectMake(75+20+8, 20+60-25,self.view.frame.size.width-35, 32)];
    if (IS_IPHONE_4) {
        lblThanks.frame=CGRectMake(75+20+8, 20+60-45,320-25, 32);
    }
    else if (IS_IPHONE_6)
    {
       lblThanks.frame=CGRectMake(75+20+8+40, 20+60-25,self.view.frame.size.width-35, 32);
    }
    else if (IS_IPHONE_6plus)
    {
        lblThanks.frame=CGRectMake(75+20+8+51, 20+60-25+65,self.view.frame.size.width-35, 32);
    }
    lblThanks.textColor=[UIColor colorWithRed:41.0/255.0 green:0.0/255.0 blue:66.0/255.0 alpha:1.0];
    lblThanks.font=[UIFont systemFontOfSize:30.0];
    lblThanks.text=@"Thank you";
    [self.view addSubview:lblThanks];
    
    
    UILabel *lblId=[[UILabel alloc]initWithFrame:CGRectMake(0,60+60-25, self.view.frame.size.width, 32)];
    if (IS_IPHONE_4) {
        lblId=[[UILabel alloc]initWithFrame:CGRectMake(0,60+60-45, 320, 32)];

    }
    else if (IS_IPHONE_6plus)
    {
        lblId.frame =CGRectMake(0,60+60-25+65, self.view.frame.size.width, 32);
    }
    
    lblId.textAlignment=NSTextAlignmentCenter;
    lblId.textColor=[UIColor darkGrayColor];
    lblId.font=[UIFont boldSystemFontOfSize:17];
    
    if (![self.arrData count]==0)
    {
        lblId.text=[NSString stringWithFormat:@"Your booking id #%@",[self.arrData objectForKey:@"confirm_id"]];
    }
    else
    {
        lblId.text=@"Your booking id #432";

    }
    [self.view addSubview:lblId];
//    [self.view addSubview:baseView];
    
    UITableView *tblDetail=[[UITableView alloc]initWithFrame:CGRectMake(40, 100+60-25, self.view.frame.size.width-80 , 180)];
    if (IS_IPHONE_4) {
        tblDetail.frame=CGRectMake(40, 100+60-45, 240 , 150);
    }
    else if (IS_IPHONE_6)
    {
        tblDetail.frame=CGRectMake(40, 100+60-25, self.view.frame.size.width-80 , 180);
    }
    else if (IS_IPHONE_6plus)
    {
        tblDetail.frame=CGRectMake(40, 100+60-25+65, self.view.frame.size.width-80 , 180);
    }
    tblDetail.backgroundColor=[UIColor clearColor];
    tblDetail.dataSource=self;
    tblDetail.delegate=self;
    tblDetail.layer.cornerRadius=8;
    tblDetail.layer.borderColor=globelColor.CGColor;
    tblDetail.layer.borderWidth=1;
    tblDetail.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblDetail];
    

    UILabel *mailLbl=[[UILabel alloc]initWithFrame:CGRectMake(20,258+60-25+60, baseImage.frame.size.width, 32)];
    if (IS_IPHONE_4) {
        mailLbl=[[UILabel alloc]initWithFrame:CGRectMake(20,258+60-45, baseImage.frame.size.width, 32)];

    }
    else if (IS_IPHONE_6plus)
    {
        mailLbl.frame= CGRectMake(20,258+60-25+60+65, baseImage.frame.size.width, 32);
    }
    
    mailLbl.textAlignment=NSTextAlignmentCenter;
    mailLbl.textColor=[UIColor darkGrayColor];
    mailLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:14];
    mailLbl.text=@"Just a second, we're sending the order details to your email.";
    mailLbl.numberOfLines=0;
    [self.view addSubview:mailLbl];

    UIButton * bookinDetailBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    bookinDetailBtn.frame=CGRectMake(10+20, 258+35+60+50, baseImage.frame.size.width-20, 35);
    if (IS_IPHONE_4)
    {
        bookinDetailBtn.frame=CGRectMake(10+20, 258+10+60, baseImage.frame.size.width-20, 35);

    }
    else if (IS_IPHONE_6plus)
    {
        bookinDetailBtn.frame= CGRectMake(10+20, 258+35+60+50+65, baseImage.frame.size.width-20, 35);
    }
    bookinDetailBtn.backgroundColor=globelColor;
    [bookinDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookinDetailBtn setTitle:@"Booking Details" forState:UIControlStateNormal];
    bookinDetailBtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:14];
    [bookinDetailBtn addTarget:self action:@selector(bookingDetails) forControlEvents:UIControlEventTouchUpInside];
    bookinDetailBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:bookinDetailBtn];

    // Do any additional setup after loading the view.
}
-(void)BackBtnClick
{
   // [self showTabBar:self.tabBarController];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)bookingDetails
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self showTabBar:self.tabBarController];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    [self.tabBarController setSelectedIndex:2];
    self.tabBarController.selectedIndex=2;

//    [self.tabBarController setSelectedIndex:[self.tabBarController.viewControllers objectAtIndex:2]];
//    [self.tabBarController setSelectedIndex:[self.tabBarController.viewControllers objectAtIndex:2]];
 
    
    [self.navigationController popToRootViewControllerAnimated:YES];


}


#pragma mark --Tableview Delegate And Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=normal;
    
    cell.textLabel.text=@"Nurse Name:";
    cell.detailTextLabel.text=@"";
    
    UILabel *lineLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,29, tableView.frame.size.width, 1)];
    lineLbl.backgroundColor=globelColor;
    [cell.contentView addSubview:lineLbl];
    
    cell.textLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12];
    cell.detailTextLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12];
    
    if (indexPath.row==0)
    {
         cell.textLabel.text=@"Nurse Name:";
        cell.detailTextLabel.text=[self.arrData objectForKey:@"hotel_name"];
    }
    else if (indexPath.row==1)
    {
        cell.textLabel.text=@"Date:";
        cell.detailTextLabel.text=[self.arrData objectForKey:@"check-in_date"];
    }
    else if(indexPath.row==2)
    {
        NSString *strdate=[self.arrData objectForKey:@"check-in_time"];
        NSArray * startArr = [strdate componentsSeparatedByString:@" "];
        
        NSString *stryear;
        stryear=[startArr objectAtIndex:0];
        
        NSString *strmianTime;
        
        NSString *strTime=[startArr objectAtIndex:1];
        NSString *dats1 = strTime;
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
        [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter3 setDateFormat:@"HH:mm:ss"];
        NSDate *date1 = [dateFormatter3 dateFromString:dats1];
        
        NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
        [formatter4 setDateFormat:@"hh:mm a"];
        
        strmianTime=[formatter4 stringFromDate:date1];
        
        NSString *strtime=strmianTime;
//        cell.lblCheckindate.text=strtime;

        cell.textLabel.text=@"Start Time:";
        cell.detailTextLabel.text=strtime;
    }
    else if (indexPath.row==3)
    {
        
        NSString *strdate=[self.arrData objectForKey:@"check-out_time"];
        NSArray * startArr = [strdate componentsSeparatedByString:@" "];
        
        NSString *stryear;
        stryear=[startArr objectAtIndex:0];
        
        NSString *strmianTime;
        
        NSString *strTime=[startArr objectAtIndex:1];
        NSString *dats1 = strTime;
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
        [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter3 setDateFormat:@"HH:mm:ss"];
        NSDate *date1 = [dateFormatter3 dateFromString:dats1];
        
        NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
        [formatter4 setDateFormat:@"hh:mm a"];
        
        strmianTime=[formatter4 stringFromDate:date1];
        
        NSString *strtime=strmianTime;
        cell.textLabel.text=@"End Time:";
        cell.detailTextLabel.text=strmianTime;
        
        
    }
    else if (indexPath.row==4)
    {
        cell.textLabel.text=@"Duration:";
        if ([[self.arrData objectForKey:@"duration"] isEqualToString:@"1"])
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ hr",[self.arrData objectForKey:@"duration"]];

        }
        else
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ hrs",[self.arrData objectForKey:@"duration"]];

        }

    }
    else if (indexPath.row==5)
    {
        cell.textLabel.text=@"Cost";
        cell.detailTextLabel.text=[self.arrData objectForKey:@"cost"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"$ %@",[self.arrData objectForKey:@"cost"]];
    }

    cell.detailTextLabel.textColor = [UIColor darkGrayColor];

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    cell.backgroundColor=[UIColor clearColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
