//
//  ScrollCell.m
//  Snuzo App
//
//  Created by one click IT consultany on 8/31/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "ScrollCell.h"

@implementation ScrollCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.scrolImag = [UIScrollView new];
        self.scrolImag.showsHorizontalScrollIndicator = NO;
        self.scrolImag.showsVerticalScrollIndicator=NO;
        self.scrolImag.pagingEnabled = YES;
        self.scrolImag.delegate = self;
        [self.contentView addSubview:self.scrolImag];
        
        
        self.hotelImg=[UIImageView new];
        self.hotelImg.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.hotelImg];
        
        
        self.hotelBtn=[UIButton new];
        self.hotelBtn.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.hotelBtn];
        
        
        
        
      
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   


    // Configure the view for the selected state
}

@end
