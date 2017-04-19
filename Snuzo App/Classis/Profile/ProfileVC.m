//
//  ProfileVC.m
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "ProfileVC.h"
#import "USColor.h"
#import "STPPaymentCardTextField.h"
#import "PaymentViewController.h"
#import "Stripe.h"
@interface ProfileVC ()<STPPaymentCardTextFieldDelegate>
{
    STPPaymentCardTextField *paymentTextField;
    Splash_VC *spl;
}
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation ProfileVC
@synthesize isFromTabbar;

-(void)viewWillAppear:(BOOL)animated
{
    hospitalListArr = [[NSMutableArray alloc] init];
    
    //    hospitalListArr =[[[NSUserDefaults standardUserDefaults] valueForKey:@"hospitalListArr"]mutableCopy];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [def objectForKey:@"hospitalListArr"];
    
    hospitalListArr =
    [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    NSMutableArray * tempArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * tempDict in hospitalListArr)
    {
        NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
        temp = [tempDict mutableCopy];
        
        [tempArr addObject:temp];
    }
    hospitalListArr = tempArr;
    
    serviceCount = 0;
    {
        if(isFromTabbar)
        {
            self.tabBarController.delegate=self;
        }
        self.tabBarController.delegate=self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *yearString = [formatter stringFromDate:[NSDate date]];
        
        int value = [yearString intValue];
        Yearaaray=[[NSMutableArray alloc]init ];
        
        for (int i=value; i<value+100; i++)
        {
            [Yearaaray addObject:[NSNumber numberWithInt:i]];
        }
        
        Montharray=[[NSMutableArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
        [super viewDidLoad];
        if (isFromTabbar)
        {
            [self.navigationItem setHidesBackButton:YES];
        }
        else
        {
            [self.navigationItem setHidesBackButton:YES];
        }
        self.view.backgroundColor=[UIColor whiteColor];
        self.navigationController.navigationBar.backgroundColor=[UIColor grayColor];
        self.navigationItem.title = @"Profile";
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:globelColor}];
        
        
        UIButton *logout=[UIButton buttonWithType:UIButtonTypeCustom];
        logout.frame=CGRectMake(0, 0, 50,30);
        logout.backgroundColor=[UIColor clearColor];
        [logout setTitle:@"Logout" forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [logout setTitleColor:globelColor forState:UIControlStateNormal];
        
        logout.titleLabel.font=[UIFont systemFontOfSize:15.0];
        
        UIBarButtonItem *btnLogout = [[UIBarButtonItem alloc]initWithCustomView:logout];
        btnLogout.tintColor=globelColor;
        
        btnLogout.title=@"Logout";
        
        
        self.navigationItem.rightBarButtonItem = btnLogout;
        
        UIView *Headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        Headerview.backgroundColor=[UIColor whiteColor];
        
        // [self.view addSubview:Headerview];
        
        
        personalinfo=[UIButton buttonWithType:UIButtonTypeCustom];
        personalinfo.frame=CGRectMake(0, 0, self.view.frame.size.width/2, 36);
        [personalinfo setTitle:@"Personal info" forState:UIControlStateNormal];
        [personalinfo addTarget:self action:@selector(headerclick:) forControlEvents:UIControlEventTouchUpInside];
        personalinfo.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16];
        [personalinfo setTitleColor:globelColor forState:UIControlStateNormal];
        personalinfo.tag=0;
        
        [Headerview addSubview:personalinfo];
        
        lblLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 37, self.view.frame.size.width/2, 3)];
        lblLine.backgroundColor=[UIColor whiteColor];
        lblLine.image=[UIImage imageNamed:@"selected-tab"];
        
        [Headerview addSubview:lblLine];
        
        paymentcardinfo=[UIButton buttonWithType:UIButtonTypeCustom];
        paymentcardinfo.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40);
        [paymentcardinfo setTitle:@"Payment card info" forState:UIControlStateNormal];
        [paymentcardinfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        paymentcardinfo.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16];
        
        paymentcardinfo.tag=1;
        [paymentcardinfo addTarget:self action:@selector(headerclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [Headerview addSubview:paymentcardinfo];
        
        [scrlcontent removeFromSuperview];
        scrlcontent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
        scrlcontent.showsHorizontalScrollIndicator = YES;
        scrlcontent.showsVerticalScrollIndicator = YES;
        scrlcontent.pagingEnabled = YES;
        scrlcontent.delegate = self;
        scrlcontent.scrollEnabled=YES;
        [scrlcontent setContentSize:CGSizeMake(self.view.frame.size.width, viewHeight)];
        
        if (IS_IPHONE_4)
        {
            //        [scrlcontent setContentSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height+100)];
        }
        
        [self.view addSubview:scrlcontent];
        
        [self personalInfo];
        // [self createpaymentifo];
        
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"] isEqualToString:@"Facebook"])
        {
            NSMutableDictionary * detailDict =[[NSMutableDictionary alloc] init];
            detailDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"detailArr"] mutableCopy];
            txtfname.text=[detailDict valueForKey:@"user_first_name"];
            txtlname.text=[detailDict valueForKey:@"user_last_name"];
            txtemail.text=[detailDict valueForKey:@"email"];
            
        }
        else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"] isEqualToString:@"Google"])
        {
            NSMutableDictionary * detailDict =[[NSMutableDictionary alloc] init];
            detailDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"detailArr"] mutableCopy];
            
            txtfname.text=[detailDict valueForKey:@"first_name"];
            txtlname.text=[detailDict valueForKey:@"last_name"];
            txtemail.text=[detailDict valueForKey:@"email"];
            txtnewPass.enabled=NO;
            txtconfPass.enabled=NO;
            txtoldPass.enabled=NO;
            
        }
        else if([[NSUserDefaults standardUserDefaults] valueForKey:@"data"] !=nil)
        {
            txtfname.text=[[[NSUserDefaults standardUserDefaults] valueForKey:@"data"] valueForKey:@"first_name"];
            txtlname.text=[[[NSUserDefaults standardUserDefaults] valueForKey:@"data"] valueForKey:@"last_name"];
            txtemail.text=[[[NSUserDefaults standardUserDefaults] valueForKey:@"data"] valueForKey:@"email"];
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

- (void)viewDidLoad
{
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
}

#pragma mark --- Touch

#pragma mark Touch event
-(void)touch
{
     NSLog(@"text");
    
    tblMonth.hidden=YES;
//    tblYear.hidden=YES;
    [txtfname resignFirstResponder];
    [txtlname resignFirstResponder];
    [txtphNo resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtoldPass resignFirstResponder];
    [txtnewPass resignFirstResponder];
    [txtnewPass resignFirstResponder];
    [txtcardNo resignFirstResponder];
    [txtnameoncard resignFirstResponder];
    [txtconfPass resignFirstResponder];

}

#pragma mark --- LogoutClick

-(void)logout
{
    URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"sign up" message:@"Are you sure you want to logout" cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
    [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
    alert.tag=0;
    [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
     {
         [alertView hideWithCompletionBlock:^{
             
             if(buttonIndex==0)
             {
                 serviceCount = serviceCount +1;
                 NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                 NSString *customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
                 [dict setValue:customerId forKey:@"login_user_id"];
                 URLManager *manager = [[URLManager alloc] init];
                 manager.commandName = @"Clearcart";
                 manager.delegate = self;
                 [manager urlCall:@"http://snapnurse.com/webservice/clearAllCartDetails" withParameters:dict];
             }
             else
             {
                 
             }
         }];
     }];
     [alert showWithAnimation:URBalertAnimationType];;
}


#pragma mark - Personal Info View;
-(void)personalInfo
{
    [personalView removeFromSuperview];
    personalView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,scrlcontent.frame.size.height+200)];
    personalView.backgroundColor=[UIColor clearColor];

    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [personalView addGestureRecognizer:recognizer];
//    [personalView addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchDown];
    
    int y=20;
    
    UIImageView *nameview=[[UIImageView alloc]initWithFrame:CGRectMake(12,y, (self.view.frame.size.width/2)-24, 30)];
    nameview.image=[UIImage imageNamed:@"text-field"];
    nameview.userInteractionEnabled = YES;
    [personalView addSubview:nameview];
    
    
    txtfname=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, nameview.frame.size.height)];
    
    UIColor *color = [UIColor lightGrayColor];
    txtfname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    txtfname.textAlignment=NSTextAlignmentLeft;
    txtfname.delegate=self;
    
    [nameview addSubview:txtfname];
    
    
    UIImageView *lnameview=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)+12,y, (self.view.frame.size.width/2)-24, 30)];
    lnameview.image=[UIImage imageNamed:@"text-field"];
    lnameview.userInteractionEnabled = YES;
    
    txtlname=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, nameview.frame.size.height)];
    txtlname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    txtlname.textAlignment=NSTextAlignmentLeft;
    txtlname.delegate=self;
    
    [lnameview addSubview:txtlname];
    
    [personalView addSubview:lnameview];
    
    
    y= y+45;
    
    
    
    UIImageView *phoneview=[[UIImageView alloc]initWithFrame:CGRectMake(12,y, (self.view.frame.size.width)-24, 30)];
    phoneview.image=[UIImage imageNamed:@"text-field"];
    phoneview.userInteractionEnabled = YES;
    
    txtphNo=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, phoneview.frame.size.width-10, phoneview.frame.size.height)];
    txtphNo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone" attributes:@{NSForegroundColorAttributeName: color}];
    txtphNo.textAlignment=NSTextAlignmentLeft;
    txtphNo.delegate=self;
    
    
    if ([[[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"contact"]isEqualToString:@""]||[[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"contact"]==nil) {
        
    }
    else
    {
        txtphNo.text=[[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"contact"];
        
    }
    
    [phoneview addSubview:txtphNo];
    [personalView addSubview:phoneview];
    
    
    
    
    y= y+45;
    
    
    UIImageView *emailview=[[UIImageView alloc]initWithFrame:CGRectMake(12,y, (self.view.frame.size.width)-24, 30)];
    emailview.image=[UIImage imageNamed:@"text-field"];
    emailview.userInteractionEnabled = YES;
    
    txtemail=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, emailview.frame.size.width-10, emailview.frame.size.height)];
    txtemail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    txtemail.textAlignment=NSTextAlignmentLeft;
    txtemail.delegate=self;
    
    [emailview addSubview:txtemail];
    [personalView addSubview:emailview];
    
    y= y+45;
    
    UILabel *lblHospitalName=[[UILabel alloc]initWithFrame:CGRectMake(07, y, self.view.frame.size.width-14, 20)];
    lblHospitalName.font=[UIFont systemFontOfSize:14.0];
    lblHospitalName.textAlignment=NSTextAlignmentLeft;
    lblHospitalName.textColor=[UIColor blackColor];
    lblHospitalName.text=@"Hospital Name";
    [personalView addSubview:lblHospitalName];
    
    y= y+20;
    
    hospitalListTbl =[[UITableView alloc] init];
    hospitalListTbl.frame = CGRectMake(10,y, (self.view.frame.size.width)-20, 100);
    hospitalListTbl.backgroundColor =[UIColor clearColor];
    hospitalListTbl.dataSource = self;
    hospitalListTbl.delegate = self;
    hospitalListTbl.showsHorizontalScrollIndicator = YES;
    hospitalListTbl.showsVerticalScrollIndicator = YES;
    hospitalListTbl.layer.cornerRadius = 3;
    hospitalListTbl.layer.borderColor = globelColor.CGColor;
    hospitalListTbl.layer.borderWidth = 1;
    [personalView addSubview:hospitalListTbl];
    
    y= y+105;
    
    UILabel *lblChangepass=[[UILabel alloc]initWithFrame:CGRectMake(07, y, self.view.frame.size.width-14, 20)];
    lblChangepass.font=[UIFont systemFontOfSize:14.0];
    lblChangepass.textAlignment=NSTextAlignmentLeft;
    
    lblChangepass.textColor=[UIColor blackColor];
    lblChangepass.text=@"Change Password";

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"] isEqualToString:@"Normal"])
    {
        [personalView addSubview:lblChangepass];

    }
    else
    {
        
    }
    
    y= y+30;
    
    
    UIImageView *oldpassview=[[UIImageView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 30)];
    oldpassview.image=[UIImage imageNamed:@"text-field"];
    oldpassview.userInteractionEnabled = YES;
    
    txtoldPass=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, oldpassview.frame.size.width-10, oldpassview.frame.size.height)];
    txtoldPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Old password" attributes:@{NSForegroundColorAttributeName: color}];
    txtoldPass.textAlignment=NSTextAlignmentLeft;
    txtoldPass.delegate=self;
    [txtoldPass setSecureTextEntry:YES];
    [oldpassview addSubview:txtoldPass];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"] isEqualToString:@"Normal"]){
       
        [personalView addSubview:oldpassview];
    }
    else
    {
        y= y-30;
    }
    y= y+45;
    
    UIImageView *newpassview=[[UIImageView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 30)];
    newpassview.image=[UIImage imageNamed:@"text-field"];
    newpassview.userInteractionEnabled = YES;
    
    txtnewPass=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, newpassview.frame.size.width-10, newpassview.frame.size.height)];
    txtnewPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
    txtnewPass.textAlignment=NSTextAlignmentLeft;
    txtnewPass.delegate=self;
    [txtnewPass setSecureTextEntry:YES];
    [newpassview addSubview:txtnewPass];
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"] isEqualToString:@"Normal"]){
        
        [personalView addSubview:newpassview];
    }
    else
    {
        y= y-45;
    }
    
    y= y+45;
    
    UIImageView *Confpassview=[[UIImageView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 30)];
    Confpassview.image=[UIImage imageNamed:@"text-field"];
     Confpassview.userInteractionEnabled = YES;
    
    txtconfPass=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, Confpassview.frame.size.width-10, nameview.frame.size.height)];
    txtconfPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
    txtconfPass.delegate=self;
    [txtconfPass setSecureTextEntry:YES];
    
    txtconfPass.textAlignment=NSTextAlignmentLeft;
    
    [Confpassview addSubview:txtconfPass];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"] isEqualToString:@"Normal"]){
        
        [personalView addSubview:Confpassview];
    }
    else
    {
        y= y-45;
    }
    
    
    y=y+60;
    
    UIButton *savebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    savebtn.frame=CGRectMake(30, y, self.view.frame.size.width-60, 35);
    [savebtn setTitle:@"Save" forState:UIControlStateNormal];
    savebtn.backgroundColor=globelColor;
    savebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
    [savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [personalView addSubview:savebtn];
    savebtn.layer.cornerRadius=5.0;

    txtfname.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    txtlname.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    txtemail.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    txtnewPass.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    txtconfPass.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    txtphNo.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    txtoldPass.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    lblChangepass.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    lblHospitalName.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];

    scrlPersonal =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, personalView.frame.size.height)];
    scrlPersonal.backgroundColor=[UIColor clearColor];
    [scrlPersonal setContentSize:CGSizeMake(self.view.frame.size.width, personalView.frame.size.height+100)];
    if (IS_IPHONE_4)
    {
         [scrlPersonal setContentSize:CGSizeMake(self.view.frame.size.width, personalView.frame.size.height+200)];
    }
        scrlPersonal.scrollEnabled=YES;
        [scrlcontent addSubview:scrlPersonal];
        [scrlPersonal addSubview:personalView];
        [savebtn bringSubviewToFront:scrlPersonal];
        //[scrlcontent addSubview:personalView];
    
    
    
}
-(void)createpaymentifo
{
    paymentview=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,scrlcontent.frame.size.height)];
    paymentview.backgroundColor=[UIColor clearColor];

    [scrlcontent addSubview:paymentview];
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    cardview=[[UIView alloc]initWithFrame:CGRectMake(0,05,paymentview.frame.size.width, paymentview.frame.size.height)];
    cardview.backgroundColor=[UIColor clearColor];
    [paymentview addSubview:cardview];
    
    paymentTextField = [[STPPaymentCardTextField alloc] init];
    paymentTextField.frame=CGRectMake(10, 50, self.view.frame.size.width-20, 35);
    paymentTextField.textColor=[UIColor blackColor];
    paymentTextField.delegate = self;
    self.paymentTextField = paymentTextField;
    [cardview addSubview:paymentTextField];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    doneButton.tintColor=[UIColor whiteColor];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    paymentTextField.inputAccessoryView = keyboardDoneButtonView;
    
    
    paymentsavebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    paymentsavebtn.frame=CGRectMake(25, 110, self.view.frame.size.width-50, 40);
    [paymentsavebtn setTitle:@"Save" forState:UIControlStateNormal];
    paymentsavebtn.backgroundColor=globelColor;
    paymentsavebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
    paymentsavebtn.layer.cornerRadius=1.0;
    
    [paymentsavebtn addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    
    [paymentsavebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paymentsavebtn.layer.cornerRadius=5.0;
    
    paymentsavebtn.enabled=YES;
    
    [cardview  addSubview:paymentsavebtn];
    
    
    cardview.hidden=YES;
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"card.last4"]==nil||[[[NSUserDefaults standardUserDefaults]valueForKey:@"card.last4"] isEqualToString:@""])
    {
        cardview.hidden=NO;
        lblcardDetail=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.frame.size.width-10, 20)];
        lblcardDetail.text=@"Enter Card Detail:--";
        lblcardDetail.textColor=[UIColor blackColor];
        lblcardDetail.textAlignment=NSTextAlignmentLeft;
        
        [cardview addSubview:lblcardDetail];
        
        
    }
    else
    {
        
        tblYear.delegate=nil;
        [tblYear removeFromSuperview];
        tblYear=nil;
        
        
        tblYear=[[UITableView alloc]initWithFrame:CGRectMake(0,05,paymentview.frame.size.width, paymentview.frame.size.height)];
        tblYear.backgroundColor=[UIColor clearColor];
        tblYear.delegate=self;
        tblYear.dataSource=self;
        tblYear.separatorStyle=normal;
        tblYear.separatorColor=[UIColor clearColor];
        [paymentview addSubview:tblYear];
    }
    
  
    
    
    
    
    /*
   

    
    
    */
    
    
    
    
    
    
