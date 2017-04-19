//
//  RateVc.h
//  Snuzo App
//
//  Created by Oneclick IT on 10/20/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JXBarChartView.h"
#import "Wallet.h"
#import "AddRate.h"
#import "UIColor+MRColor.h"
#import "MNMBottomPullToRefreshManager.h"

#import "URLManager.h"

@interface RateVc : UIViewController<UITableViewDataSource,UITableViewDelegate,URLManagerDelegate,MNMBottomPullToRefreshManagerClient>
{
    UIImageView *imghotel;
    UITableView *tblReviews;
     NSInteger serviceCount;
    UIImageView *imgHeaderView;
    BOOL IsfoundReviews;
    UIButton *btnHeader;
    NSMutableArray *arrayReviews;
    NSMutableArray *arrayRating;
    
    UILabel *lblType;
    UILabel *lblTotalReviews;
    
    UILabel * lblFirstSatr;
    UILabel * lblsecondSatr;
    UILabel * lblThirdSatr;
    UILabel * lblFourSatr;
    UILabel * lblFiveSatr;
    
    MNMBottomPullToRefreshManager * pullToRefreshManager_Images;
    int Count;
    
}
@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *strHotelImage;

@end
