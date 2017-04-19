//
//  animitysView.h
//  Snuzo App
//
//  Created by Oneclick IT on 9/17/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "aminitycellTableViewCell.h"
#import "URLManager.h"
#import "AppDelegate.h"

@interface animitysView : UIViewController<UITableViewDataSource,UITableViewDelegate,URLManagerDelegate>
{
    UITableView *tblAmeneties;
    NSMutableArray *hotelamenity;
     NSInteger serviceCount;
}

@property(nonatomic,strong)NSString *strHotelId;

@end