//    int y=20;
//    UIView *nameview=[[UIView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 35)];
//    nameview.backgroundColor=[UIColor whiteColor];
//    [paymentview addSubview:nameview];
//    
//    
//    txtnameoncard=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, nameview.frame.size.height)];
//    
//    
//    UIColor *color = [UIColor lightGrayColor];
//    txtnameoncard.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"full name on card" attributes:@{NSForegroundColorAttributeName: color}];
//    txtnameoncard.textAlignment=NSTextAlignmentLeft;
//    txtnameoncard.delegate=self;
//    
//    [nameview addSubview:txtnameoncard];
//    
//    txtnameoncard.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
//    nameview.layer.cornerRadius=1.0;
//    txtnameoncard.layer.cornerRadius=1.0;
//
//    //txtcardNo
//    
//    y= y+50;
//    
//    
//    UIView *cardnoview=[[UIView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 35)];
//    cardnoview.backgroundColor=[UIColor whiteColor];
//    
//    
//    
//    
//    
//    txtcardNo=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, nameview.frame.size.height)];
//    txtcardNo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Card Number" attributes:@{NSForegroundColorAttributeName: color}];
//    txtcardNo.textAlignment=NSTextAlignmentLeft;
//    txtcardNo.delegate=self;
//    
//    [cardnoview addSubview:txtcardNo];
//    
//    [paymentview addSubview:cardnoview];
//    
//    txtcardNo.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
//    cardnoview.layer.cornerRadius=1.0;
//    txtcardNo.layer.cornerRadius=1.0;
//    
//    
//    
//    
//    y= y+50;
//    
//    
//    UILabel *lblExpirationdate=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25)];
//    lblExpirationdate.textColor=[UIColor grayColor];
//    lblExpirationdate.text=@"Expiration date";
//    [paymentview addSubview:lblExpirationdate];
//    lblExpirationdate.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
//
//    
//    
//    
//    y= y+33;
//    
//    UIView *monthview=[[UIView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width/2)-20, 35)];
//    monthview.backgroundColor=[UIColor whiteColor];
//    [paymentview addSubview:monthview];
//    
//    UIImageView * arrImg =[[UIImageView alloc] init];
//    arrImg.frame=CGRectMake(115, 13, 14, 9);
//    arrImg.image=[UIImage imageNamed:@"down-arrow"];
//    [monthview addSubview:arrImg];
//    
//    monthBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    monthBtn.frame=CGRectMake(0, 0, 110, 35);
//    [monthBtn setTitle:@"August" forState:UIControlStateNormal];
//    [monthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    monthBtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
//    [monthBtn addTarget:self action:@selector(monthbtnclick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [monthview addSubview:monthBtn];
//    
//    
//    
//    
//    tblMonth=[[UITableView alloc]initWithFrame:CGRectMake(monthview.frame.origin.x, monthview.frame.origin.y+monthview.frame.size.height+43, monthview.frame.size.width, 150)];
//    tblMonth.backgroundColor=[UIColor whiteColor];
//    tblMonth.delegate=self;
//    tblMonth.dataSource=self;
//    tblMonth.hidden=YES;
//    
//    
//    
//    UIView *yearview=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)+10,y, (self.view.frame.size.width/2)-20, 35)];
//    yearview.backgroundColor=[UIColor whiteColor];
//    
//    UIImageView * arrImg1 =[[UIImageView alloc] init];
//    arrImg1.frame=CGRectMake(115, 13, 14, 9);
//    arrImg1.image=[UIImage imageNamed:@"down-arrow"];
//    [yearview addSubview:arrImg1];
//    
//    
//    monthview.layer.cornerRadius=1.0;
//    yearview.layer.cornerRadius=1.0;
//
//    
//    yearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    yearBtn.frame=CGRectMake(0, 0, 110, 35);
//    [yearBtn setTitle:@"2020" forState:UIControlStateNormal];
//    [yearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    yearBtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
//    [yearBtn addTarget:self action:@selector(yearbtnclick) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [yearview addSubview:yearBtn];
//    
//    
//    
//    
//    [paymentview addSubview:yearview];
//    
//    tblYear=[[UITableView alloc]initWithFrame:CGRectMake(yearview.frame.origin.x, yearview.frame.origin.y+yearview.frame.size.height+43, yearview.frame.size.width, 150)];
//    tblYear.backgroundColor=[UIColor whiteColor];
//    tblYear.delegate=self;
//    tblYear.dataSource=self;
//    tblYear.hidden=YES;
//    
//    
//    
//    
//    
//    
//    
//     y=y+70;
//     
//     paymentsavebtn=[UIButton buttonWithType:UIButtonTypeCustom];
//     paymentsavebtn.frame=CGRectMake(25, y, self.view.frame.size.width-50, 40);
//     [paymentsavebtn setTitle:@"save changes" forState:UIControlStateNormal];
//     paymentsavebtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"footer"]];
//    paymentsavebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
//    paymentsavebtn.layer.cornerRadius=1.0;
//
//    [paymentsavebtn addTarget:self action:@selector(paymentSaveClick) forControlEvents:UIControlEventTouchUpInside];
//    
//     [paymentsavebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//     [paymentview addSubview:paymentsavebtn];
//    paymentsavebtn.layer.cornerRadius=1.0;
////    [paymentview addSubview:tblMonth];
//    
//    [self.view addSubview:tblYear];
//
//    [self.view addSubview:tblMonth];
//    
//    /*
//     "
//     
//     expireYear
//     expireMonth"
//     */
//    NSString *strnameOncard=[[NSUserDefaults standardUserDefaults]valueForKey:@"nameoncard"];
//    NSString *cardno=[[NSUserDefaults standardUserDefaults]valueForKey:@"cardno"];
//    NSString *expireYear=[[NSUserDefaults standardUserDefaults]valueForKey:@"expireYear"];
//    NSString *expireMonth=[[NSUserDefaults standardUserDefaults]valueForKey:@"expireMonth"];
//
//    
//    if ([strnameOncard length]==0||[strnameOncard isEqual:[NSNull null]]||strnameOncard==nil)
//    {
//        
//    }
//    else
//    {
//        txtnameoncard.text=strnameOncard;
//        
//    }
//    
//    if ([cardno length]==0||[cardno isEqual:[NSNull null]]||cardno==nil)
//    {
//    }
//    else
//    {
//        txtcardNo.text=cardno;
//        
//    }
//
//    
//    if ([expireYear length]==0||[expireYear isEqual:[NSNull null]]||expireYear==nil)
//    {
//    }
//    else
//    {
//        [yearBtn setTitle:expireYear forState:UIControlStateNormal];
//        
//        
//    }
//
//
//    if ([expireMonth length]==0||[expireMonth isEqual:[NSNull null]]||expireMonth==nil)
//    {
//    }
//    else
//    {
//        [monthBtn setTitle:expireMonth forState:UIControlStateNormal];
//        
//        
//    }
   
    
    

}

