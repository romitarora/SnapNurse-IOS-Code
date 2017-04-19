//
//  RateVc.m
//  Snuzo App
//
//  Created by Oneclick IT on 10/20/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import "RateVc.h"

@interface RateVc ()

@end


@implementation RateVc
@synthesize strHotelImage,strId;

-(void)viewWillAppear:(BOOL)animated
{
    
    if (isRate) {
        Count=0;
        serviceCount = 0;
        [self getReview];
    }
    else
    {
        
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    strisfromAnimity=@"YES";
}

- (void)viewDidLoad {
    Count=0;
    serviceCount = 0;
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.translucent=NO;
    
    
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=back;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor blueColor];
    self.navigationItem.title=@"Reviews";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
    
   UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    [self.view addSubview:bg];
    
    imghotel=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,210)];
    imghotel.contentMode = UIViewContentModeScaleAspectFit;
    imghotel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:imghotel];
    
    imghotel.image=[UIImage imageNamed:@"iTunesArtwork@1x"];
    if (![strHotelImage isEqual:[NSNull null]])
    {
            if ([strHotelImage isEqualToString:@"NA"])
            {
            }
            else
            {
                imghotel.imageURL = [NSURL URLWithString:strHotelImage];
            }
        
    }
    
    if (IS_IPHONE_5)
    {
        tblReviews=[[UITableView alloc]initWithFrame:CGRectMake(0,210, 320, (568-210)-65) style:UITableViewStyleGrouped];
    }
    else if (IS_IPHONE_6)
    {
         tblReviews=[[UITableView alloc]initWithFrame:CGRectMake(0,210, 375, (667-210)-65) style:UITableViewStyleGrouped];
    }
    else if (IS_IPHONE_6plus)
    {
         tblReviews=[[UITableView alloc]initWithFrame:CGRectMake(0,210, 414, (736-210)-65) style:UITableViewStyleGrouped];
    }
    else
    {
        tblReviews=[[UITableView alloc]initWithFrame:CGRectMake(0,210, 320, (480-210)-65) style:UITableViewStyleGrouped];
    }
    tblReviews.delegate=self;
    tblReviews.dataSource=self;
    tblReviews.backgroundColor=[UIColor whiteColor];
    tblReviews.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tblReviews];

    [self getReview];
}
#pragma mark ---Back btn Click

