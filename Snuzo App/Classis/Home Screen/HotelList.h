//
//  HotelList.h
//  Snozu App
//
//  Created by HARI on 8/4/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelListcell.h"
#import "hoteldetailcell.h"
@interface HotelList : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tblhoteList;
    
}
@end
