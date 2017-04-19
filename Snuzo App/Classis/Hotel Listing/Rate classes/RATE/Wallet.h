//
//  Wallet.h
//  Shopop
//
//  Created by One Click IT Consultancy  on 12/29/14.
//  Copyright (c) 2014 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface Wallet : UITableViewCell
@property(nonatomic,retain)UILabel * lblname;
@property(nonatomic,retain)UILabel * lbExpirydate;
@property(nonatomic,retain)UILabel * lbltypeOfDiscount;
@property(nonatomic,retain)AsyncImageView * imgselect;
@property(nonatomic,retain)AsyncImageView * imgBackground;


@property(nonatomic,retain)UIButton * btnDetail;



@end
