//
//  payment.h
//  Snuzo App
//
//  Created by Oneclick IT on 9/22/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PaymentViewController.h"
#import "Thanks_VC.h"
#import "RTLabel.h"
#import "ViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TermsConditionVC.h"
@class payment;

@interface payment : UIViewController<URLManagerDelegate,RTLabelDelegate,UITextFieldDelegate>

{
    
    UILabel *lblInfo;
    UILabel *lbltext;
    
    BOOL isClickd;
    BOOL ISchecked;
    BOOL ISfristTime;
    
    UIImageView *rememberImg;
    UIButton *rememberBtn;
    
    UILabel *lblHotelName;
    UILabel *lblPrice;
    UIButton *paymentsavebtn;
    
    int y;
    UIView *Editview;
    
    UIView *cardView;
    UIView *textView;
    
    UIButton *cardButton;
    
    RTLabel *LinkLable;
    
    NSString *strcardbard;
     NSInteger serviceCount;
    
    NSString *strLink;
    UIImageView *imgcard;
    
    
    BOOL isPaymentClick;
    TPKeyboardAvoidingScrollView *scrollView;
}
@property(nonatomic,strong)NSString *strHotelName,*strHospitalId;
@property(nonatomic,strong)NSString *Price;
@property(nonatomic,strong)NSString *strHotelID;
@property(nonatomic,strong)NSString *hours;
@property(nonatomic,strong)NSString *strProfileUrl;

@end