-(void)BackBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UITableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        if ( IsfoundReviews==YES)
        {
            imgHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
            imgHeaderView.image = [UIImage imageNamed:@""];
            imgHeaderView.backgroundColor=[UIColor whiteColor];
            imgHeaderView.userInteractionEnabled=YES;
            UILabel *lblTitleReview=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 25)];
            lblTitleReview.textAlignment=NSTextAlignmentCenter;
            lblTitleReview.text=@"No Reviews found";
            lblTitleReview.textColor=[UIColor blackColor];
            [lblTitleReview setFont:[UIFont systemFontOfSize:15.0]];
            btnHeader=[[UIButton alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
            btnHeader.backgroundColor=[UIColor whiteColor];
            [btnHeader addTarget:self action:@selector(btReview) forControlEvents:UIControlEventTouchUpInside];
            [btnHeader setTitle:@"   Reviews" forState:UIControlStateNormal];
            [btnHeader.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [btnHeader setTitleColor:globelColor forState:UIControlStateNormal];
            btnHeader.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            UIImageView *editImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 10, 20, 20)];
            editImage.image=[UIImage imageNamed:@"review"];
            editImage.backgroundColor=[UIColor clearColor];
            [btnHeader addSubview:editImage];
            [imgHeaderView addSubview:lblTitleReview];
            
            UILabel * lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, imgHeaderView.frame.size.width, 1)];
            lineLbl.backgroundColor = [UIColor lightGrayColor];
            [btnHeader addSubview:lineLbl];
            
            [imgHeaderView addSubview:btnHeader];
        }
        else
        {
            imgHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
            imgHeaderView.backgroundColor=[UIColor whiteColor];
            imgHeaderView.image = [UIImage imageNamed:@""];
            imgHeaderView.userInteractionEnabled=YES;
                btnHeader=[[UIButton alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
                btnHeader.backgroundColor=[UIColor whiteColor];
                [btnHeader addTarget:self action:@selector(btReview) forControlEvents:UIControlEventTouchUpInside];
                [btnHeader setTitle:@"   Reviews" forState:UIControlStateNormal];
                [btnHeader.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [btnHeader setTitleColor:globelColor forState:UIControlStateNormal];
            btnHeader.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            UIImageView *editImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 10, 20, 20)];
            editImage.image=[UIImage imageNamed:@"review"];
            editImage.backgroundColor=[UIColor clearColor];
            [btnHeader addSubview:editImage];
            
            UILabel * lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, imgHeaderView.frame.size.width, 1)];
            lineLbl.backgroundColor = [UIColor lightGrayColor];
            [btnHeader addSubview:lineLbl];
            
            [imgHeaderView addSubview:btnHeader];
            
            if (arrayReviews.count>0)
            {
                int xx=15;
                int yy=45;
                UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xx, yy, 10, 10)];
                imageView.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView];
                UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(xx+15, yy, 10, 10)];
                imageView1.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView1];
                UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(xx+30,yy, 10, 10)];
                imageView2.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView2];
                UIImageView* imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(xx+45, yy, 10, 10)];
                imageView3.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView3];
                UIImageView* imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(xx+60, yy, 10, 10)];
                imageView4.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView4];
                
                yy=yy+15;
                UIImageView* imageView5=[[UIImageView alloc]initWithFrame:CGRectMake(xx, yy, 10, 10)];
                imageView5.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView5];
                UIImageView* imageView6=[[UIImageView alloc]initWithFrame:CGRectMake(xx+15, yy, 10, 10)];
                imageView6.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView6];
                UIImageView* imageView7=[[UIImageView alloc]initWithFrame:CGRectMake(xx+30,yy, 10, 10)];
                imageView7.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView7];
                UIImageView* imageView8=[[UIImageView alloc]initWithFrame:CGRectMake(xx+45, yy, 10, 10)];
                imageView8.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView8];
                UIImageView* imageView9=[[UIImageView alloc]initWithFrame:CGRectMake(xx+60, yy, 10, 10)];
                imageView9.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView9];
                
                yy=yy+15;
                UIImageView* imageView10=[[UIImageView alloc]initWithFrame:CGRectMake(xx, yy, 10, 10)];
                imageView10.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView10];
                UIImageView* imageView11=[[UIImageView alloc]initWithFrame:CGRectMake(xx+15, yy, 10, 10)];
                imageView11.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView11];
                UIImageView* imageView12=[[UIImageView alloc]initWithFrame:CGRectMake(xx+30,yy, 10, 10)];
                imageView12.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView12];
                UIImageView* imageView13=[[UIImageView alloc]initWithFrame:CGRectMake(xx+45, yy, 10, 10)];
                imageView13.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView13];
                UIImageView* imageView14=[[UIImageView alloc]initWithFrame:CGRectMake(xx+60, yy, 10, 10)];
                imageView14.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView14];
                yy=yy+15;
                UIImageView* imageView16=[[UIImageView alloc]initWithFrame:CGRectMake(xx, yy, 10, 10)];
                imageView16.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView16];
                UIImageView* imageView17=[[UIImageView alloc]initWithFrame:CGRectMake(xx+15, yy, 10, 10)];
                imageView17.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView17];
                UIImageView* imageView18=[[UIImageView alloc]initWithFrame:CGRectMake(xx+30,yy, 10, 10)];
                imageView18.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView18];
                UIImageView* imageView19=[[UIImageView alloc]initWithFrame:CGRectMake(xx+45, yy, 10, 10)];
                imageView19.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView19];
                UIImageView* imageView20=[[UIImageView alloc]initWithFrame:CGRectMake(xx+60, yy, 10, 10)];
                imageView20.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView20];
                
                yy=yy+15;
                UIImageView* imageView21=[[UIImageView alloc]initWithFrame:CGRectMake(xx, yy, 10, 10)];
                imageView21.image=[UIImage imageNamed:@"selected-heart"];
                [imgHeaderView addSubview:imageView21];
                UIImageView* imageView22=[[UIImageView alloc]initWithFrame:CGRectMake(xx+15, yy, 10, 10)];
                imageView22.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView22];
                UIImageView* imageView23=[[UIImageView alloc]initWithFrame:CGRectMake(xx+30,yy, 10, 10)];
                imageView23.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView23];
                UIImageView* imageView24=[[UIImageView alloc]initWithFrame:CGRectMake(xx+45, yy, 10, 10)];
                imageView24.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView24];
                UIImageView* imageView25=[[UIImageView alloc]initWithFrame:CGRectMake(xx+60, yy, 10, 10)];
                imageView25.image=[UIImage imageNamed:@"unselected-star"];
                [imgHeaderView addSubview:imageView25];
                
                
                lblFiveSatr=[[UILabel alloc]initWithFrame:CGRectMake(100,46, 50, 10)];
                lblFiveSatr.textColor=[UIColor darkGrayColor];
                NSString *str3=[NSString stringWithFormat:@"%@",[arrayRating valueForKey:@"five_ratings"]];
                [lblFiveSatr setFont:[UIFont systemFontOfSize:10]];
                lblFiveSatr.text=[NSString stringWithFormat:@"%@ User",str3];
                [imgHeaderView addSubview:lblFiveSatr];
                
                lblFourSatr=[[UILabel alloc]initWithFrame:CGRectMake(100,62,50, 10)];
                NSString *str4=[NSString stringWithFormat:@"%@",[arrayRating valueForKey:@"four_ratings"]];
                lblFourSatr.textColor=[UIColor darkGrayColor];
                
