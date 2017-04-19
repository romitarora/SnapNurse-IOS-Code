//
//  AddRate.h
//  Snuzo App
//
//  Created by Oneclick IT on 10/21/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+MRColor.h"
#import "AppDelegate.h"
#import "URLManager.h"
#import "URBAlertView.h"

@interface AddRate : UIViewController<UITextFieldDelegate,UITextViewDelegate,URLManagerDelegate>
{
    UITextView *myTextView;
    UIScrollView *scrlContent;
    UILabel *lblCount;
    NSInteger serviceCount;
}
@property(nonatomic,strong)NSString *strHotelID;
@property(nonatomic,strong)NSString *ISEDIT;
@property(nonatomic,strong)NSString *strReview;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *NoofReview;


@end
