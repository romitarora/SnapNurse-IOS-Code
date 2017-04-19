//
//  NurseListingCell.m
//  Snuzo App
//
//  Created by One Click IT Consultancy  on 7/30/16.
//  Copyright © 2016 Oneclick IT. All rights reserved.
//

#import "NurseListingCell.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@implementation NurseListingCell
@synthesize lblSeperator,lblNameNurese,lblCastPerHour,nurseRate,imgNursePic;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) SpecialiZationNureseField:(NSArray *)spelArray atIndexPath :(NSIndexPath *)indexPath
{
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView * viewBackground = [[UIView alloc] initWithFrame:CGRectMake(8, 8,ScreenWidth-16, 82)];
    viewBackground.backgroundColor = [UIColor whiteColor];
    viewBackground.layer.shadowColor = [[UIColor blackColor] CGColor];
    viewBackground.layer.cornerRadius=5;
    viewBackground.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    viewBackground.layer.shadowOffset = CGSizeMake(-1, 1);
    viewBackground.layer.shadowOpacity = 1;
    viewBackground.layer.shadowRadius =0.2;
    [self.contentView addSubview:viewBackground];
    //  self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell"]];
    
    imgNursePic=[[AsyncImageView alloc]initWithFrame:CGRectMake(15,13.5+8,55,55)];
    imgNursePic.image=[UIImage imageNamed:@"Icon-App-60x60"];
    imgNursePic.layer.cornerRadius=27.5;
    imgNursePic.layer.borderColor = [UIColor whiteColor].CGColor;
    imgNursePic.layer.borderWidth=0.5;
    imgNursePic.contentMode = UIViewContentModeScaleAspectFill;
    [imgNursePic setClipsToBounds:YES];
    
    [self.contentView addSubview:imgNursePic];
    
    lblNameNurese=[[UILabel alloc]initWithFrame:CGRectMake(80, 15+3, ScreenWidth-170, 20)];
    lblNameNurese.text=@"Richmond Hotel Narita";
    lblNameNurese.textColor=[UIColor blackColor];
    lblNameNurese.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13];
    
    [self.contentView addSubview:lblNameNurese];
    
    nurseRate = [RateView rateViewWithRating:0.0];
    [self.contentView addSubview:nurseRate];
    
    nurseRate.frame = CGRectMake(ScreenWidth-90,15+3, 90, 14);
    nurseRate.starSize=13;
    nurseRate.rating=5;
    
    CGSize frameSize = CGSizeMake(ScreenWidth-100, 50);
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12.0];
    
    int x=70,y=35 ;
    int chWords=0;
    
    for (NSInteger i = 0; i < [spelArray count]; i++)
    {
        NSString * strSpecialist= [NSString stringWithFormat:@"%@",[[[spelArray objectAtIndex:i]valueForKey:@"hotel_services"] valueForKey:@"service_name"]];
        
        UILabel * lblSpl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 45, 18)];
        lblSpl.text=[NSString stringWithFormat:@" %@",strSpecialist];
        lblSpl.textColor=[UIColor whiteColor];
        lblSpl.font =[UIFont systemFontOfSize:10];
        lblSpl.layer.cornerRadius=8;
        lblSpl.clipsToBounds=YES;
      //  lblSpl.textAlignment=NSTextAlignmentCenter;
        lblSpl.backgroundColor=[UIColor colorWithRed:255/255.0 green:172/255.0 blue:95/255.0 alpha:1.0];
        [viewBackground addSubview:lblSpl];
        
        CGRect idealFrame1 = [strSpecialist boundingRectWithSize:frameSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{ NSFontAttributeName:font }
                                                         context:nil];
        NSString * strSpecialisttemp;
        CGRect idealTempFrame;
        if (i+1<[spelArray count])
        {
            strSpecialisttemp= [NSString stringWithFormat:@"%@",[[[spelArray objectAtIndex:i+1]valueForKey:@"hotel_services"] valueForKey:@"service_name"]];
            idealTempFrame = [strSpecialisttemp boundingRectWithSize:frameSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{ NSFontAttributeName:font }
                                                             context:nil];
        }else
        {
            
        }
        
        if (x+idealFrame1.size.width+20+idealTempFrame.size.width + 20<frameSize.width)
        {
            
            chWords++;
            
            if (i+1<[spelArray count])
            {
                NSString * strSpecialist2= [NSString stringWithFormat:@"%@",[[[spelArray objectAtIndex:i+1]valueForKey:@"hotel_services"] valueForKey:@"service_name"]];
                CGRect idealFrame2 = [strSpecialist2 boundingRectWithSize:frameSize
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{ NSFontAttributeName:font }
                                                                  context:nil];
                if (idealFrame2.size.width+20+idealFrame1.size.width + 20<frameSize.width)
                {
                    lblSpl.frame =CGRectMake(x, y, idealFrame1.size.width + 20, 18);
                    lblSpl.backgroundColor=[self sendingWords:chWords atIndexPath:indexPath];
                    
                    x=x+idealFrame1.size.width +30;
                }else
                {
                    lblSpl.frame =CGRectMake(x, y, frameSize.width-90, 18);
                    lblSpl.backgroundColor= [self sendingWords:chWords atIndexPath:indexPath];
                    
                    
                    UILabel * lblSpl1=[[UILabel alloc]initWithFrame:CGRectMake(frameSize.width-80, y, 20, 18)];
                    lblSpl1.text=[NSString stringWithFormat:@"+%lu",[spelArray count]-chWords];
                    lblSpl1.textColor=[UIColor whiteColor];
                    lblSpl1.font =[UIFont systemFontOfSize:12];
                    lblSpl1.layer.cornerRadius=8;
                    lblSpl1.clipsToBounds=YES;
                    lblSpl1.textAlignment=NSTextAlignmentCenter;
                    lblSpl1.backgroundColor=[UIColor colorWithRed:255/255.0 green:172/255.0 blue:95/255.0 alpha:1.0];
                    
                    CGRect idealFrame3 = [lblSpl1.text boundingRectWithSize:frameSize
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{ NSFontAttributeName:font }
                                                                    context:nil];
                    
                    lblSpl1.frame =CGRectMake(x+ lblSpl.frame.size.width+10, y, idealFrame3.size.width + 20, 18);
                    [viewBackground addSubview:lblSpl1];
                    lblSpl1.backgroundColor=[UIColor colorWithRed:164/255.0 green:195/255.0 blue:68/255.0 alpha:1.0];
                    break;
                    
                }
            }else
            {
                lblSpl.frame =CGRectMake(x, y, idealFrame1.size.width + 20, 18);
                x=x+idealFrame1.size.width +30;
                lblSpl.backgroundColor=[self sendingWords:chWords atIndexPath:indexPath];
            }
            
        }else
        {
            if (x+idealFrame1.size.width+20>frameSize.width)
            {
                if (chWords==0)
                {
                    chWords++;
                    
                    lblSpl.frame =CGRectMake(x, y, frameSize.width- 60, 18);
                    lblSpl.lineBreakMode=NSLineBreakByTruncatingTail;
                    lblSpl.backgroundColor=[self sendingWords:chWords atIndexPath:indexPath];
                    
                    
                    UILabel * lblSpl1=[[UILabel alloc]initWithFrame:CGRectMake(frameSize.width-80, y, 20, 18)];
                    lblSpl1.text=[NSString stringWithFormat:@"+%lu",[spelArray count]-chWords];
                    lblSpl1.textColor=[UIColor whiteColor];
                    lblSpl1.font =[UIFont systemFontOfSize:12];
                    lblSpl1.layer.cornerRadius=8;
                    lblSpl1.clipsToBounds=YES;
                    lblSpl1.textAlignment=NSTextAlignmentCenter;
                    lblSpl1.backgroundColor=[UIColor colorWithRed:255/255.0 green:172/255.0 blue:95/255.0 alpha:1.0];
                    
                    CGRect idealFrame3 = [lblSpl1.text boundingRectWithSize:frameSize
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{ NSFontAttributeName:font }
                                                                    context:nil];
                    
                    lblSpl1.frame =CGRectMake(x+ lblSpl.frame.size.width+10, y, idealFrame3.size.width + 20, 18);
                    [viewBackground addSubview:lblSpl1];
                    lblSpl1.backgroundColor=[UIColor colorWithRed:164/255.0 green:195/255.0 blue:68/255.0 alpha:1.0];
                    break;
                    
                }else
                {
                    chWords++;
                    
                    lblSpl.frame =CGRectMake(x, y, idealFrame1.size.width+20, 16);
                    lblSpl.backgroundColor=[self sendingWords:chWords atIndexPath:indexPath];
                    
                    UILabel * lblSpl1=[[UILabel alloc]initWithFrame:CGRectMake(frameSize.width-80, y, 20, 18)];
                    lblSpl1.text=[NSString stringWithFormat:@"+%lu",[spelArray count]-chWords];
                    lblSpl1.textColor=[UIColor whiteColor];
                    lblSpl1.font =[UIFont systemFontOfSize:12];
                    lblSpl1.layer.cornerRadius=8;
                    lblSpl1.clipsToBounds=YES;
                    lblSpl1.textAlignment=NSTextAlignmentCenter;
                    lblSpl1.backgroundColor=[UIColor colorWithRed:255/255.0 green:172/255.0 blue:95/255.0 alpha:1.0];
                    
                    CGRect idealFrame3 = [lblSpl1.text boundingRectWithSize:frameSize
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{ NSFontAttributeName:font }
                                                                    context:nil];
                    
                    lblSpl1.frame =CGRectMake(x+ lblSpl.frame.size.width+10, y, idealFrame3.size.width + 20, 18);
                    [viewBackground addSubview:lblSpl1];
                    lblSpl1.backgroundColor=[UIColor colorWithRed:164/255.0 green:195/255.0 blue:68/255.0 alpha:1.0];
                    break;
                    
                }
            }else
            {
                chWords++;
                
                lblSpl.frame =CGRectMake(x, y, idealFrame1.size.width+20, 18);
                lblSpl.backgroundColor=[self sendingWords:chWords atIndexPath:indexPath];
                
                UILabel * lblSpl1=[[UILabel alloc]initWithFrame:CGRectMake(frameSize.width-80, y, 20, 18)];
                lblSpl1.text=[NSString stringWithFormat:@"+%lu",[spelArray count]-chWords];
                lblSpl1.textColor=[UIColor whiteColor];
                lblSpl1.font =[UIFont systemFontOfSize:12];
                lblSpl1.layer.cornerRadius=8;
                lblSpl1.clipsToBounds=YES;
                lblSpl1.textAlignment=NSTextAlignmentCenter;
                lblSpl1.backgroundColor=[UIColor colorWithRed:255/255.0 green:172/255.0 blue:95/255.0 alpha:1.0];
                
                CGRect idealFrame3 = [lblSpl1.text boundingRectWithSize:frameSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{ NSFontAttributeName:font }
                                                                context:nil];
                
                lblSpl1.frame =CGRectMake(x+ lblSpl.frame.size.width+10, y, idealFrame3.size.width + 20, 18);
                [viewBackground addSubview:lblSpl1];
                lblSpl1.backgroundColor=[UIColor colorWithRed:164/255.0 green:195/255.0 blue:68/255.0 alpha:1.0];
                break;
                
            }
        }
        
        
    }
    
    lblCastPerHour=[[UILabel alloc]initWithFrame:CGRectMake(80, 55+12, 150, 18)];
    lblCastPerHour.font=[UIFont boldSystemFontOfSize:13.05f];
    lblCastPerHour.textColor = globelColor;
    lblCastPerHour.text=@"";
    [self.contentView addSubview:lblCastPerHour];
}
-(UIColor *)sendingWords:(int)wordscount atIndexPath :(NSIndexPath *)indexPath
{
    UIColor *randColor;
    if ((int)wordscount == 0)
    {
        randColor = [UIColor colorWithRed:88.0f/255.0f green:86.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    }
    else if ((int)wordscount == 4)
    {
        randColor = [UIColor colorWithRed:142/255.0f green:142/255.0f blue:147/255.0f alpha:1.0f];
    }
    else if ((int)wordscount == 3)
    {
        randColor = [UIColor colorWithRed:26/255.0f green:213/255.0f blue:154/255.0f alpha:1.0f];;
    }
    else if ( (int)wordscount == 2)
    {
        randColor = [UIColor colorWithRed:221/255.0f green:120/255.0f blue:252/255.0f alpha:1.0f];
    }
    else if ((int)wordscount == 1)
    {
        if (indexPath.row % 1)
        {
            randColor = [UIColor colorWithRed:254/255.0f green:100/255.0f blue:143/255.0f alpha:1.0f];
        }
        else if (indexPath.row %2)
        {
            randColor = [UIColor colorWithRed:88.0f/255.0f green:86.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
        }
        else
        {
            randColor = [UIColor colorWithRed:254/255.0f green:100/255.0f blue:143/255.0f alpha:1.0f];
        }
        
    }else
    {
        randColor = [UIColor colorWithRed:88.0f/255.0f green:86.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    }
    return randColor;
}


//randColor = [UIColor colorWithRed:142/255.0f green:142/255.0f blue:147/255.0f alpha:1.0f];
//randColor = [UIColor colorWithRed:214/255.0f green:145/255.0f blue:253/255.0f alpha:1.0f];
//randColor = [UIColor colorWithRed:153/255.0f green:102/255.0f blue:204/255.0f alpha:1.0f];
@end
