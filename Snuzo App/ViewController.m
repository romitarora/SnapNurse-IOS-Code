//
//  ViewController.m
//  StripeExample
//
//  Created by Jack Flintermann on 8/21/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//


#import "ViewController.h"
#import "STPPaymentCardTextField.h"
#import "PaymentViewController.h"
#import "Stripe.h"
#import "AppDelegate.h"
@interface ViewController ()
{
    STPPaymentCardTextField *paymentTextField;
    
}
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController



- (void)viewDidLoad
{
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];    //;
    self.navigationItem.title = @"Payment";
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    paymentTextField.frame=CGRectMake(10, 50, 320-20, 35);
    paymentTextField.frame=CGRectMake(10, 100, 320-20, 35);
    paymentTextField.textColor=[UIColor whiteColor];
    
    paymentTextField.delegate = self;
    self.paymentTextField = paymentTextField;
    [self.view addSubview:paymentTextField];
    
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
    paymentsavebtn.frame=CGRectMake(25, 170, self.view.frame.size.width-50, 40);
    [paymentsavebtn setTitle:@"Save" forState:UIControlStateNormal];
    paymentsavebtn.backgroundColor=globelColor;
    paymentsavebtn.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
    paymentsavebtn.layer.cornerRadius=1.0;
    
    [paymentsavebtn addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    
    [paymentsavebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paymentsavebtn.layer.cornerRadius=1.0;
    
    paymentsavebtn.enabled=NO;
    
    [self.view addSubview:paymentsavebtn];
    
}



-(void)BackBtnClick
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self showTabBar:self.tabBarController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 15;
    CGFloat width = CGRectGetWidth(self.view.frame) - (padding * 2);
    self.paymentTextField.frame = CGRectMake(padding, padding, width, 44);
    self.activityIndicator.center = self.view.center;
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField
{
//    self.navigationItem.rightBarButtonItem.enabled = textField.isValid;
}
#pragma  mark payment delegate and methods

- (void)save:(id)sender {
    if (![self.paymentTextField isValid]) {
        return;
    }
    //    if (![Stripe defaultPublishableKey]) {
    //        NSError *error = [NSError errorWithDomain:StripeDomain
    //                                             code:STPInvalidRequestError
    //                                         userInfo:@{
    //                                                    NSLocalizedDescriptionKey: @"Please specify a Stripe Publishable Key in Constants.m"
    //                                                    }];
    //        [self.delegate paymentViewController:self didFinish:error];
    //        return;
    //    }
    
    
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentTextField.cardNumber;
    card.expMonth = self.paymentTextField.expirationMonth;
    card.expYear = self.paymentTextField.expirationYear;
    card.cvc = self.paymentTextField.cvc;
    
    [[NSUserDefaults standardUserDefaults] setValue:card.last4 forKey:@"card.last4"];
    
    
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                                              if (error)
                                              
                                              {
//                                                  [self.delegate PaymentViewController:self didFinish:error];
                                              }
                                              
                                              
                                               NSLog(@"My Token==%@",token.tokenId);
                                              
                                       
                                          }];
    
    
    
    
    
}

-(void)doneClicked:(id)sender
{
     NSLog(@"Done Clicked.");

    [paymentTextField resignFirstResponder];
    
}

//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus,

@end