#pragma mark --Year Buuton Click;
-(void)yearbtnclick
{
    
    [txtcardNo resignFirstResponder];
    [txtnameoncard resignFirstResponder];
    
    
    if (Ismonthclick)
    {
        tblMonth.hidden=YES;
        Ismonthclick=NO;
        
        if (IsyearClcik) {
//            tblYear.hidden=YES;
            IsyearClcik=NO;
            
        }
        else
        {
            tblYear.hidden=NO;
            IsyearClcik=YES;
            
            [scrlcontent bringSubviewToFront:tblYear];
        }

    }
    else
    {
        if (IsyearClcik) {
//        tblYear.hidden=YES;
        IsyearClcik=NO;
        
        }
        else
        {
            tblYear.hidden=NO;
            IsyearClcik=YES;
        
            [scrlcontent bringSubviewToFront:tblYear];
        }
    }
   
    
     NSLog(@"click");
    
}
-(void)monthbtnclick
{
    
    [txtcardNo resignFirstResponder];
    [txtnameoncard resignFirstResponder];

    
    
    if (IsyearClcik) {
        
//        tblYear.hidden=YES;
        IsyearClcik=NO;

        if (Ismonthclick) {
            tblMonth.hidden=YES;
            Ismonthclick=NO;
            
        }
        else
        {
            tblMonth.hidden=NO;
            Ismonthclick=YES;
            
            [scrlcontent bringSubviewToFront:tblMonth];
        }

    }
    else
    {
        if (Ismonthclick) {
            tblMonth.hidden=YES;
            Ismonthclick=NO;
        
        }
        else
        {
            tblMonth.hidden=NO;
            Ismonthclick=YES;
        
            [scrlcontent bringSubviewToFront:tblMonth];
        }
    }

}




