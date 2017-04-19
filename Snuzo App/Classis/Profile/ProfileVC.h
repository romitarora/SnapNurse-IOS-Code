//
//  ProfileVC.h
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "URBAlertView.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "PaymentViewController.h"

#import "URLManager.h"

#import "Splash_VC.h"


@class ProfileVC;
//
//@protocol PaymentViewControllerDelegate<NSObject>
//
//- (void)paymentViewController:(ProfileVC *)controller didFinish:(NSError *)error;
//
//@end
@interface ProfileVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,URLManagerDelegate,UITabBarDelegate,UITabBarControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
     NSInteger serviceCount;
    
    UILabel *lblcardDetail;
    
    NSString *strcardbard;
    
    UIButton *personalinfo;
    
    UIButton *paymentcardinfo;
    UIImageView *imgProfile;
    UIImageView *ProfileImage;
    
    UIScrollView *scrlPersonal;
    NSMutableArray *Yearaaray;
    NSMutableArray *Montharray;

    UINavigationController *nav;
    
    BOOL IsyearClcik;
    BOOL Ismonthclick;
    UIButton *paymentsavebtn;
    UIButton *paymentClosebtn;
    
    UIButton * monthBtn;
    
    UIScrollView *scrlcontent;
    int page;
    UIView *personalView,*paymentview,*cardview;
    
    UITableView * hospitalListTbl;
   
    
    UIImageView *lblLine;
    UIButton * yearBtn;
    UITableView *tblYear;
    UITableView *tblMonth;
    
    
    UITextField *txtfname,*txtlname,*txtphNo,*txtemail,*txtoldPass,*txtnewPass,*txtconfPass,*txtnameoncard,*txtcardNo;
    
}
@property BOOL isFromTabbar;
//@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic, weak) id<PaymentViewControllerDelegate> delegate;
@end