//                NSString *str4=@"100";

                [lblFourSatr setFont:[UIFont systemFontOfSize:10]];
                lblFourSatr.text=[NSString stringWithFormat:@"%@ User",str4];
                lblFourSatr.textColor=[UIColor darkGrayColor]  ;
                [imgHeaderView addSubview:lblFourSatr];
                
                lblThirdSatr=[[UILabel alloc]initWithFrame:CGRectMake(100,77, 50, 10)];
                NSString *str5=[NSString stringWithFormat:@"%@",[arrayRating valueForKey:@"three_ratings"]];
                [lblThirdSatr setFont:[UIFont systemFontOfSize:10]];
                lblThirdSatr.textColor=[UIColor darkGrayColor];
                lblThirdSatr.text=[NSString stringWithFormat:@"%@ User",str5];
                [imgHeaderView addSubview:lblThirdSatr];
                
                lblsecondSatr=[[UILabel alloc]initWithFrame:CGRectMake(100,92, 50,10)];
                NSString *str6=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[arrayRating valueForKey:@"two_ratings"]]];
                [lblsecondSatr setFont:[UIFont systemFontOfSize:10]];
                lblsecondSatr.text=[NSString stringWithFormat:@"%@ User",str6];
                lblsecondSatr.textColor=[UIColor darkGrayColor];
                [imgHeaderView addSubview:lblsecondSatr];
                
                lblFirstSatr=[[UILabel alloc]initWithFrame:CGRectMake(100,108, 50, 10)];
                NSString *str7=[NSString stringWithFormat:@"%@",[arrayRating valueForKey:@"one_ratings"]];
                [lblFirstSatr setFont:[UIFont systemFontOfSize:10]];
                lblFirstSatr.text=[NSString stringWithFormat:@"%@ User",str7];
                lblFirstSatr.textColor=[UIColor darkGrayColor];
                [imgHeaderView addSubview:lblFirstSatr];
                
                if (IS_IPHONE_6)
                {
                    lblFiveSatr.frame = CGRectMake(130,46, 50, 10);
                    lblFourSatr.frame = CGRectMake(130,62, 50, 10);
                    lblThirdSatr.frame = CGRectMake(130,77, 50, 10);
                    lblsecondSatr.frame = CGRectMake(130,92, 50, 10);
                    lblFirstSatr.frame = CGRectMake(130,108, 50, 10);
                }
                else if (IS_IPHONE_6plus)
                {
                    lblFiveSatr.frame = CGRectMake(130,46, 50, 10);
                    lblFourSatr.frame = CGRectMake(130,62, 50, 10);
                    lblThirdSatr.frame = CGRectMake(130,77, 50, 10);
                    lblsecondSatr.frame = CGRectMake(130,92, 50, 10);
                    lblFirstSatr.frame = CGRectMake(130,108, 50, 10);
                }
                
                NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:str3, str4, str5, str6, str7, nil];
