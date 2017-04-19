//
//  SIgnupVC.m
//  Snuzo App
//
//  Created by one click IT consultany on 9/1/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "SIgnupVC.h"
#import "Constant.h"
@interface SIgnupVC ()
{
    NSMutableArray * userDetailArr;
    
}

@end

@implementation SIgnupVC


@synthesize isfromBooking;


-(void)viewWillAppear:(BOOL)animated
{

    
    if (isfromBooking)
    {
      //  [self hideTabBar:self.tabBarController];

    }
    else
    {
    }
    
    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"]) {
//        
//            ProfileVC * profil =[[ProfileVC alloc] init];
//            [self.navigationController pushViewController:profil animated:NO];
//        
//    }
//    else
//    {
//        
//    }
//    
//    
//    if ([isfromBooking isEqualToString:@"YES"])
//    {
//        [self hideTabBar:self.tabBarController];
//        
//    }
//    else
//    {
//        
//    }
    
    
    
    
    
    
    
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



- (void)viewDidLoad {
    {
        
        UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(BackBtnClick)];
        self.navigationItem.leftBarButtonItem=backbarBtn;
        
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
        [super viewDidLoad];
        
        userDetailArr=[[NSMutableArray alloc] init];
        userDetailArr=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"userArr"] mutableCopy];
        if ([userDetailArr count]==0)
        {
            userDetailArr=[[NSMutableArray alloc] init];
            NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
            [dict setObject:@"required" forKey:@"firstname"];
            [dict setObject:@"required" forKey:@"lastname"];
            [dict setObject:@"required" forKey:@"password"];
            [dict setObject:@"required" forKey:@"email"];
            [userDetailArr addObject:dict];
            
        }
        else
        {
            
        }
        
        self.navigationItem.title=@"Registration";
        
        UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        bg.image=[UIImage imageNamed:@"bgLogin"];
        [self.view addSubview:bg];
        

        UIImageView * logoImg =[[UIImageView alloc] init];
        logoImg.frame=CGRectMake(108.2, 30, 103, 28);
        if (IS_IPHONE_4) {
            logoImg.frame=CGRectMake(108.2,6, 95,25);
            
        }
        logoImg.image=[UIImage imageNamed:@"logo"];
        [self.view addSubview:logoImg];
        
        if ([isfromBooking isEqualToString:@"YES"])
        {
            
            
            UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(BackBtnClick)];
            self.navigationItem.leftBarButtonItem=backbarBtn;
            
            self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
            
            
        }
        
        
        
        [scrlcontent removeFromSuperview];
        
        scrlcontent=nil;
        
        scrlcontent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 82, self.view.frame.size.width, self.view.frame.size.height)];
        scrlcontent.scrollEnabled=NO;
        [scrlcontent setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200)];
        scrlcontent.showsHorizontalScrollIndicator = NO;
        scrlcontent.showsVerticalScrollIndicator = NO;
        if (IS_IPHONE_4) {
            scrlcontent.frame=CGRectMake(0, 40, self.view.frame.size.width, (self.view.frame.size.height-40)-85);
            scrlcontent.scrollEnabled=NO;
            [scrlcontent setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50)];
            scrlcontent.showsHorizontalScrollIndicator = YES;
            scrlcontent.showsVerticalScrollIndicator = YES;
            
            
        }
        
        scrlcontent.pagingEnabled = YES;
        scrlcontent.delegate = self;
        
        [self.view addSubview:scrlcontent];
        
        
        int y=0;
        
        UIView *nameview=[[UIView alloc]initWithFrame:CGRectMake(12,y, (self.view.frame.size.width)-24, 30)];
        nameview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"textbox"]];
        nameview.layer.cornerRadius=1.0;
        [scrlcontent addSubview:nameview];
        
        
        
        txtfname=[[UITextField alloc]initWithFrame:CGRectMake(10,0, nameview.frame.size.width-10, 30)];
        UIColor *color = [UIColor lightGrayColor];
        txtfname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
        txtfname.textAlignment=NSTextAlignmentLeft;
        txtfname.delegate=self;
        txtfname.backgroundColor=[UIColor clearColor];
        txtfname.layer.cornerRadius=1.0;
        [nameview addSubview:txtfname];
        
        
        y= y+45+3;
        
        
        UIView *lnameview=[[UIView alloc]initWithFrame:CGRectMake(12,y, (self.view.frame.size.width)-24, 30)];
        lnameview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"textbox"]];
        [scrlcontent addSubview:lnameview];
        
        
        txtlname=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, 30)];
        txtlname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
        txtlname.textAlignment=NSTextAlignmentLeft;
        txtlname.delegate=self;
        [lnameview addSubview:txtlname];
        lnameview.layer.cornerRadius=1.0;
        txtfname.layer.cornerRadius=1.0;
        
        
        
        
        y= y+45+3;
        
        
        
        UIView *emailview=[[UIView alloc]initWithFrame:CGRectMake(12,y, (self.view.frame.size.width)-24, 30)];
        emailview.backgroundColor=[UIColor whiteColor];
        
        
        txtemail=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, 30)];
        txtemail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        txtemail.textAlignment=NSTextAlignmentLeft;
        txtemail.delegate=self;
        [scrlcontent addSubview:emailview];
        [emailview addSubview:txtemail];
        
        
        emailview.layer.cornerRadius=1.0;
        txtemail.layer.cornerRadius=1.0;
        
        
        
        y= y+45+3;
        
        
        UIView *newpassview=[[UIView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 30)];
        newpassview.backgroundColor=[UIColor whiteColor];
        txtnewPass=[[UITextField alloc]initWithFrame:CGRectMake(10,0, nameview.frame.size.width-10, 30)];
        txtnewPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
        txtnewPass.textAlignment=NSTextAlignmentLeft;
        txtnewPass.delegate=self;
        [txtnewPass setSecureTextEntry:YES];
        [newpassview addSubview:txtnewPass];
        [scrlcontent addSubview:newpassview];
        
        newpassview.layer.cornerRadius=1.0;
        txtnewPass.layer.cornerRadius=1.0;
        
        
        
        y= y+45+3;
        
        UIView *Confpassview=[[UIView alloc]initWithFrame:CGRectMake(10,y, (self.view.frame.size.width)-20, 30)];
        Confpassview.backgroundColor=[UIColor whiteColor];
        
        
        txtconfPass=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, nameview.frame.size.width-10, 30)];
        txtconfPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm password" attributes:@{NSForegroundColorAttributeName: color}];
        txtconfPass.delegate=self;
        [txtconfPass setSecureTextEntry:YES];
        txtconfPass.textAlignment=NSTextAlignmentLeft;
        
        Confpassview.layer.cornerRadius=1.0;
        txtconfPass.layer.cornerRadius=1.0;
        
        [Confpassview addSubview:txtconfPass];
        [scrlcontent addSubview:Confpassview];
        
        txtfname.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
        txtlname.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
        txtemail.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
        txtnewPass.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
        txtconfPass.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
        
        txtfname.returnKeyType=UIReturnKeyNext;
        txtlname.returnKeyType=UIReturnKeyNext;
        txtemail.returnKeyType=UIReturnKeyNext;
        txtnewPass.returnKeyType=UIReturnKeyNext;
        txtconfPass.returnKeyType=UIReturnKeyDone;
        
        txtemail.keyboardType=UIKeyboardTypeEmailAddress;
        
        
        
        
        if (IS_IPHONE_4)
        {
            y=y+50;
            
        }
        else
        {
            y=y+60;
        }
        UIButton *savebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        savebtn.frame=CGRectMake(25, y, self.view.frame.size.width-50, 35);
        [savebtn setTitle:@"Sign up" forState:UIControlStateNormal];
        savebtn.backgroundColor=globelColor;
        [savebtn addTarget:self action:@selector(signupclick) forControlEvents:UIControlEventTouchUpInside];
        
        [savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        savebtn.layer.cornerRadius=2;
        [scrlcontent addSubview:savebtn];
        
        
        UILabel * loginLbl =[[UILabel alloc] initWithFrame:CGRectMake(0, y+70, 320, 20)];
        if (IS_IPHONE_4)
        {
            loginLbl.frame=CGRectMake(0,y+50, 320, 20);
            
        }
        loginLbl.font=[UIFont fontWithName:@"arial" size:12];
        loginLbl.textAlignment=NSTextAlignmentCenter;
        loginLbl.textColor=[UIColor whiteColor];
        loginLbl.text=@"Already have an account?";
        [scrlcontent addSubview:loginLbl];
        
        
        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:@"Already have an account? Login"];
        UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue-Bold" size:14.0];
        UIFontDescriptor *fontDescriptor1 = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue-Light" size:14.0];
        UIFontDescriptor *symbolicFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitTightLeading];
        
        UIFontDescriptor *symbolicFontDescriptor1 = [fontDescriptor1 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        
        UIFont *fontWithDescriptor = [UIFont fontWithDescriptor:symbolicFontDescriptor size:14.0];
        
        UIFont *fontWithDescriptor1 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:14.0];
        
        //Red and large
        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 26)];
        
        //Rest of text -- just futura
        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor1, NSForegroundColorAttributeName:[UIColor colorWithRed:209.0/255.0 green:0 blue:216.0/255.0 alpha:1]} range:NSMakeRange(25, hintText.length - 25)];
        
        loginLbl.textColor=[UIColor whiteColor];
        
        
        
        [loginLbl setAttributedText:hintText];
        
        
        UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame=CGRectMake(70-12, y+70, 180+24, 35);
        if (IS_IPHONE_4)
        {
            loginBtn.frame=CGRectMake(70-12, y+50, 180+24, 35);
            
        }
        
        loginBtn.backgroundColor=[UIColor clearColor];
        [loginBtn addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [scrlcontent addSubview:loginBtn];
        
    }
}


