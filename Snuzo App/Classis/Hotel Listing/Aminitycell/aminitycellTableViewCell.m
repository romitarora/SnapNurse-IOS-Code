//
//  aminitycellTableViewCell.m
//  Snuzo App
//
//  Created by Oneclick IT on 9/17/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "aminitycellTableViewCell.h"

@implementation aminitycellTableViewCell
@synthesize lblline,lbltext;

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        
        lblline=[[UILabel alloc]init] ;
        lblline.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"devider"]];
        [self.contentView addSubview:lblline];
        
        
        
        lbltext=[[UILabel alloc]init];
        [self.contentView addSubview:lbltext];
        
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
