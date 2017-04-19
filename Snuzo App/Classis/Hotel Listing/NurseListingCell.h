//
//  NurseListingCell.h
//  Snuzo App
//
//  Created by One Click IT Consultancy  on 7/30/16.
//  Copyright © 2016 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "RateView.h"
#import "AppDelegate.h"
@interface NurseListingCell : UITableViewCell
{
    
}
@property (nonatomic , strong)AsyncImageView * imgNursePic;
@property (nonatomic, strong)UILabel * lblSeperator;
@property( nonatomic,strong)UILabel * lblNameNurese;
@property(nonatomic, strong) UILabel * lblCastPerHour;
@property(nonatomic, strong) RateView * nurseRate;
-(void) SpecialiZationNureseField:(NSArray *)spelArray atIndexPath :(NSIndexPath *)indexPath;
-(UIColor *)sendingWords :(int *)wordscount;
@end
