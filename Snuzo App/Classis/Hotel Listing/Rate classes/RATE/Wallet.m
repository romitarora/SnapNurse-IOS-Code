//
//  Wallet.m
//  Shopop
//
//  Created by One Click IT Consultancy  on 12/29/14.
//  Copyright (c) 2014 OneClickITSolution. All rights reserved.
//

#import "Wallet.h"


@implementation Wallet
@synthesize lblname,imgselect,lbExpirydate,lbltypeOfDiscount,btnDetail,imgBackground;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    { int yy=0;
        lblname=[[UILabel alloc]initWithFrame:CGRectMake(50, yy+27, 240, 30)];
       // lblname.text=@"notOpen";
        lblname.numberOfLines=2;
        lblname.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblname];
        
        lbExpirydate=[[UILabel alloc]init];
        // lblname.text=@"notOpen";
       // lbExpirydate.numberOfLines=2;
        lbExpirydate.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lbExpirydate];
        
        lbltypeOfDiscount=[[UILabel alloc]init];
        // lblname.text=@"notOpen";
       // lbltypeOfDiscount.numberOfLines=2;
        lbltypeOfDiscount.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lbltypeOfDiscount];
        
        btnDetail=[[UIButton alloc]init];
       [self.contentView addSubview:btnDetail];
        
        
        imgselect=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, yy+27, 34, 34)];
        [imgselect setImage:[UIImage imageNamed:@"unchecked_checkbox.png"]];
        [self.contentView addSubview:imgselect];
        
        imgBackground=[[AsyncImageView alloc]init];
        [self.contentView addSubview:imgBackground];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
