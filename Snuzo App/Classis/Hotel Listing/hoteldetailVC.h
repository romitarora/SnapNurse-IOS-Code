//
//  hoteldetailVC.h
//  Snuzo App
//
//  Created by Oneclick IT on 8/31/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "URLManager.h"
#import "AsyncImageView.h"
#import "NSString_stripHtml.h"
#import "LoginVC.h"
#import "animitysView.h"
#import "MapClass.h"
#import "RateVc.h"

@interface hoteldetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,URLManagerDelegate>
{
    
     NSInteger serviceCount;
    UIView * mainImgHeader;
    
    BOOL isClicked;
    
    NSMutableArray *timeArray,*maintime;
    UIButton *btnAminitys;
         AsyncImageView *imghotel;
    UIButton *btnBack;
    UILabel *lbltitle;
    UITableView *tblcontent;
    CGPoint lastPos;
    UIImageOrientation scrollOrientation;
    UIImageView *topImg;
    NSMutableArray *hoteldetail;
    NSMutableArray *imagearray;
    NSMutableArray *Roomarray;
    UIScrollView *scrlimg;
    NSInteger tablehieght;
    UIImageView * btnBackImg;
    
    NSString *strdesc;
    
    UIButton * bookNurseBtn;
    UIButton * btnRate;
    UIView * HeaderView;
    UIView * bottomView;
    RateView * rateVw;
    UILabel * priceLbl;
    UIImageView *imgright;
    
    NSString * strEmail ,* strMobileNo , * strAddress, *latStr, *lonStr;

    
}
@property(nonatomic,strong)NSString *strid;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *hours;
@property(nonatomic,strong)NSString *timevalue,*strHospitalName,*strHospitalId;

@property(nonatomic,strong)NSMutableArray *searchdetailarray;
@property(nonatomic, strong) NSMutableArray * specializationArr;
@property(nonatomic,strong)NSString *date;


@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *priceStr;
@property(nonatomic, strong)NSString* nurseStartTime;
@property(nonatomic, strong)NSString* imgUrlStr;
@property BOOL isFromBookingList;

@end
