//
//  PastBokkingView.h
//  Snuzo App
//
//  Created by Oneclick IT on 9/3/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PastBokkingView : UIViewController
{
    UIView *pastbookView;
    UILabel *lblHotelname,*lblHoteladdress,*lblContact;
}

@property(nonatomic,strong)NSString *strname;
@property(nonatomic,strong)NSString *strURl;
@property(nonatomic,strong)NSString *straddress;

@end