//                NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@"5", @"4", @"2",@"1",@"3", nil];

                int max = [[values valueForKeyPath:@"@max.intValue"] intValue];
                if (max>100) {
                    UILabel * lblrating1=[[UILabel alloc]initWithFrame:CGRectMake(134, 50, 200, 5)];
                    lblrating1.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    lblrating1.layer.cornerRadius=2.0;
                    
                    [imgHeaderView addSubview:lblrating1];
                    
                    UILabel * lblrating2=[[UILabel alloc]initWithFrame:CGRectMake(134, 50+15, 200-30, 5)];
                    lblrating2.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating2];
                    
                    UILabel * lblrating3=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+30, 200-30, 5)];
                    lblrating3.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating3];
                    
                    UILabel * lblrating4=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+45, 200-30, 5)];
                    lblrating4.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating4];
                    
                    
                    UILabel * lblrating5=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+60, 200-30, 5)];
                    lblrating5.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating5];
                    
                    if (IS_IPHONE_6)
                    {
                        lblrating1.frame =CGRectMake(134+50, 50, 200-60, 5);
                        lblrating2.frame =CGRectMake(134+50, 50+15, 200-60, 5);
                        lblrating3.frame =CGRectMake(135+50, 50+30, 200-60, 5);
                        lblrating4.frame =CGRectMake(135+50, 50+45, 200-60, 5);
                        lblrating5.frame =CGRectMake(135+50, 50+60, 200-60, 5);
                    }
                    else if (IS_IPHONE_6plus)
                    {
                        lblrating1.frame =CGRectMake(134+50, 50, 200-60, 5);
                        lblrating2.frame =CGRectMake(134+50, 50+15, 200-60, 5);
                        lblrating3.frame =CGRectMake(135+50, 50+30, 200-60, 5);
                        lblrating4.frame =CGRectMake(135+50, 50+45, 200-60, 5);
                        lblrating5.frame =CGRectMake(135+50, 50+60, 200-60, 5);
                    }
                }
                else
                {
                    UILabel * lblrating1=[[UILabel alloc]initWithFrame:CGRectMake(135, 50, 200-30, 5)];
                    lblrating1.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    
                    [imgHeaderView addSubview:lblrating1];
                    UILabel * lblrating2=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+15, 200-30, 5)];
                    lblrating2.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating2];
                    
                    UILabel * lblrating3=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+30, 200-30, 5)];
                    lblrating3.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating3];
                    
                    UILabel * lblrating4=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+45, 200-30, 5)];
                    lblrating4.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating4];
                    
                    UILabel * lblrating5=[[UILabel alloc]initWithFrame:CGRectMake(135, 50+60, 200-30, 5)];
                    lblrating5.backgroundColor=[UIColor colorWithHexString:@"d2d2d2"];
                    [imgHeaderView addSubview:lblrating5];
                    
                    if (IS_IPHONE_6)
                    {
                        lblrating1.frame =CGRectMake(135+50, 50, 200-60, 5);
                        lblrating2.frame =CGRectMake(135+50, 50+15, 200-60, 5);
                        lblrating3.frame =CGRectMake(135+50, 50+30, 200-60, 5);
                        lblrating4.frame =CGRectMake(135+50, 50+45, 200-60, 5);
                        lblrating5.frame =CGRectMake(135+50, 50+60, 200-60, 5);
                    }
                    else if (IS_IPHONE_6plus)
                    {
                        lblrating1.frame =CGRectMake(135+50, 50, 200-60, 5);
                        lblrating2.frame =CGRectMake(135+50, 50+15, 200-60, 5);
                        lblrating3.frame =CGRectMake(135+50, 50+30, 200-60, 5);
                        lblrating4.frame =CGRectMake(135+50, 50+45, 200-60, 5);
                        lblrating5.frame =CGRectMake(135+50, 50+60, 200-60, 5);
                    }
                    
                }
                //  NSLog( @"rating values123   %@",arrayRating);
                
                NSMutableArray *textIndicators = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
                CGRect frame;
                if (max>100)
                {
                    frame = CGRectMake(60,50,240, 100);
                    if (IS_IPHONE_6)
                    {
                        frame = CGRectMake(110,50,240, 100);
                    }
                    else if (IS_IPHONE_6plus)
                    {
                        frame = CGRectMake(110,50,240, 100);
                    }
                    
                }
                else
                {
                    frame = CGRectMake(60,50,240, 100);
                    if (IS_IPHONE_6)
                    {
                        frame = CGRectMake(110,50,240, 100);
                    }
                    else if (IS_IPHONE_6plus)
                    {
                        frame = CGRectMake(110,50,240, 100);
                    }
                }
                JXBarChartView *barChartView = [[JXBarChartView alloc] initWithFrame:frame
                                                                          startPoint:CGPointMake(0,0)
                                                                              values:values maxValue:max
                                                                      textIndicators:nil
                                                                           textColor:globelColor
                                                                           barHeight:5
                                                                         barMaxWidth:50
                                                                            gradient:nil];
                
                [imgHeaderView addSubview:barChartView];
                lblType=[[UILabel alloc]init];
                lblType.frame=CGRectMake(35, yy+15, 150, 30);
                lblType.text=[NSString stringWithFormat:@""];
                
                if (arrayRating.count>0)
                {
                    lblType.text=[NSString stringWithFormat:@"%@",[arrayRating valueForKey:@"average_ratings"]];
                }
                else
                {
                    lblType.text=[NSString stringWithFormat:@"4.5"];
                }
                lblType.textColor=globelColor;
                lblType.font=[UIFont systemFontOfSize:22.0];
                [imgHeaderView addSubview:lblType];
                
                lblTotalReviews=[[UILabel alloc]init];
                lblTotalReviews.frame=CGRectMake(xx+85,yy+20, 200, 10);
                if (IS_IPHONE_6)
                {
                    lblTotalReviews.frame=CGRectMake(xx+85+30,yy+25, 200, 10);
                }
                else if (IS_IPHONE_6plus)
                {
                     lblTotalReviews.frame=CGRectMake(xx+85+30,yy+25, 200, 10);
                }
                lblTotalReviews.text=[NSString stringWithFormat:@""];
                //lblreviews=nil;
                if (arrayRating.count>0)
                {
                    lblTotalReviews.text=[NSString stringWithFormat:@"%@ reviews",[arrayRating valueForKey:@"no_of_total_ratings"]];
                }
                else
                {
                    lblTotalReviews.text=[NSString stringWithFormat:@"10 reviews"];
                }
                
                [lblTotalReviews setFont:[UIFont systemFontOfSize:10.0]];
                lblTotalReviews.textColor=[UIColor darkGrayColor];
                [imgHeaderView addSubview:lblTotalReviews];
                
            }
            
        }
    
        return imgHeaderView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return arrayReviews.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        int textHeight;
        
        NSString *cellID = nil;
        Wallet *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[Wallet alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        else
        {
            // return cell;
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor=[UIColor clearColor];
        
        
        if (IsfoundReviews==YES) {
            
        }
        else
        {
            
            if (arrayReviews.count>0) {
            
                
                cell.imgselect.frame=CGRectMake(20, 10, 56,56);
                [cell.imgselect setImage:[UIImage imageNamed:@"profile_1.jpg" ]];
                
                NSString *strurl;
                
                if ([[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"photo"]==nil||[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"photo"]==[NSNull null])
                {
                    
                    strurl=[NSString stringWithFormat:@"%@no.jpg",[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"path"]];
                }
                else
                {
                    if ([[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"photo"]==[NSNull null])
                    {
                        
                        strurl=[NSString stringWithFormat:@"%@no.jpg",[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"path"]];
                    }
                    else
                    {
                        strurl=[NSString stringWithFormat:@"%@%@",[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"0"]valueForKey:@"path"],[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"photo"]];
                        
                    }
                    
                }
                
                
                cell.imgselect.layer.cornerRadius=28;
                cell.imgselect.layer.borderColor=[UIColor clearColor].CGColor;
                cell.imgselect.layer.borderWidth=1;
                
                /*
                 
                 customers =                 {
                 email = "<null>";
                 "first_name" = "<null>";
                 "last_name" = "<null>";
                 photo = "<null>";
                 */
                
            UILabel * lblCustomerName=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, 210,15)];
            NSString *strUserName=@"Test";
            
            [lblCustomerName setFont:[UIFont systemFontOfSize:15.0]];
            
            
            NSString *strCreatedDate=[NSString stringWithFormat:@"%@",[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"hotel_reviews"]valueForKey:@"created_date"]];
            
          
                NSArray * arr = [strCreatedDate componentsSeparatedByString:@" "];
                
                
                strCreatedDate=[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
                
            
                //  strCreatedDate=[strCreatedDate substringToIndex:10];
//                NSString *strRevirwDetails=[NSString stringWithFormat:@"By %@ ",strUserName];

                NSString *strRevirwDetails;
                
                
                if ([[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"first_name"]==nil||[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"first_name"]==[NSNull null])
                {
                    strRevirwDetails=@"No Name";

                }
                else
                {
                    strRevirwDetails=[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"first_name"];

                }
                [lblCustomerName setFont:[UIFont systemFontOfSize:15.0]];
                lblCustomerName.textColor=[UIColor blackColor];
                lblCustomerName.text=strRevirwDetails;
                [cell.contentView addSubview:lblCustomerName];
                
                UILabel * lblTime=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 75 ,85, 10)];
                lblTime.text=strCreatedDate;
                lblTime.textAlignment=NSTextAlignmentRight;
                lblTime.textColor=[UIColor grayColor];
                [lblTime setFont:[UIFont systemFontOfSize:10.0]];
                [cell.contentView addSubview:lblTime];
                
//                cell.imgselect.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"photo"]]];
            cell.imgselect.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",strurl]];
            
            
                cell.imgselect.clipsToBounds=YES;
                cell.imgselect.contentMode=UIViewContentModeScaleAspectFit;
                NSString *strText=[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"hotel_reviews"]valueForKey:@"comments"];
            //[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"comments"];
                CGSize boundingSize11 = CGSizeMake(200,14000);
                CGSize itemTextSize11 = [strText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:boundingSize11 lineBreakMode:NSLineBreakByWordWrapping];
                textHeight=itemTextSize11.height+5;
                cell.lblname.frame=CGRectMake(95, 25, 200, 50);
                cell.lblname.lineBreakMode=NSLineBreakByWordWrapping;
                [cell.lblname setFont:[UIFont systemFontOfSize:13.0]];
                cell.lblname.numberOfLines=2+textHeight/13;
                cell.lblname.textColor=[UIColor darkGrayColor];
                cell.lblname.text=strText;
                cell.lbExpirydate.textColor=[UIColor blackColor];
//                NSString *strRating=[NSString stringWithFormat:@"%@",[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"rating"]];
            NSString *strRating=[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"hotel_reviews"]valueForKey:@"ratings"];
