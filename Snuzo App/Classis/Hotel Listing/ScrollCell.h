//
//  ScrollCell.h
//  Snuzo App
//
//  Created by one click IT consultany on 8/31/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView * scrolImag;
@property (nonatomic , strong) UIPageControl * pageController;
@property (nonatomic , strong) UIImageView * hotelImg;
@property (nonatomic , strong) UIButton * hotelBtn;

@end
