//
//  HotelListingVC.h
//  Snuzo App
//
//  Created by one click IT consultany on 8/29/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLManager.h"
#import "MNMBottomPullToRefreshManager.h"
#import "URBAlertView.h"
#import "hoteldetailVC.h"
#import "NurseListingCell.h"

@interface HotelListingVC : UIViewController<URLManagerDelegate,MNMBottomPullToRefreshManagerClient>
{
    NSMutableArray *filteredContentArray;
    MNMBottomPullToRefreshManager * pullToRefreshManager_Images;
    int Count;
    UILabel *lblMessage;
    
    UIView * navView;
     NSInteger serviceCount;
    UILabel * lblTitle;
    UIButton * btnBack;
    UIImageView * imgback;
    
    
}
@property (nonatomic,strong)NSString *flag,*strHospitalName,*strHospitalId;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *Time;
@property (nonatomic,strong)NSString *timevalue;
@property (nonatomic,strong)NSString *NOofhours;
@property (nonatomic,strong)NSString *searchStr;
@property(nonatomic,strong)RateView *rateVw;
@property(nonatomic,strong)NSString * cityStr;
@property(nonatomic,strong)NSString * nurseStartTime;




@end