//ratings
                if ([strRating isEqualToString:@"1"])
                {
                    int yy=75;
                    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, yy, 10, 10)];
                    imageView.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView];
                    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(31, yy, 10, 10)];
                    imageView1.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView1];
                    UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(42,yy, 10, 10)];
                    imageView2.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView2];
                    UIImageView* imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(53, yy, 10, 10)];
                    imageView3.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView3];
                    UIImageView* imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(64, yy, 10, 10)];
                    imageView4.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView4];
                }else  if ([strRating isEqualToString:@"2"])
                {
                    int yy=75;
                    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, yy, 10, 10)];
                    imageView.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView];
                    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(31, yy, 10, 10)];
                    imageView1.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView1];
                    UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(42,yy, 10, 10)];
                    imageView2.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView2];
                    UIImageView* imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(53, yy, 10, 10)];
                    imageView3.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView3];
                    UIImageView* imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(64, yy, 10, 10)];
                    imageView4.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView4];
                }else  if ([strRating isEqualToString:@"3"]) {
                    int yy= 75;
                    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, yy, 10, 10)];
                    imageView.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView];
                    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(31, yy, 10, 10)];
                    imageView1.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView1];
                    UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(42,yy, 10, 10)];
                    imageView2.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView2];
                    UIImageView* imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(53, yy, 10, 10)];
                    imageView3.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView3];
                    UIImageView* imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(64, yy, 10, 10)];
                    imageView4.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView4];
                    
                }else  if ([strRating isEqualToString:@"4"]) {
                    int yy=75;
                    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, yy, 10, 10)];
                    imageView.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView];
                    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(31, yy, 10, 10)];
                    imageView1.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView1];
                    UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(42,yy, 10, 10)];
                    imageView2.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView2];
                    UIImageView* imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(53, yy, 10, 10)];
                    imageView3.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView3];
                    UIImageView* imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(64, yy, 10, 10)];
                    imageView4.image=[UIImage imageNamed:@"unselected-star"];
                    [cell.contentView addSubview:imageView4];
                }else  if ([strRating isEqualToString:@"5"]) {
                    int yy =75;
                    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, yy, 10, 10)];
                    imageView.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView];
                    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(31, yy, 10, 10)];
                    imageView1.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView1];
                    UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(42,yy, 10, 10)];
                    imageView2.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView2];
                    UIImageView* imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(53, yy, 10, 10)];
                    imageView3.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView3];
                    UIImageView* imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(64, yy, 10, 10)];
                    imageView4.image=[UIImage imageNamed:@"selected-heart"];
                    [cell.contentView addSubview:imageView4];
                }
                else
                {
                        cell.lbExpirydate.text=@"";
                }
                
            }
        }
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddRate *rate=[[AddRate alloc]init];
    rate.strHotelID=strId;
    rate.ISEDIT=@"YES";
    rate.strReview=[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"hotel_reviews"]valueForKey:@"comments"];
    rate.NoofReview=[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"hotel_reviews"]valueForKey:@"ratings"];
    rate.strUserName=[[[arrayReviews objectAtIndex:indexPath.row]valueForKey:@"customers"]valueForKey:@"first_name"];
    
    [self.navigationController pushViewController:rate animated:YES];
}