#pragma mark SaveClick
-(void)paymentSaveClick
{
    
    if ([txtnameoncard.text length]==0) {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter Name." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
         [alert showWithAnimation:URBalertAnimationType];;

    }
    else if([txtcardNo.text length]==0)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter Card No." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
         [alert showWithAnimation:URBalertAnimationType];;
    }
    else
    {
    
         NSLog(@"saveClcik:");
        
        [[NSUserDefaults standardUserDefaults]setValue:txtnameoncard.text forKey:@"nameoncard"];
        [[NSUserDefaults standardUserDefaults]setValue:txtcardNo.text forKey:@"cardno"];
        [[NSUserDefaults standardUserDefaults]setValue:yearBtn.titleLabel.text forKey:@"expireYear"];
        [[NSUserDefaults standardUserDefaults]setValue:monthBtn.titleLabel.text forKey:@"expireMonth"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Information has been saved successfully." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
        
    }
    
}


#pragma mark textfield delgates
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
//    tblYear.hidden=YES;
    tblMonth.hidden=YES;
    IsyearClcik=NO;
    Ismonthclick=NO;
    
    
    if (textField==txtoldPass)
    {
        [scrlPersonal setContentOffset:CGPointMake(0, 90)animated:YES];
        
    }
    else if(textField==txtnewPass)
    {
        [scrlcontent setContentOffset:CGPointMake(0, 70)animated:YES];

    }
    else if (textField==txtconfPass)
    {
        [scrlcontent setContentOffset:CGPointMake(0, 110)animated:YES];
 
    }
    scrlcontent.scrollEnabled=NO;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if (textField==txtnameoncard)
    {
        [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0)animated:YES];
    }
    else  if (textField==txtcardNo)
    {
        [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0)animated:YES];
    }
    else
    {
        [scrlcontent setContentOffset:CGPointMake(0, 0)animated:YES];
    }
    
    scrlcontent.scrollEnabled=YES;

}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==txtoldPass)
    {
        [txtnewPass becomeFirstResponder];
        
    }
    else if (textField==txtnewPass)
    {
        [txtconfPass becomeFirstResponder];
        
    }
    else if(textField==txtnameoncard)
    {
        [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0)animated:YES];
        [txtcardNo becomeFirstResponder];

    }
    else  if (textField==txtcardNo)
    {
        [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0)animated:YES];
        [textField resignFirstResponder];
        scrlcontent.scrollEnabled=YES;
    }
    else
    {
        [textField resignFirstResponder];
        scrlcontent.scrollEnabled=YES;
        [scrlcontent setContentOffset:CGPointMake(0, 0)animated:YES];

    }

    return YES;
}

