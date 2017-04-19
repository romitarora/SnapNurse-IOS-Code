//
//  NotificationVC.h
//  Nurse
//
//  Created by one click IT consultany on 8/17/16.
//  Copyright © 2016 com.Oneclick.apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constant.h"
#import "URLManager.h"
@interface NotificationVC : UIViewController<UITableViewDelegate,UITableViewDataSource,URLManagerDelegate>

{
    UILabel * noticeLbl;
    UITableView * notificationTbl;
    UISegmentedControl * segMentBtn;
    BOOL isFromCancel;
    BOOL isFromAccepted;
    NSMutableArray * pendingArr;
    NSMutableArray * cancelledArr;
    NSInteger pendingcount;
    NSInteger cancelledcount;
    NSInteger selectedIndex;
    NSInteger selectedSection;
    NSString * customerId;
    
    NSMutableDictionary * bookedDateDict;
    NSMutableDictionary * cancelledDateDict;
    NSMutableDictionary *deleteDict;
     NSInteger serviceCount;
    
    NSMutableArray * bookedDateArr;
    NSMutableArray * cancelledDateArr;
    
}
@property BOOL isfromNotify;
@end
