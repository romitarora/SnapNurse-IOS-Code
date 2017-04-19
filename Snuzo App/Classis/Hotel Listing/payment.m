//
//  payment.m
//  Snuzo App
//
//  Created by Oneclick IT on 9/22/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import "payment.h"
#import "STPPaymentCardTextField.h"
#import "Stripe.h"
#import "PaymentViewController.h"

#import "ViewController.h"


@interface payment ()<STPPaymentCardTextFieldDelegate>
{
    STPPaymentCardTextField *paymentTextField;

}
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;

@property (nonatomic) BOOL applePaySucceeded;
@property (nonatomic) NSError *applePayError;
//@property (nonatomic) ShippingManager *shippingManager;

@end
/*
 
 }
 @property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
 */
@implementation payment
@synthesize hours;
-(void)viewWillAppear:(BOOL)animated
{
    serviceCount = 0;
    
    [self GetLink];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // [self showTabBar:self.tabBarController];
    // [self hideTabBar:self.tabBarController];
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    //[self.view addSubview:bg];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackBtnClick)];
    back.tintColor=globelColor;
    self.navigationItem.leftBarButtonItem=back;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    self.navigationItem.title = @"Booking";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
    
    
    scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    
    scrollView.frame= CGRectMake(0, 0, self.view.frame.size.width,viewHeight);
    
    [self.view addSubview:scrollView];
    
    if (IS_IPHONE_6 || IS_IPHONE_6plus)
    {
        y=20;
    }
    else
    {
        y=15;
    }
    
    UIImageView *  imgNursePic=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50,y,100,100)];
    imgNursePic.image=[UIImage imageNamed:@"iTunesArtwork@"];
    
    if (![self.strProfileUrl isEqual:[NSNull null]])
    {
        if ([self.strProfileUrl isEqualToString:@"NA"])
        {
            
        }
        else
        {
            imgNursePic.imageURL = [NSURL URLWithString:self.strProfileUrl];
        }
        
    }
    
    imgNursePic.layer.cornerRadius=50;
    imgNursePic.layer.borderColor = [UIColor whiteColor].CGColor;
    imgNursePic.layer.borderWidth=0.5;
    imgNursePic.contentMode = UIViewContentModeScaleAspectFill;
    [imgNursePic setClipsToBounds:YES];
    
    [scrollView addSubview:imgNursePic];
    
    y=y+110;
    
    lblHotelName=[[UILabel alloc]initWithFrame:CGRectMake(0,y, self.view.frame.size.width,13)];
    lblHotelName.font=[UIFont boldSystemFontOfSize:12.0];
    lblHotelName.textColor=[UIColor blackColor];
    lblHotelName.textAlignment=NSTextAlignmentCenter;
    lblHotelName.text=self.strHotelName;
    lblHotelName.font=[UIFont fontWithName:@"AvenirNextLTPro-regular" size:12.0];
    
    [scrollView addSubview:lblHotelName];
    
    y=y+22;
    
    lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(0,y, self.view.frame.size.width,20)];
    lblPrice.font=[UIFont boldSystemFontOfSize:18.0];
    lblPrice.textColor=[UIColor blackColor];
    lblPrice.font=[UIFont fontWithName:@"AvenirNextLTPro-regular" size:18.0];
    lblPrice.backgroundColor = [UIColor clearColor];
    lblPrice.textAlignment = NSTextAlignmentCenter;
    
    lblPrice.text=[NSString stringWithFormat:@"$ %@  %@ Hrs",_Price,hours];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:lblPrice.text];
    NSRange range2 = [lblPrice.text rangeOfString:[NSString stringWithFormat:@" %@ Hrs",hours]];
    
    NSRange range1 = [lblPrice.text rangeOfString:[NSString stringWithFormat:@"$ %@",_Price]];
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:globelColor}
                            range:range1];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor blackColor]}
                            range:range2];
    
    lblPrice.attributedText = attributedText;
    
    [scrollView addSubview:lblPrice];
    
    //        if (IS_IPHONE_4)
    //        {
    //           y=y+33;
    //        }
    //        else
    //        {
    //           y=y+43;
    //        }
    
    UILabel *lblcard=[[UILabel alloc]initWithFrame:CGRectMake(0, y,self.view.frame.size.width, 13)];
    lblcard.font=[UIFont boldSystemFontOfSize:12.0];
    lblcard.textColor=[UIColor blackColor];
    lblcard.backgroundColor=[UIColor clearColor];
    lblcard.textAlignment=NSTextAlignmentCenter;
    lblcard.text=@"Card Detail: ";
    lblcard.font=[UIFont fontWithName:@"AvenirNextLTPro-regular" size:12.0];
    // [scrollView addSubview:lblcard];
    
    [self create_PaymentView];
    
    // Do any additional setup after loading the view.
    
}
- (void)viewDidLoad
{
    //    isClickd=YES;
    // [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Booking";
    serviceCount = 0;
    [self getcartdetail];
    
}
-(void)create_PaymentView
{
    y=y+22;
    
    int  yy;
    
    yy = y;
    
    [cardView removeFromSuperview];
    [Editview removeFromSuperview];
    cardView=nil;
    cardView =[[UIView alloc]initWithFrame:CGRectMake(30,y, self.view.frame.size.width-60, 35)];
    UIImageView *bg1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,cardView.frame.size.width, cardView.frame.size.height)];
    bg1.image=[UIImage imageNamed:@"bgLogin"];
    // [cardView addSubview:bg1];
    //  [scrollView addSubview:cardView];
    
    NSString *strCustomeID=[[NSUserDefaults standardUserDefaults]valueForKey:@"STRIP_CUSTOMER_ID"];
    if(strCustomeID==nil||strCustomeID.length==0)
    {
        paymentTextField = [[STPPaymentCardTextField alloc] init];
        paymentTextField.frame=CGRectMake(0,0, cardView.frame.size.width, 35);
        paymentTextField.textColor=[UIColor blackColor];
        paymentTextField.delegate = self;
        self.paymentTextField = paymentTextField;
        
        [cardView addSubview:paymentTextField];
        
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
        
        [LinkLable removeFromSuperview];
        [rememberImg removeFromSuperview];
        [rememberBtn removeFromSuperview];
        
        LinkLable=nil;
        rememberImg=nil;
        rememberBtn=nil;
        
        y=y+50;
        
        LinkLable=[[RTLabel alloc]initWithFrame:CGRectMake(50,y, self.view.frame.size.width-50, 50)];
        LinkLable.text=strLink;
        LinkLable.delegate=self;
        LinkLable.textColor=[UIColor blackColor];
        LinkLable.font=[UIFont systemFontOfSize:12.0];
        
        rememberImg=[[UIImageView alloc] init];
        rememberImg.backgroundColor=[UIColor clearColor];
        rememberImg.frame=CGRectMake(27,y-1, 17, 17);
        rememberImg.image = [UIImage imageNamed:@"uncheck.png"];
        [scrollView addSubview:rememberImg];
        
        rememberBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rememberBtn.backgroundColor=[UIColor clearColor];
        rememberBtn.frame=CGRectMake(0, y-15, 40+80, 40);
        [rememberBtn addTarget:self action:@selector(remember:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:rememberBtn];
        [scrollView addSubview:LinkLable];
        
        paymentsavebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        y=y+40;
        paymentsavebtn.frame=CGRectMake(25, y, self.view.frame.size.width-50, 40);
        [paymentsavebtn setTitle:@"Confirm Booking" forState:UIControlStateNormal];
        paymentsavebtn.backgroundColor=globelColor;
        paymentsavebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
        paymentsavebtn.layer.cornerRadius=1.0;
        
        [paymentsavebtn addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
        
        [paymentsavebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        paymentsavebtn.layer.cornerRadius=5.0;
        
        [scrollView  addSubview:paymentsavebtn];
        
        paymentsavebtn.enabled=YES;
        
        ISfristTime=YES;
    }
    else
    {
        [cardButton removeFromSuperview];
        cardButton=[UIButton buttonWithType:UIButtonTypeCustom];
        cardButton.frame=CGRectMake(0, 0, cardView.frame.size.width, 35);
        [[cardButton layer] setBorderWidth:1.0f];
        cardButton.layer.cornerRadius=5.0;
        [[cardButton layer] setBorderColor:[UIColor blackColor].CGColor];
        [cardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cardButton addTarget:self action:@selector(editClcik) forControlEvents:UIControlEventTouchUpInside];
        [cardView addSubview:cardButton];
        
        
        NSString *last4=[[[NSUserDefaults standardUserDefaults]valueForKey:@"cardInfo"]valueForKey:@"card.last4"];
        
        lbltext=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, cardView.frame.size.width-60, 35)];
        lbltext.font=[UIFont boldSystemFontOfSize:20.0];
        lbltext.textColor=[UIColor blackColor];
        lbltext.textAlignment=NSTextAlignmentLeft;
        lbltext.text=[NSString stringWithFormat:@"**** - **** - **** - %@",last4];
        lbltext.font=[UIFont fontWithName:@"AvenirNextLTPro-regular" size:16];
        [cardButton addSubview:lbltext];
        
        
        [imgcard removeFromSuperview];
        imgcard=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 32, 20)];
        NSString *imageName;
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
        
        [cardButton addSubview:imgcard];
        
        [LinkLable removeFromSuperview];
        [rememberImg removeFromSuperview];
        [rememberBtn removeFromSuperview];
        
        LinkLable=nil;
        rememberImg=nil;
        rememberBtn=nil;
        
        y=y+50;
        
        LinkLable=[[RTLabel alloc]initWithFrame:CGRectMake(50,y, self.view.frame.size.width-50, 50)];
        LinkLable.text=strLink;
        LinkLable.delegate=self;
        LinkLable.textColor=[UIColor blackColor];
        LinkLable.font=[UIFont systemFontOfSize:12.0];
        
        rememberImg=[[UIImageView alloc] init];
        rememberImg.backgroundColor=[UIColor clearColor];
        rememberImg.frame=CGRectMake(27,y-1, 17, 17);
        rememberImg.image = [UIImage imageNamed:@"uncheck.png"];
        [scrollView addSubview:rememberImg];
        
        rememberBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rememberBtn.backgroundColor=[UIColor clearColor];
        rememberBtn.frame=CGRectMake(0, y-15, 40+80, 40);
        [rememberBtn addTarget:self action:@selector(remember:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:rememberBtn];
        [scrollView addSubview:LinkLable];
        
        paymentsavebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        y=y+40;
        paymentsavebtn.frame=CGRectMake(25, y, self.view.frame.size.width-50, 40);
        [paymentsavebtn setTitle:@"Confirm Booking" forState:UIControlStateNormal];
        paymentsavebtn.backgroundColor=globelColor;
        paymentsavebtn.tag=3;
        paymentsavebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
        paymentsavebtn.layer.cornerRadius=1.0;
        
        [paymentsavebtn addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
        
        [paymentsavebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        paymentsavebtn.layer.cornerRadius=5.0;
        
        [scrollView  addSubview:paymentsavebtn];
        
    }
    y=y+40;
    [lblInfo removeFromSuperview];
    lblInfo=[[UILabel alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-40, 80)];
    lblInfo.text=@"You can cancel the reservation up to 30 minutes after booking or cancel 1 hour before your booking time.";
    lblInfo.font=[UIFont fontWithName:@"AvenirNextLTPro-regular" size:14];
    lblInfo.numberOfLines=0;
    
    lblInfo.textAlignment=NSTextAlignmentCenter;
    lblInfo.textColor=[UIColor blackColor];
    [scrollView addSubview:lblInfo];
}
#pragma mark - getcartDetail
-(void)getcartdetail
{
    serviceCount = serviceCount+1;
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
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

#pragma mark --- Back buttonClick

-(void)BackBtnClick
{
    [self clearcart];
    isincart=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark touche method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.view endEditing:YES];
    }
}