#pragma mark Header Buttton CLick

-(void)headerclick:(id)sender
{
    
    
    [txtfname resignFirstResponder];
    [txtlname resignFirstResponder ];
    [txtemail resignFirstResponder];
    [txtphNo resignFirstResponder];
    [txtnewPass resignFirstResponder];
    [txtoldPass resignFirstResponder];
    [txtconfPass resignFirstResponder];
    UIButton *button = (UIButton *)sender;
     NSLog(@"%ld",(long)button.tag);
    if(button.tag==1)
    {
        
        [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
        [UIView commitAnimations];
        
        [UIView animateWithDuration:.5 animations:^{
            lblLine.frame=CGRectMake( 0, 37, self.view.frame.size.width/2, 3);
        } completion:^(BOOL finished) {
        }];
        
        [scrlcontent setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


#pragma mark-- tableview delegates



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    if(tableView==tblYear)
    {
        return 2;
    }
    else if (tableView == hospitalListTbl)
    {
        return [hospitalListArr count];
    }
    else
    {
        return [Montharray count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == hospitalListTbl)
    {
        return 30;
    }
    else
    {
       return 40;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=normal;
    NSString *stringForCell;
    cell.textLabel.textAlignment=NSTextAlignmentNatural;
    if (tableView==tblYear) {
        
        
        if(indexPath.row==0)
        {
            cell.textLabel.textColor=[UIColor blackColor];
            cell.backgroundColor=[UIColor clearColor];
            cell.textLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
            stringForCell= @"     Card Details : ";
            cell.textLabel.textAlignment=NSTextAlignmentLeft;
          
            [cell.textLabel setText:stringForCell];
        }
//        stringForCell=@"test";
        else
        {
            UIView * CardDetailView = [[UIView alloc] init];
            CardDetailView.frame=CGRectMake(30, 0, tableView.frame.size.width-60, 35);
            [[CardDetailView layer] setBorderWidth:1.0f];
            CardDetailView.layer.cornerRadius=5.0;
            [[CardDetailView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.contentView addSubview:CardDetailView];
            
            
            UILabel *lbltext=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, CardDetailView.frame.size.width-60, 35)];
            lbltext.font=[UIFont boldSystemFontOfSize:20.0];
            lbltext.textColor=[UIColor blackColor];
            lbltext.textAlignment=NSTextAlignmentLeft;
            [CardDetailView addSubview:lbltext];
            
           UIImageView* imgcard=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 32, 20)];
            NSString *imageName;
            [CardDetailView addSubview:imgcard];
            
            NSString *strbarnd=[[[NSUserDefaults standardUserDefaults]valueForKey:@"cardInfo"]valueForKey:@"cardBrand"];
            int brand=[strbarnd intValue];
            BOOL templateSupported = [[UIImage new] respondsToSelector:@selector(imageWithRenderingMode:)];

            switch (brand) {
                case STPCardBrandAmex:
                    imageName = @"stp_card_amex";
                    break;
                case STPCardBrandDinersClub:
                    imageName = @"stp_card_diners";
                    break;
                case STPCardBrandDiscover:
                    imageName = @"stp_card_discover";
                    break;
                case STPCardBrandJCB:
                    imageName = @"stp_card_jcb";
                    break;
                case STPCardBrandMasterCard:
                    imageName = @"stp_card_mastercard";
                    break;
                case STPCardBrandUnknown:
                    imageName = templateSupported ? @"stp_card_placeholder_template" : @"stp_card_placeholder";
                    break;
                case STPCardBrandVisa:
                    imageName = @"stp_card_visa";
            }
            
            imgcard.image=[UIImage imageNamed:imageName];
            
            cell.backgroundColor=[UIColor clearColor];
            
            lbltext.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];

            stringForCell= [NSString stringWithFormat:@" ****-****-****-%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"card.last4"]];
            cell.textLabel.textAlignment=NSTextAlignmentLeft;
            lbltext.text = stringForCell;

        }
        
    }
    else if (tableView == hospitalListTbl)
    {
        cell.textLabel.textColor=[UIColor blackColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
        stringForCell= [NSString stringWithFormat:@"%@",[[[hospitalListArr objectAtIndex:indexPath.row] valueForKey:@"data"] valueForKey:@"first_name"]];
        
        [cell.textLabel setText:stringForCell];
    }
    else
    {
        stringForCell= [NSString stringWithFormat:@"%@",[Montharray objectAtIndex:indexPath.row]];

       [cell.textLabel setText:stringForCell];
    }
    return cell;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *str=[NSString stringWithFormat:@"%@",cell.textLabel.text];
    
    if (tableView==tblYear) {

        if (indexPath.row==0)
        {
        }
        else
        {
        
            tblYear.hidden=YES;
            personalinfo.enabled=NO;
            paymentcardinfo.enabled=NO;
            scrlcontent.scrollEnabled=NO;
        
            cardview.frame = CGRectMake(0,paymentview.frame.size.height,paymentview.frame.size.width, paymentview.frame.size.height);
            cardview.hidden=NO;

            [UIView animateWithDuration:0.1
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                cardview.frame = CGRectMake(0,05,paymentview.frame.size.width, paymentview.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
            
        
            paymentsavebtn.frame=CGRectMake(30, 110,120,30);
       
            paymentClosebtn=[UIButton buttonWithType:UIButtonTypeCustom];
            paymentClosebtn.frame=CGRectMake(self.view.frame.size.width-150, 110,120, 30);
            [paymentClosebtn setTitle:@"Cancel" forState:UIControlStateNormal];
            paymentClosebtn.backgroundColor=globelColor;
            paymentClosebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
            paymentClosebtn.layer.cornerRadius=1.0;
        
            [paymentClosebtn addTarget:self action:@selector(closeClick)forControlEvents:UIControlEventTouchUpInside];
        
            [paymentClosebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            paymentClosebtn.layer.cornerRadius=5.0;
        
        
            [cardview  addSubview:paymentClosebtn];
            
            [paymentTextField removeFromSuperview];
            
            paymentTextField.delegate=nil;
            paymentTextField=nil;
            
            paymentTextField = [[STPPaymentCardTextField alloc] init];
            paymentTextField.frame=CGRectMake(20, 50, self.view.frame.size.width-40, 35);
            paymentTextField.textColor=[UIColor blackColor];
            
            paymentTextField.delegate = self;
            self.paymentTextField = paymentTextField;
            [cardview addSubview:paymentTextField];
            
            UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
            [keyboardDoneButtonView sizeToFit];
            keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
            
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                           style:UIBarButtonItemStyleBordered target:self
                                                                          action:@selector(doneClicked:)];
            doneButton.tintColor=[UIColor whiteColor];
            UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            
            [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
            paymentTextField.inputAccessoryView = keyboardDoneButtonView;

            [lblcardDetail removeFromSuperview];
            lblcardDetail=nil;
            
            lblcardDetail=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.frame.size.width-10, 20)];
            lblcardDetail.text=@"Enter Card Detail ";
            lblcardDetail.textColor=[UIColor blackColor];
            lblcardDetail.textAlignment=NSTextAlignmentLeft;
            [cardview addSubview:lblcardDetail];
        }
        
    }
    else if (tableView == hospitalListTbl)
    {
        
    }
    else
    {
        tblMonth.hidden=YES;
        Ismonthclick=NO;
        [monthBtn setTitle:str forState:UIControlStateNormal];
    }
    
}
#pragma mark Scroll View Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [paymentview endEditing:YES];
    
    if (scrollView == scrlcontent)
    {
        tblMonth.hidden=YES;
//        tblYear.hidden=YES;
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page==1)
        {
            [personalinfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [paymentcardinfo setTitleColor:globelColor forState:UIControlStateNormal];
            
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
            [UIView commitAnimations];
            
            [UIView animateWithDuration:.5 animations:^{
                lblLine.frame=CGRectMake( self.view.frame.size.width/2, 37, self.view.frame.size.width/2, 3);
            } completion:^(BOOL finished) {
            }];

        }
        else
        {
            
            [personalinfo setTitleColor:globelColor forState:UIControlStateNormal];
            [paymentcardinfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
            [UIView commitAnimations];
            
            [UIView animateWithDuration:.5 animations:^{
                lblLine.frame=CGRectMake( 0, 37, self.view.frame.size.width/2, 3);
            } completion:^(BOOL finished) {
            }];

        }
        
    }
    else if (scrollView == hospitalListTbl)
    {
        
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == scrlcontent)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//         NSLog(@"page==%d",page);
        
        if (page == 0)
        {
            
            [personalinfo setTitleColor:globelColor forState:UIControlStateNormal];
            [paymentcardinfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
//            [UIView commitAnimations];
//            
//            [UIView animateWithDuration:.5 animations:^{
//                lblLine.frame=CGRectMake( 0, 37, self.view.frame.size.width/2, 3);
//            } completion:^(BOOL finished) {
//            }];
//            
//            [scrlcontent setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
        else if (page == 1)
        {
            
            [personalinfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [paymentcardinfo setTitleColor:globelColor forState:UIControlStateNormal];
        
//            
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lblLine cache:YES];
//            [UIView commitAnimations];
//            
//            [UIView animateWithDuration:.5 animations:^{
//                lblLine.frame=CGRectMake( self.view.frame.size.width/2, 37, self.view.frame.size.width/2, 3);
//            } completion:^(BOOL finished) {
//            }];
//            
//            [scrlcontent setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        }
        else if (page == 2)
        {
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveBtnClick
{
    
    if ([txtfname.text isEqualToString:@""]||txtfname.text.length==0)
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Please enter fristname." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;

    }
    else if ([txtlname.text isEqualToString:@""]||txtlname.text.length==0)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Please enter lastname." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
        
    }
    /*else if([txtphNo.text isEqualToString:@""]||txtphNo.text.length==0)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Please enter phone number." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
    }*/
    else
    {
    
        if (![txtoldPass.text isEqualToString:@""])
        {
            if ([self isPasswordValid:txtoldPass.text]==NO)
            {
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:@"Please ensure that you have at least one lower case letter, one upper case letter, one digit, one special character and at least six digit length" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                 [alert showWithAnimation:URBalertAnimationType];;
                
            }
            else if([txtnewPass.text isEqualToString:@""])
            {
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Please enter new password." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                 [alert showWithAnimation:URBalertAnimationType];;
            }
            else if ([txtconfPass.text isEqualToString:@""])
            {
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Please enter confirm password." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                 [alert showWithAnimation:URBalertAnimationType];;
            }
            else if(![txtnewPass.text isEqualToString:txtconfPass.text])
            {
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Password doesn’t match." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                 [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                NSString *customerId;
                customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
                [dict setObject:txtfname.text forKey:@"first_name"];
                [dict setObject:txtlname.text forKey:@"last_name"];
                [dict setObject:txtemail.text forKey:@"email"];
                [dict setObject:txtphNo.text forKey:@"contact"];
                [dict setObject:txtnewPass.text forKey:@"new_password"];
                [dict setObject:txtoldPass.text forKey:@"old_password"];
                NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
                if (deviceToken ==nil)
                {
                    [dict setValue:@"123" forKey:@"token"];
                }
                else
                {
                    [dict setValue:deviceToken forKey:@"token"];
                }
                NSString *strregistervia;
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"]==nil) {
                    strregistervia=@"Normal";
                }
                else
                {
                    strregistervia=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"];
                }
                [dict setObject:strregistervia forKey:@"register_via"];
                [dict setObject:@"male" forKey:@"gender"];
                [dict setObject:@"ios" forKey:@"device_type"];
                [dict setObject:customerId forKey:@"user_id"];
                
                serviceCount = serviceCount +1;
                 NSLog(@"dict %@",dict);
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"Editprofile";
                manager.delegate = self;
                [manager urlCall:@"http://snapnurse.com/webservice/editProfile" withParameters:dict];
            }
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            NSString *customerId;
            customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
            [dict setObject:txtfname.text forKey:@"first_name"];
            [dict setObject:txtlname.text forKey:@"last_name"];
            [dict setObject:txtemail.text forKey:@"email"];
            [dict setObject:txtphNo.text forKey:@"contact"];
            NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
            if (deviceToken ==nil)
            {
                [dict setValue:@"123" forKey:@"token"];
            }
            else
            {
                [dict setValue:deviceToken forKey:@"token"];
            }
            NSString *strregistervia;
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"]==nil) {
                strregistervia=@"Normal";
            }
            else
            {
                strregistervia=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginvia"];
            }
            [dict setObject:strregistervia forKey:@"register_via"];
            [dict setObject:@"male" forKey:@"gender"];
            [dict setObject:@"ios" forKey:@"device_type"];
            [dict setObject:customerId forKey:@"user_id"];
            
            serviceCount = serviceCount +1;
             NSLog(@"dict %@",dict);
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"Editprofile";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/editProfile" withParameters:dict];
            
        }
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









#pragma mark Email validation



-(BOOL)validateEmail:(NSString*)email
{
    
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) ){
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return FALSE;
        }
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return FALSE;
        }
        return TRUE;
    }
    else
    {// no '@' or '.' present
        return FALSE;
    }
}

#pragma mark Password Check
-(BOOL) isPasswordValid:(NSString *)pwd
{
    
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ( [pwd length]<6 || [pwd length]>20 )
        return NO;  // too long or too short
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )
        return NO;  // no number;
    rang = [pwd rangeOfCharacterFromSet:upperCaseChars];
    if ( !rang.length )
        return NO;  // no uppercase letter;
    rang = [pwd rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )
        return NO;  // no lowerCase Chars;
    return YES;
}

#pragma mark Url menager Delegates

- (void)onResult:(NSDictionary *)result
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    serviceCount = 0;
     NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"Editprofile"])
    {
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            
            [dict setValue:txtfname.text forKey:@"first_name"];
            [dict setValue:txtlname.text forKey:@"last_name"];
            [dict setValue:txtemail.text forKey:@"email"];
            [dict setValue:txtphNo.text forKey:@"contact"];
            [dict setValue:[[[result valueForKey:@"result"]valueForKey:@"data"]valueForKey:@"user_id"]forKey:@"customer_id"];
            
            [dict setValue:[[[result valueForKey:@"result"]valueForKey:@"data"]valueForKey:@"user_id"]forKey:@"customer_id"];
            [[NSUserDefaults standardUserDefaults]setValue:dict forKey:@"data"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:@"Information has been saved successfully." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            
            
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {
                 [alertView hideWithCompletionBlock:^{
                    txtoldPass.text=@"";
                     txtnewPass.text=@"";
                     txtconfPass.text=@"";
                     
                 }];
             }];
            [alert showWithAnimation:URBalertAnimationType];;
        }
        else
        {
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Message" message:[[result valueForKey:@"result"]valueForKey:@"msg"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
             [alert showWithAnimation:URBalertAnimationType];;
        }
        
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"Clearcart"])
    {
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
        if (deviceToken ==nil)
        {
            [dict setValue:@"123" forKey:@"device_token"];
        }
        else
        {
            [dict setValue:deviceToken forKey:@"device_token"];
        }
        [dict setValue:@"ios" forKey:@"device_type"];
        
        serviceCount = serviceCount + 1;
        URLManager *manager = [[URLManager alloc] init];
        manager.commandName = @"Logout";
        manager.delegate = self;
        [manager urlCall:@"http://snapnurse.com/webservice/logout" withParameters:dict];
        
        
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"Logout"])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"No" forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:@"null" forKey:@"loginvia"];
        [[NSUserDefaults standardUserDefaults] setValue:@"null" forKey:@"data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"card.last4"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"STRIP_CUSTOMER_ID"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cardInfo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [NSUserDefaults resetStandardUserDefaults];
        
        AppDelegate * ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
       /* spl=[[Splash_VC alloc]init];
        nav=[[UINavigationController alloc] initWithRootViewController:spl];
        ap.window.rootViewController=nav;
        
        if (IS_OS_8_OR_LATER)
        {
            spl=[[Splash_VC alloc]init];
            nav=[[UINavigationController alloc] initWithRootViewController:spl];
            [ap.window addSubview:nav.view];
            [ap.window makeKeyAndVisible];
        }
        else
        {
            spl=[[Splash_VC alloc]init];
            nav=[[UINavigationController alloc] initWithRootViewController:spl];
            ap.window.rootViewController=nav;
            [ap.window makeKeyAndVisible];
        }*/
         [ap setUpTabBarController];
    }
    else  if ([[result valueForKey:@"commandName"] isEqualToString:@"CreateCustomer"])
    {
        NSString *strCustomeID=[[result valueForKey:@"result"]valueForKey:@"id"];
        
        if(strCustomeID==nil||strCustomeID.length==0)
        {
            
        }
        else
        {
            NSString *customerId;
            customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
            NSString *strCardId=[[[[[result valueForKey:@"result"]valueForKey:@"sources"]valueForKey:@"data"]objectAtIndex:0]valueForKey:@"id"];
            NSString *strCardNo=[[[[[result valueForKey:@"result"]valueForKey:@"sources"]valueForKey:@"data"]objectAtIndex:0]valueForKey:@"last4"];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:customerId forKey:@"customer_id"];
            [dict setObject:strCustomeID forKey:@"stripe_customer_id"];
            [dict setObject:strCardId forKey:@"stripe_card_id"];
            [dict setObject:strCardNo forKey:@"card_no"];
            [dict setObject:strcardbard forKey:@"card_type"];
             NSLog(@"Dict :---- %@",dict);
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"AddCard";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/addCardDetails"withParameters:dict];
        }
        
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"AddCard"])
    {
        NSString *strCustomeID=[[[[result valueForKey:@"result"]valueForKey:@"review_data"]valueForKey:@"customer_cards"]valueForKey:@"stripe_customer_id"];
        [[NSUserDefaults standardUserDefaults]setValue:strCustomeID forKey:@"STRIP_CUSTOMER_ID"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        cardview.hidden=YES;
        tblYear.delegate=nil;
        [tblYear removeFromSuperview];
        tblYear=nil;
        tblYear=[[UITableView alloc]initWithFrame:CGRectMake(0,05,paymentview.frame.size.width, paymentview.frame.size.height)];
        tblYear.backgroundColor=[UIColor clearColor];
        tblYear.delegate=self;
        tblYear.dataSource=self;
        tblYear.separatorStyle=normal;
        tblYear.separatorColor=[UIColor clearColor];
        [paymentview addSubview:tblYear];
        personalinfo.enabled=YES;
        paymentcardinfo.enabled=YES;
        scrlcontent.scrollEnabled=YES;
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
    else if(ancode == -1005)
    {
        
    }
    else
    {
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        [alert showWithAnimation:URBalertAnimationType];;
    }
    
    
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"Editprofile"])
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
                [self saveBtnClick];
                
            }
        }
        else if ([commandName isEqualToString:@"Clearcart"])
        {
            if (serviceCount >= 3)
            {
                serviceCount = 0;
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"" message:@"Something went wrong please try again later." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                serviceCount = serviceCount +1;
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                NSString *customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
                [dict setValue:customerId forKey:@"login_user_id"];
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"Clearcart";
                manager.delegate = self;
                [manager urlCall:@"http://snapnurse.com/webservice/clearAllCartDetails" withParameters:dict];
            }
        }
        else if ([commandName isEqualToString:@"Logout"])
        {
            if (serviceCount >= 3)
            {
                
                serviceCount = 0;
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"" message:@"Something went wrong please try again later." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
                if (deviceToken ==nil)
                {
                    [dict setValue:@"123" forKey:@"device_token"];
                }
                else
                {
                    [dict setValue:deviceToken forKey:@"device_token"];
                }
                [dict setValue:@"ios" forKey:@"device_type"];
                
                serviceCount = serviceCount + 1;
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"Logout";
                manager.delegate = self;
                [manager urlCall:@"http://snapnurse.com/webservice/logout" withParameters:dict];
            }
        }
        
    }

}





