//
//  HotelListcell.m
//  Snozu App
//
//  Created by HARI on 8/4/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "HotelListcell.h"

@implementation HotelListcell
@synthesize lblline;

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
    lblline=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
    lblline.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:lblline];
        return self;
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