#pragma mark --- Edit Button Clicked

-(void)btReview
{
    
    NSString *customerId;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]isEqualToString:@"YES"])
    {
        customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id" ];
    }
    else
    {
        customerId=Nil;
    }
    if (customerId==nil||customerId.length==0)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Login !" message:@"Please login first." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        alert.tag=0;
        [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
         {
             [alertView hideWithCompletionBlock:
              ^{
                    LoginVC *SignUp=[[LoginVC alloc]init];
                    SignUp.strIsfromRate=@"YES";
                    [self.navigationController pushViewController:SignUp animated:YES];
              }];
         }];
         [alert showWithAnimation:URBalertAnimationType];;
    }
    else{

   
         NSLog(@"clicked");
        AddRate *rate=[[AddRate alloc]init];
        rate.strHotelID=strId;
        [self.navigationController pushViewController:rate animated:YES];
    }
}

#pragma mark ____WEBservices

-(void)getReview
{
    serviceCount = serviceCount + 1;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:strId forKey:@"hotel_id"];
    [dict setValue:[NSString stringWithFormat:@"%d",Count] forKey:@"start"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"GetReview";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/getReviews" withParameters:dict];
    
}



#pragma mark---- url manager delegates


- (void)onResult:(NSDictionary *)result
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
     serviceCount = 0;
     NSLog(@"The result is...%@", result);
    if([[result valueForKey:@"commandName"] isEqualToString:@"GetReview"])
    {
        
        
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            IsfoundReviews =NO;
           
            if (Count==0)
            {
                arrayReviews=nil;
                arrayReviews=[[NSMutableArray alloc]init];
            }
            NSMutableArray*   tempFeedsArray=[[NSMutableArray alloc]init];
            tempFeedsArray=[[[result valueForKey:@"result"]valueForKey:@"data"]mutableCopy];
            
            [arrayReviews addObjectsFromArray:tempFeedsArray ];
            [tblReviews reloadData];
            
            arrayRating=nil;
            
            arrayRating=[[NSMutableArray alloc]init];
            arrayRating=[[[result valueForKey:@"result"]valueForKey:@"review_data"]mutableCopy];
            
            if ([tempFeedsArray count] >=
                10)
            {
                
                pullToRefreshManager_Images =[[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:tblReviews withClient:self];
                [pullToRefreshManager_Images tableViewReloadFinished];
                [pullToRefreshManager_Images setPullToRefreshViewVisible:YES];
                
            }
            else
            {
                [pullToRefreshManager_Images tableViewReloadFinished];
                [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
            }

            
        }
        else
        {
            if (Count==0)
            {
                IsfoundReviews =YES;

            }
            [pullToRefreshManager_Images tableViewReloadFinished];
            [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
            [tblReviews reloadData];
            
            
        }
        
        
    }
}
- (void)onError:(NSError *)error
{
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    [pullToRefreshManager_Images tableViewReleased];

        //    [app hudEndProcessMethod];
         NSLog(@"Rate view The error is...%@", error);
        NSInteger ancode = [error code];
        
        if (ancode == -1009)
        {
            
            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:@"There is no network connectivity. This application requires a network connection." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
            
             [alert showWithAnimation:URBalertAnimationType];;
            
        }
        else if(ancode == -1001)
        {
            if (isError == NO)
            {
                isError = YES;
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:@"The request time out." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                [alert setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
                    [alertView hideWithCompletionBlock:^{
                        isError = NO;
                    }];
                }];
                
                [alert showWithAnimation:URBalertAnimationType];;
                
            }
            else
            {
                
            }

        }
        else if(ancode == -1005)
        {
            
        }
        else
        {
//            URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//            
//             [alert showWithAnimation:URBalertAnimationType];;
        }
        
        
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"GetReview"])
        {
            if (serviceCount >=3)
            {
                serviceCount = 0;
                URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"" message:@"Something went wrong please try again later." cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
                
                [alert showWithAnimation:URBalertAnimationType];;
            }
            else
            {
                [self getReview];
                
            }
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pullToRefreshManager_Images==nil)
    {
        
    }
    else
    {
        [pullToRefreshManager_Images tableViewReleased];
    }
}


#pragma mark MNMBottomPullToRefreshManagerClient



- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5f];
    
    
    
}





#pragma mark MNMBottomPullToRefreshManagerClient


-(void)loadTable
{
     NSLog(@"Load");
    
    Count=Count+10;
    [self getReview];
    
    
    //    if ([hotellistarray count] == 10)
    //    {
    //        [pullToRefreshManager_Images tableViewReloadFinished];
    //        [pullToRefreshManager_Images setPullToRefreshViewVisible:YES];
    //    }else{
    //
    //        [pullToRefreshManager_Images tableViewReloadFinished];
    //        [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
    //    }
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