#pragma  mark payment delegate and methods

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
//    paymentsavebtn.enabled = textField.isValid;
}
- (void)save:(id)sender
{
    
    
    [paymentTextField resignFirstResponder];
    
    if (self.paymentTextField.cardNumber==nil || [self.paymentTextField.cardNumber length]<=15 || [self.paymentTextField.cardNumber isEqual:[NSNull null]] || self.paymentTextField.isValid==NO)
    {
        paymentsavebtn.enabled=YES;
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Warning" message:@"Please enter valid card details." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
        
    }
else
{
    if (![self.paymentTextField isValid]) {
        return;
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentTextField.cardNumber;
    card.expMonth = self.paymentTextField.expirationMonth;
    card.expYear = self.paymentTextField.expirationYear;
    card.cvc = self.paymentTextField.cvc;
    
    
    
  
    
    
    
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                                              if (error) {
                                                  NSDictionary *dict=[[NSDictionary alloc]init];
                                                  dict=error.userInfo;

                                                  
                                                  URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:[dict valueForKey:@"NSLocalizedDescription"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                                  [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                                                  [alert showWithAnimation:URBalertAnimationType];;
//                                                  [self.delegate paymentViewController:self didFinish:error];
                                              }
                                              else
                                              {
                                                  NSLog(@"My Token==%@",token.tokenId);
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setValue:card.last4 forKey:@"card.last4"];
                                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                                  NSMutableDictionary *dictcard=[[NSMutableDictionary alloc]init];
                                                  NSString *strcardexpmont=[NSString stringWithFormat:@"%u",[[token card] expMonth]];
                                                  NSString *strcardexpYear=[NSString stringWithFormat:@"%u",[[token card] expYear]];
                                                  strcardbard=[NSString stringWithFormat:@"%ld",(long)[[token card]brand]];
                                                  NSString *strcontry=[NSString stringWithFormat:@"%@",[[token card]country]];
                                                  
                                                  
                                                  [dictcard setValue:card.last4 forKey:@"card.last4"];
                                                  [dictcard setValue:strcardexpmont forKey:@"ExpirMonth"];
                                                  [dictcard setValue:strcardexpYear forKey:@"ExpireYear"];
                                                  [dictcard setValue:strcardbard forKey:@"cardBrand"];
                                                  [dictcard setValue:strcontry forKey:@"CardContry"];
                                                  
                                                  
                                                  [[NSUserDefaults standardUserDefaults]setValue:dictcard forKey:@"cardInfo"];
                                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                                  
                                                  
                                                  iscustomer=YES;
                                                  
                                                  
                                                  NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                                                  //                                              [dict setObject:@"YES" forKey:@"iscustomer"];
                                                  if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
                                                  {
                                                      NSString *  email = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"email"];
                                                      if ([email isEqualToString:@""]||email==nil)
                                                      {
                                                          [dict setObject:@"Customer for test@mail.com" forKey:@"description"];
                                                      }
                                                      else
                                                      {
                                                          [dict setObject:[NSString stringWithFormat:@"Customer for %@",email] forKey:@"description"];
                                                      }
                                                      
                                                  }
                                                  else
                                                  {
                                                      [dict setObject:@"Customer for test@mail.com" forKey:@"description"];
                                                  }

                                                  [dict setObject:token.tokenId forKey:@"source"];
                                                  
                                                  
                                                  URLManager *manager = [[URLManager alloc] init];
                                                  manager.commandName = @"CreateCustomer";
                                                  manager.delegate = self;
                                                  [manager urlCall:@"https://api.stripe.com/v1/customers" withParameters:dict];
                                                  ;
                                              }
                                          }];

}
    
}

-(void)closeClick
{
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        cardview.frame = CGRectMake(0,viewHeight,paymentview.frame.size.width, paymentview.frame.size.height);

                     }
                     completion:^(BOOL finished){
                     }];
    [paymentTextField resignFirstResponder];
    personalinfo.enabled=YES;
    paymentcardinfo.enabled=YES;
    scrlcontent.scrollEnabled=YES;
    tblYear.hidden=NO;
    cardview.hidden=YES;

}
-(void)doneClicked:(id)sender
{
     NSLog(@"Done Clicked.");
    [paymentview endEditing:YES];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.viewControllers indexOfObject:viewController] == tabBarController.selectedIndex)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