-(void)LoginClick
{
    
    if ([isfromBooking isEqualToString:@"YES"])
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
//    LoginVC * loginV =[[LoginVC alloc] init];
//    if ([isfromBooking isEqualToString:@"YES"])
//    {
//        loginV.isfromBooking=@"YES";
//    }
//    [self.navigationController pushViewController:loginV animated:YES];
}
#pragma ---- sign up click method
-(void)signupclick
{
    
    NSString *password;
    NSString *confpassword;
    password=txtnewPass.text;
    confpassword=txtconfPass.text;
    
    if ([txtfname.text isEqualToString:@""])
    {
     
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter first name." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
         [alert showWithAnimation:URBalertAnimationType];;
        
    }
    else if ([txtlname.text isEqualToString:@""])
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter last name." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([txtemail.text isEqualToString:@""])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter email id." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
          [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([self validateEmail:txtemail.text] ==NO)
    {
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter valid email id." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
         [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([txtnewPass.text isEqualToString:@""])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter password." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([txtconfPass.text isEqualToString:@""])
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Please enter confirm password." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;    }
    else if (![txtconfPass.text isEqualToString:password])
    {
       
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Required!" message:@"Password and confirm pasword do not match." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
        
        
    }
    else if ([self isPasswordValid:txtnewPass.text]==NO)
    {
        
        
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:@"Please ensure that you have at least one lower case letter, one upper case letter, one digit, one special character and at least six digit length" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
         [alert showWithAnimation:URBalertAnimationType];;
        
        
        
    }
    
    
    
    else
    {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:txtfname.text forKey:@"first_name"];
        [dict setValue:txtlname.text forKey:@"last_name"];
        [dict setValue:txtemail.text forKey:@"email"];
        [dict setValue:txtnewPass.text forKey:@"password"];
        [dict setValue:@"Normal" forKey:@"register_via"];
        [dict setValue:@"male" forKey:@"gender"];
        [dict setValue:@"ios" forKey:@"device_type"];
        
        
        NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
        if (deviceToken ==nil)
        {
            [dict setValue:@"123" forKey:@"device_token"];
        }
        else
        {
            [dict setValue:deviceToken forKey:@"device_token"];
        }
        
         NSLog(@"%@",dict);
        
        URLManager *manager = [[URLManager alloc] init];
        manager.commandName = @"singup";
        manager.delegate = self;
        [manager urlCall:@"http://snapnurse.com/webservice/register" withParameters:dict];
       
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

#pragma ----
#pragma mark UrlManager Delegates
- (void)onResult:(NSDictionary *)result
{
     NSLog(@"The result is...%@", result);
    if([[result valueForKey:@"commandName"] isEqualToString:@"singup"])//jam27-07
    {
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Login" message:@"User Register successfully" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            alert.tag=0;
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {
                    [alertView hideWithCompletionBlock:^{
                     
                     NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                     NSString *strContact=[[[[[result valueForKey:@"result"]valueForKey:@"data"]valueForKey:@"customers"]objectAtIndex:0] valueForKey:@"mobile_no"];
                     

                     if ([strContact isEqualToString:@""]||strContact==nil)
                     {
                         strContact=@"";
                     }
                     else
                     {
                     }
                     [dict setValue:txtfname.text forKey:@"first_name"];
                     [dict setValue:txtlname.text forKey:@"last_name"];
                     [dict setValue:txtemail.text forKey:@"email"];
                     [dict setObject:strContact forKey:@"contact"];
                     [dict setValue:[[[result valueForKey:@"result"]valueForKey:@"data"]valueForKey:@"customer_id"]forKey:@"customer_id"];
                     [[NSUserDefaults standardUserDefaults] setValue:@"Normal" forKey:@"loginvia"];
                     [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isLogin"];
                     
                     
                     [[NSUserDefaults standardUserDefaults]setValue:dict forKey:@"data"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                     
                    [self singup];
                     

                     
                 }];
             }];
             [alert showWithAnimation:URBalertAnimationType];;
            
            
        }
        else
        {
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"sign up" message:[[result valueForKey:@"result"] valueForKey:@"msg"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
             [alert showWithAnimation:URBalertAnimationType];;
            
            
        }
    }

    
}
- (void)onError:(NSError *)error
{
    //    [app hudEndProcessMethod];
     NSLog(@"The error is...%@", error);
    NSInteger ancode = [error code];
    
    if (ancode == -1009)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connectivity" message:@"There is no network connectivity. This application requires a network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
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
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
    }
}


#pragma mark ---back btn


-(void)BackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark Sing up Naviagation 
-(void)singup
{
    
    if ([isfromBooking isEqualToString:@"YES"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.strIsfromRate isEqualToString:@"YES"])
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
        
    {
        ProfileVC * profil =[[ProfileVC alloc] init];
        [self.navigationController pushViewController:profil animated:YES];
    }
}

#pragma mark - UITextfield Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
     NSLog(@"Here is the txt tag=%ld",(long)[textField tag]);
    
    if (IS_IPHONE_4) {
        if (textField== txtconfPass) {
            [scrlcontent setContentOffset:CGPointMake(0, 80) animated:YES];

        }
        if (textField==txtnewPass)
        {
            [scrlcontent setContentOffset:CGPointMake(0, 70) animated:YES];

        }
    }
    else if (IS_IPHONE_5)
    {
        if (textField== txtconfPass) {
            [scrlcontent setContentOffset:CGPointMake(0, 50) animated:YES];
            
        }

        
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    textField.textColor=[UIColor colorWithHexString:@"52b5df"];
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == txtfname)
    {
        [txtlname becomeFirstResponder];
        
    }
    else if (textField==txtlname)
    {
        [txtemail becomeFirstResponder];
    }
    else if (textField==txtemail)
    {
        [txtnewPass becomeFirstResponder];
    }
    else if (textField==txtnewPass)
    {
        [txtconfPass becomeFirstResponder];

    }
    else if (textField==txtconfPass)
    {
        if (textField== txtconfPass) {
            [scrlcontent setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }

        [textField resignFirstResponder];
    }
        
    return YES;
    
}

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