#pragma  mark payment delegate and methods

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField
{
    //paymentsavebtn.enabled = textField.isValid;
}

- (void)save:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    
    [self.view endEditing:YES];
    [paymentTextField resignFirstResponder];
    UIButton *button = (UIButton *)sender;
    [paymentsavebtn setEnabled:false];
    
    NSInteger bTag = button.tag;
    bTag = 3;//jam06-10-2016 for hide payment.
    if (bTag==0)
    {
        if (ISchecked)
        {
            
            if (self.paymentTextField.cardNumber==nil || [self.paymentTextField.cardNumber length]<=15 || [self.paymentTextField.cardNumber isEqual:[NSNull null]] || self.paymentTextField.isValid==NO)
            {
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                
                paymentsavebtn.enabled=YES;
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Warning" message:@"Please enter valid card details." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                [alert showWithAnimation:URBalertAnimationType];;
                [paymentsavebtn setEnabled:true];
            }
            else
            {
                if (bTag==0)
                {
                    [paymentTextField resignFirstResponder];
                    if (![self.paymentTextField isValid]) {
                        return;
                    }
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                    
                    STPCard *card = [[STPCard alloc] init];
                    card.number = self.paymentTextField.cardNumber;
                    card.expMonth = self.paymentTextField.expirationMonth;
                    card.expYear = self.paymentTextField.expirationYear;
                    card.cvc = self.paymentTextField.cvc;
                    [[NSUserDefaults standardUserDefaults] setValue:card.last4 forKey:@"card.last4"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [[STPAPIClient sharedClient] createTokenWithCard:card
                                                          completion:^(STPToken *token, NSError *error) {
                                                              [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                                                              if (error)
                                                              {
                                                                  NSDictionary *dict=[[NSDictionary alloc]init];
                                                                  dict=error.userInfo;
                                                                  
                                                                  
                                                                  URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:[dict valueForKey:@"NSLocalizedDescription"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                                                  [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                                                                  [alert showWithAnimation:URBalertAnimationType];;
                                                                  
                                                              }
                                                              else
                                                              {
                                                                  NSLog(@"My Token==%@",token.tokenId);
                                                                  
                                                                  NSMutableDictionary *dictcard=[[NSMutableDictionary alloc]init];
                                                                  NSString *strcardexpmont=[NSString stringWithFormat:@"%lu",[[token card] expMonth]];
                                                                  NSString *strcardexpYear=[NSString stringWithFormat:@"%lu",[[token card] expYear]];
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
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Warning" message:@"Please click on the user agrrement before booking." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            
            [alert showWithAnimation:URBalertAnimationType];;
            [paymentsavebtn setEnabled:true];
        }
    }
    else if(bTag==3)
    {
        
        if (ISchecked)
        {
            serviceCount = serviceCount + 1;
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:self.strHotelID forKey:@"hotel_id"];
            NSString *customerId;
            customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
            [dict setObject:self.strHospitalId forKey:@"hospital_id"];
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"checkHotelVerifyForStripe";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/checkHotelVerifyForStripe" withParameters:dict];
            NSLog(@"call Websevice");
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Warning" message:@"Please click on the user agrrement before booking." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            [alert showWithAnimation:URBalertAnimationType];;
            [paymentsavebtn setEnabled:true];
        }
    }
    else if (bTag==5)
    {
        
        if (self.paymentTextField.cardNumber==nil || [self.paymentTextField.cardNumber length]<=15 || [self.paymentTextField.cardNumber isEqual:[NSNull null]] || self.paymentTextField.isValid==NO)
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Warning" message:@"Please enter valid card details." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            [alert showWithAnimation:URBalertAnimationType];;
            [paymentsavebtn setEnabled:true];
            
        }
        else
        {
            
            if (bTag==5)
            {
                
                [paymentTextField resignFirstResponder];
                
                if (![self.paymentTextField isValid]) {
                    return;
                }
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                
                STPCard *card = [[STPCard alloc] init];
                card.number = self.paymentTextField.cardNumber;
                card.expMonth = self.paymentTextField.expirationMonth;
                card.expYear = self.paymentTextField.expirationYear;
                card.cvc = self.paymentTextField.cvc;
                [[NSUserDefaults standardUserDefaults] setValue:card.last4 forKey:@"card.last4"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[STPAPIClient sharedClient] createTokenWithCard:card
                                                      completion:^(STPToken *token, NSError *error) {
                                                          [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                                                          if (error)
                                                          {
                                                              NSDictionary *dict=[[NSDictionary alloc]init];
                                                              dict=error.userInfo;
                                                              
                                                              
                                                              URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Error" message:[dict valueForKey:@"NSLocalizedDescription"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                                              [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                                                              [alert showWithAnimation:URBalertAnimationType];;
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"My Token==%@",token.tokenId);
                                                              
                                                              NSMutableDictionary *dictcard=[[NSMutableDictionary alloc]init];
                                                              NSString *strcardexpmont=[NSString stringWithFormat:@"%lu",[[token card] expMonth]];
                                                              NSString *strcardexpYear=[NSString stringWithFormat:@"%lu",[[token card] expYear]];
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
                                                              [dict setObject:@"Customer for test@mail.com" forKey:@"description"];
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
    }
}
-(void)closeClick
{
     [Editview removeFromSuperview];
    [paymentTextField resignFirstResponder];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                          Editview.frame = CGRectMake(0,viewHeight,self.view.frame.size.width, viewHeight);
                         
                     }
                     completion:^(BOOL finished){
                     }];
    isClickd=NO;
}
-(void)doneClicked:(id)sender
{
     NSLog(@"Done Clicked.");
    [paymentTextField resignFirstResponder];
}

#pragma mark EditClick

-(void)editClcik
{
    NSLog(@"2");
    
    if (isClickd)
    {
        isClickd=NO;
    }
    else
    {
        isClickd=YES;
        
        Editview=[[UIView alloc]initWithFrame:CGRectMake(0,viewHeight, self.view.frame.size.width, viewHeight)];
        Editview.backgroundColor=[UIColor whiteColor];
        [scrollView addSubview:Editview];
        
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             Editview.frame = CGRectMake(0,00,self.view.frame.size.width, viewHeight);
                         }
                         completion:^(BOOL finished){
                         }];
        
        paymentTextField = [[STPPaymentCardTextField alloc] init];
        paymentTextField.frame=CGRectMake(30, 43, self.view.frame.size.width-60, 35);
        paymentTextField.textColor=[UIColor blackColor];
        paymentTextField.delegate = self;
        self.paymentTextField = paymentTextField;
        [Editview addSubview:paymentTextField];
        
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
        paymentsavebtn.frame=CGRectMake(30, 115, 120, 30);
        [paymentsavebtn setTitle:@"Save" forState:UIControlStateNormal];
        paymentsavebtn.backgroundColor=globelColor;
        paymentsavebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
        paymentsavebtn.layer.cornerRadius=1.0;
        paymentsavebtn.tag=5;
        [paymentsavebtn addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
        [paymentsavebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        paymentsavebtn.layer.cornerRadius=5.0;
        [Editview  addSubview:paymentsavebtn];
        
        
        UIButton *paymentClosebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        paymentClosebtn.frame=CGRectMake(self.view.frame.size.width-150, 115,120, 30);
        [paymentClosebtn setTitle:@"Cancel" forState:UIControlStateNormal];
        paymentClosebtn.backgroundColor=globelColor;
        paymentClosebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
        paymentClosebtn.layer.cornerRadius=1.0;
        
        [paymentClosebtn addTarget:self action:@selector(closeClick)forControlEvents:UIControlEventTouchUpInside];
        
        [paymentClosebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        paymentClosebtn.layer.cornerRadius=5.0;
        
        [Editview  addSubview:paymentClosebtn];
        
        UILabel *lblcard=[[UILabel alloc]initWithFrame:CGRectMake(25,05,100, 30)];
        lblcard.font=[UIFont boldSystemFontOfSize:20.0];
        lblcard.textColor=[UIColor blackColor];
        lblcard.backgroundColor=[UIColor clearColor];
        lblcard.textAlignment=NSTextAlignmentLeft;
        lblcard.text=@"Card Detail: ";
        lblcard.font=[UIFont fontWithName:@"AvenirNextLTPro-regular" size:16];
        [Editview addSubview:lblcard];
        
        paymentsavebtn.enabled=YES;
        
    }
}

#pragma  mark ---- Get Link Webservice
-(void)GetLink
{
    serviceCount = serviceCount + 1;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"GetLinks";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/static_info"];
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url index:(int)urlIndex
{
     NSLog(@"did select url %@ and index %d", url,urlIndex);
    NSString *strUrl=[NSString stringWithFormat:@"http://%@",url];
    TermsConditionVC * view = [[TermsConditionVC alloc] init];
    view.strUrl = strUrl;
    
    if (urlIndex == 0)
    {
         view.strTitle =@"Terms and Conditions";
    }
    else
    {
         view.strTitle =@"Privacy Policy";
    }
   
    [self.navigationController pushViewController:view animated:YES];
    
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}

#pragma mark Url menager Delegates

- (void)onResult:(NSDictionary *)result
{
     serviceCount = 0;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
     NSLog(@"The result is...%@", result);
    
    if ([[result valueForKey:@"commandName"] isEqualToString:@"CreateCustomer"])
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
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"checkHotelVerifyForStripe"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            
            serviceCount = serviceCount +1;
            NSString *customerId;
            customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
            
//            NSString *strCustomeID=[[NSUserDefaults standardUserDefaults]valueForKey:@"STRIP_CUSTOMER_ID"];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:self.strHotelID forKey:@"hotel_id"];
            [dict setObject:self.Price forKey:@"amount"];
            [dict setObject:customerId forKey:@"login_user_id"];
           // [dict setObject:strCustomeID forKey:@"stripe_customer_id"];
            [dict setObject:self.strHospitalId forKey:@"hospital_id"];
            NSLog(@"Payment DICT  %@",dict);
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"createCharge";
            manager.delegate = self;
            [manager urlCall:@"http://snapnurse.com/webservice/createCharge" withParameters:dict];
        }
        else
        {
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:@"Nurse not verified." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {
                 
                 [alertView hideWithCompletionBlock:^{
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }];
             }];
             [alert showWithAnimation:URBalertAnimationType];;
            [paymentsavebtn setEnabled:true];

        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"createCharge"])
    {
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"sign up" message: [[result valueForKey:@"result"]valueForKey:@"msg" ] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            alert.tag=0;
            [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {

                 [alertView hideWithCompletionBlock:^{
                     [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                     Thanks_VC *Thanks=[[Thanks_VC alloc]init];
                     Thanks.arrData=[[result valueForKey:@"result"]mutableCopy];
                     [self.navigationController pushViewController:Thanks animated:YES];
                 }];
             }];
             [alert showWithAnimation:URBalertAnimationType];
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            if ([[[result valueForKey:@"result"] allKeys] containsObject:@"stripe_msg"])
            {
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[[result valueForKey:@"result"]valueForKey:@"stripe_msg"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
                 {
                     
                     [alertView hideWithCompletionBlock:^{
                         //[self showTabBar:self.tabBarController];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }];
                 }];
                
                 [alert showWithAnimation:URBalertAnimationType];;
                
            }
            else
            {
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[[result valueForKey:@"result"]valueForKey:@"msg"] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
                 {
                     
                     [alertView hideWithCompletionBlock:^{
                         //[self showTabBar:self.tabBarController];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }];
                 }];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                 [alert showWithAnimation:URBalertAnimationType];;
            }
        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"GetLinks"])
    {
        strLink=[[result valueForKey:@"result"]valueForKey:@"string"];
        LinkLable.text=strLink;
        LinkLable.textColor=[UIColor blackColor];
        LinkLable.font=[UIFont systemFontOfSize:12.0];
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"AddCard"])
    {
        NSString *strCustomeID=[[[[result valueForKey:@"result"]valueForKey:@"review_data"]valueForKey:@"customer_cards"]valueForKey:@"stripe_customer_id"];
        [[NSUserDefaults standardUserDefaults]setValue:strCustomeID forKey:@"STRIP_CUSTOMER_ID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self closeClick];
       // [self create_PaymentView];
        
        NSString *imageName;
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
        
        
        NSString *last4=[[[NSUserDefaults standardUserDefaults]valueForKey:@"cardInfo"]valueForKey:@"card.last4"];
        lbltext.text=[NSString stringWithFormat:@"**** - **** - **** - %@",last4];
        [Editview removeFromSuperview];
        if (ISchecked)
        {
            rememberImg.image=[UIImage imageNamed:@"check.png"];
        }
        else
        {
            rememberImg.image=[UIImage imageNamed:@"uncheck.png"];
        }
        if (ISfristTime)
        {
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.tag=3;
            [self save:button];
        }
        else
        {
        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"GetCart"])
    {
       AppDelegate * app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app hudEndProcessMethod];
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            
        }
        else
        {
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
             [app hudEndProcessMethod];
        }
    }
    
}

- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    [paymentsavebtn setEnabled:true];

    //    [app hudEndProcessMethod];
     NSLog(@"Payment View The error is...%@", error);
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
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"checkHotelVerifyForStripe"])
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
                serviceCount = serviceCount + 1;
                NSString *customerId;
                customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:self.strHotelID forKey:@"hotel_id"];
                [dict setObject:self.strHospitalId forKey:@"hospital_id"];
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"checkHotelVerifyForStripe";
                manager.delegate = self;
                [manager urlCall:@"http://snapnurse.com/webservice/checkHotelVerifyForStripe" withParameters:dict];
                NSLog(@"call Websevice");
                
            }
        }
        else if ([commandName isEqualToString:@"createCharge"])
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
                serviceCount = serviceCount +1;
                NSString *customerId;
                customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
                
//                NSString *strCustomeID=[[NSUserDefaults standardUserDefaults]valueForKey:@"STRIP_CUSTOMER_ID"];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:self.strHotelID forKey:@"hotel_id"];
                [dict setObject:self.Price forKey:@"amount"];
                [dict setObject:customerId forKey:@"login_user_id"];
              //  [dict setObject:strCustomeID forKey:@"stripe_customer_id"];
                [dict setObject:self.strHospitalId forKey:@"hospital_id"];
                
                NSLog(@"Payment DICT  %@",dict);
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"createCharge";
                manager.delegate = self;
                [manager urlCall:@"http://snapnurse.com/webservice/createCharge" withParameters:dict];

                
            }
        }
        else if ([commandName isEqualToString:@"GetLinks"])
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
                [self GetLink];
            }
        }
        else if ([commandName isEqualToString:@"GetCart"])
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
                [self getcartdetail];
            }
        }
        
    }
}
#pragma  mark = REMEMBER IMAGES
-(void)remember:(id)sender
{
    if (ISchecked==YES) {
        rememberImg.image=[UIImage imageNamed:@"uncheck.png"];
        ISchecked=NO;
    }
    else
    {
        rememberImg.image=[UIImage imageNamed:@"check.png"];
        ISchecked=YES;
    }
}
#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
   return YES;
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
