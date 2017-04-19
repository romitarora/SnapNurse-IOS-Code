//
//  SIgnupVC.h
//  Snuzo App
//
//  Created by one click IT consultany on 9/1/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "URBAlertView.h"
#import "URLManager.h"
#import "ProfileVC.h"
@interface SIgnupVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,URLManagerDelegate>
{
    UIScrollView *scrlcontent;
    UITextField *txtfname,*txtlname,*txtphNo,*txtemail,*txtoldPass,*txtnewPass,*txtconfPass,*txtnameoncard,*txtcardNo;
}

@property(nonatomic,strong)NSString *isfromBooking;
@property(nonatomic,strong)NSString *strIsfromRate;




@end
