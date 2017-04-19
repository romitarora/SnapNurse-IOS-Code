//
//  NotificationListCell.m
//  Nurse
//
//  Created by one click IT consultany on 8/17/16.
//  Copyright © 2016 com.Oneclick.apps. All rights reserved.
//

#import "NotificationListCell.h"

@implementation NotificationListCell
@synthesize titleLbl,agencyNameLbl,msgLbl,profileImg,lineLbl,statusLbl,acceptBtn,rejectBtn,acceptLbl,rejectLbl,acceptImg,rejectImg,lblduration,lblStartTime,lblEndTime;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        profileImg = [[AsyncImageView alloc]init];
        profileImg.frame = CGRectMake(10, 15, 50, 50);
        profileImg.image = [UIImage imageNamed:@"Icon-App-60x60"];
        profileImg.layer.cornerRadius = 25;
        profileImg.layer.masksToBounds = YES;
        profileImg.layer.borderWidth = 0.5f;
        profileImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        profileImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:profileImg];
        
        titleLbl = [[UILabel alloc] init];
        titleLbl.frame = CGRectMake(70, 10, kScreenWidth-80, 30);
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.text = @"Hospital 2";
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12];
        [self.contentView addSubview:titleLbl];
        
        msgLbl = [[UILabel alloc] init];
        msgLbl.frame = CGRectMake(70, 30, kScreenWidth-80, 30);
        msgLbl.backgroundColor = [UIColor clearColor];
        msgLbl.text = @"is booked you for 1 Hrs from";
        msgLbl.numberOfLines = 0;
        msgLbl.textColor=[UIColor blackColor];
        msgLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12];
        [self.contentView addSubview:msgLbl];
        
        
        lblduration=[[UILabel alloc]initWithFrame:CGRectMake(70, 55, 210, 15)];
        lblduration.layer.cornerRadius = 7.5;
        lblduration.layer.masksToBounds = YES;
        lblduration.backgroundColor =[UIColor colorWithRed:254/255.0f green:100/255.0f blue:143/255.0f alpha:1.0f];
        [self.contentView addSubview:lblduration];
        
        lblStartTime = [[UILabel alloc] init];
        lblStartTime.frame = CGRectMake(75, 55, 75, 15);
        lblStartTime.textColor=[UIColor whiteColor];
        lblStartTime.font=[UIFont systemFontOfSize:10];
        lblStartTime.text = @"05 PM";
        lblStartTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lblStartTime];
        
        UIImageView * sepratorLineImg = [[UIImageView alloc] init];
        sepratorLineImg.frame = CGRectMake(122+30, 55+4.5, 42, 6);
        sepratorLineImg.image = [UIImage imageNamed:@"white_line.png"];
        sepratorLineImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:sepratorLineImg];
        
        lblEndTime = [[UILabel alloc] init];
        lblEndTime.frame = CGRectMake(165+30, 55, 75, 15);
        lblEndTime.textColor=[UIColor whiteColor];
        lblEndTime.font=[UIFont systemFontOfSize:10];
        lblEndTime.text = @"08 PM";
        lblEndTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lblEndTime];
        
        lineLbl =[[UILabel alloc] init];
        lineLbl.frame = CGRectMake(0, 79, kScreenWidth, 1);
        lineLbl.backgroundColor =[UIColor lightGrayColor];
        [self.contentView addSubview:lineLbl];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
