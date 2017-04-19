//
//  ConfirmBookVC.h
//  Snuzo App
//
//  Created by one click IT consultany on 9/2/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "URLManager.h"
#import "RateView.h"


@protocol STPBackendCharging <NSObject>


@end


@interface ConfirmBookVC : UIViewController<UITableViewDataSource,UITableViewDelegate,URLManagerDelegate,STPBackendCharging>
{
    AsyncImageView *imghotel;
    UIButton *btnBack;
    UILabel *lbltitle;
    UITableView *tblcontent;
    CGPoint lastPos;
    UIImageOrientation scrollOrientation;
    UIImageView *topImg;
    NSMutableArray *roomtypearrray,*timeArray,*maintime;
    
    
    NSInteger price;
    NSString *strPrice;
    
    NSString *strmianTime;
    NSString *strCheckoutTime;
    
    
    
    NSString *strHotelID;
    
    
    bool isconform;
    
    UIImageView * typeImg;
    UILabel * hotelTypeLbl;
    
    
    
}
@property (nonatomic,strong)NSMutableArray *HotelDetailArray;
@property(nonatomic,strong)NSString *hotelname,*strContact,*isfrombokking,*strLat,*strlon;


@property(nonatomic,strong)NSMutableArray *searchdetailarray;
@property(nonatomic,strong)NSString *imageurl;
@property(nonatomic,strong)NSMutableArray *cartDetails;

@property(nonatomic,strong)NSMutableArray *pricearray;



@end
