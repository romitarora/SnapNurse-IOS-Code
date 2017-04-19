//
//  ViewController.h
//  StripeExample
//
//  Created by Jack Flintermann on 8/21/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "AppDelegate.h"

#import "STPCheckoutViewController.h"

@class ViewController;

@protocol STPBackendCharging <NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion;

@end


@protocol PaymentViewControllerDelegate<NSObject>

- (void)paymentViewController:(ViewController *)controller didFinish:(NSError *)error;

@end


@interface ViewController : UIViewController<STPBackendCharging>
{
    
    UIButton *paymentsavebtn;
    
}
@end
/*
 
 
 
 
 mport "Constant.h"
 #import "AppDelegate.h"
 
 @protocol PaymentViewControllerDelegate<NSObject>
 
 - (void)paymentViewController:(ProfileVC *)controller didFinish:(NSError *)error;
 
 @end
 @property (nonatomic) NSDecimalNumber *amount;
 @property (nonatomic, weak) id<PaymentViewControllerDelegate> delegate;
 
 
 */