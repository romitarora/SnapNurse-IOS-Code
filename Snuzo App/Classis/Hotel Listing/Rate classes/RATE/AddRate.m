//
//  AddRate.m
//  Snuzo App
//
//  Created by Oneclick IT on 10/21/15.
//  Copyright © 2015 Oneclick IT. All rights reserved.
//

#import "AddRate.h"

@interface AddRate ()
{
    UIButton * btn1Star;
    UIButton * btn2Star;
    UIButton * btn3Star;
    UIButton * btn4Star;
    UIButton * btn5Star;
    int rating;
}
@end

@implementation AddRate
@synthesize strHotelID,ISEDIT;

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationItem setHidesBackButton:NO];
    if(ISEDIT)
    {
        self.navigationItem.title=[NSString stringWithFormat:@"%@'s review",self.strUserName];
    }
    else
    {
        self.navigationItem.title=@"Add Review";
    }
    [[UIBarButtonItem appearance] setTintColor:globelColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    serviceCount = 0;
    btn1Star=[[UIButton alloc]init];
    btn2Star=[[UIButton alloc]init];
    btn3Star=[[UIButton alloc]init];
    btn4Star=[[UIButton alloc]init];
    btn5Star=[[UIButton alloc]init];
    
     [[UIBarButtonItem appearance] setTintColor:globelColor];
    
//    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
//                                                                    style:UIBarButtonItemStylePlain
//                                                                   target:self
//                                                                   action:@selector(BackBtnClick)];
//    self.navigationItem.leftBarButtonItem=backbarBtn;
//    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    if(ISEDIT)
    {
        self.navigationItem.title=[NSString stringWithFormat:@"%@'s review",self.strUserName];
    }
    else
    {
        self.navigationItem.title=@"Add Review";
    }
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(SendFeedBack)];
    
    UIBarButtonItem * doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(SendFeedBack)];
    doneBtn.tintColor=[UIColor blueColor];
    if (ISEDIT)
    {
    }
    else
    {
        self.navigationItem.rightBarButtonItem = doneBtn;
    }
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
   // bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    scrlContent=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    scrlContent.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scrlContent];
    
    
    UILabel * lblHint=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    if (ISEDIT)
    {
        lblHint.text=@"  Rating";
    }
    else
    {
        lblHint.text=@"  Give your ratings";
    }
    
    lblHint.textColor=[UIColor whiteColor];
    lblHint.backgroundColor=[UIColor colorWithHexString:@"314186"];
    [lblHint setFont:[UIFont systemFontOfSize:18.0]];
    [scrlContent addSubview:lblHint];
    
    
    int yyy=0;

    yyy=yyy+45;
    
    btn1Star.frame=CGRectMake(self.view.frame.size.width/2-75, yyy, 30, 30);
    [btn1Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
    [btn1Star addTarget:self action:@selector(giveRating:) forControlEvents:UIControlEventTouchUpInside];
    btn1Star.tag=1;
    [scrlContent addSubview:btn1Star];
    
    
    btn2Star.frame=CGRectMake(35+btn1Star.frame.origin.x, yyy, 30, 30);
    [btn2Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
    [btn2Star addTarget:self action:@selector(giveRating:) forControlEvents:UIControlEventTouchUpInside];
    btn2Star.tag=2;
    [scrlContent addSubview:btn2Star];
    
    btn3Star.frame=CGRectMake(btn2Star.frame.origin.x+35, yyy, 30, 30);
    [btn3Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
    [btn3Star addTarget:self action:@selector(giveRating:) forControlEvents:UIControlEventTouchUpInside];
    btn3Star.tag=3;
    [scrlContent addSubview:btn3Star];
    
    btn4Star.frame=CGRectMake(btn3Star.frame.origin.x+35, yyy, 30, 30);
    [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
    [btn4Star addTarget:self action:@selector(giveRating:) forControlEvents:UIControlEventTouchUpInside];
    btn4Star.tag=4;
    [scrlContent addSubview:btn4Star];
    
    btn5Star.frame=CGRectMake(btn4Star.frame.origin.x+35, yyy, 30, 30);
    [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
    [btn5Star addTarget:self action:@selector(giveRating:) forControlEvents:UIControlEventTouchUpInside];
    btn5Star.tag=5;
    [scrlContent addSubview:btn5Star];
   
    UILabel * lblGiverate=[[UILabel alloc]initWithFrame:CGRectMake(0, yyy+35, self.view.frame.size.width, 20)];
    lblGiverate.text=@"Tap a star to rate";
    lblGiverate.textColor=[UIColor lightGrayColor];
    lblGiverate.textAlignment=NSTextAlignmentCenter;
    lblGiverate.backgroundColor=[UIColor clearColor];
    [lblGiverate setFont:[UIFont systemFontOfSize:12.0]];
    
    if ([ISEDIT isEqualToString:@"YES"])
    {
        
    }
    else
    {
        [scrlContent addSubview:lblGiverate];
    }
    
    

    if (ISEDIT)
    {
        yyy=53;

    }
    else
    {
        yyy=yyy+35;
    }
    
    UILabel *lblText=[[UILabel alloc]initWithFrame:CGRectMake(0,yyy+35, self.view.frame.size.width, 35)];
    if (ISEDIT)
    {
        lblText.text=@"  Comments";

    }
    else
    {
        lblText.text=@"  Write your comments";
        lblCount=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 0,60, 35)];
        lblCount.textColor=[UIColor whiteColor];
        [lblCount setFont:[UIFont systemFontOfSize:16.0]];
        lblCount.text=@"0/155    ";
        lblCount.textAlignment=NSTextAlignmentRight;
        
        [lblText addSubview:lblCount];
        
    }
    lblText.textColor=[UIColor whiteColor];
    [lblText setFont:[UIFont systemFontOfSize:18.0]];
    lblText.backgroundColor=[UIColor colorWithHexString:@"314186"];
    [scrlContent addSubview:lblText];
    
    
    yyy=yyy+35;
    myTextView = [[UITextView alloc]initWithFrame:
                  CGRectMake(0, yyy+35, self.view.frame.size.width, 150)];
    [myTextView setText:@""];
    myTextView.text = @"Please enter comments here..";
    if (ISEDIT)
    {
        myTextView.text = self.strReview;
        myTextView.editable=NO;
        
    }
    myTextView.textColor = [UIColor blackColor];
    myTextView.delegate = self;
    [scrlContent addSubview:myTextView];

    
    yyy=yyy+150;
    UILabel * line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(0, yyy, self.view.frame.size.width, 1);
    [scrlContent addSubview:line];
    
    if (ISEDIT)
    {
        UIButton *btnSender=[UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger tag;
        tag=[self.NoofReview integerValue];
        btnSender.tag=tag;
        
        [self DisplayRate:btnSender];
    }
    
    // Do any additional setup after loading the view.
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Please enter comments here.."])
    {
        myTextView.text=@"";
        
    }
    if (IS_IPHONE_4)
    {
        [scrlContent setContentOffset:CGPointMake(0, 110) animated:YES];
        
    }
}
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (IS_IPHONE_4)
    {
        [scrlContent setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (theTextView==myTextView)
    {
        NSLog(@"textViewComments");
    }
    else if(theTextView==myTextView)
    {
         NSLog(@"CommentTextView");
    }
    if ([theTextView.text isEqualToString:@""])
    {
        myTextView.text=@"Please enter comments here..";
    }
    else
    {
    }
}
- (void) textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    
    if ( [ text isEqualToString: @"\n" ] )
    {
        [ textView resignFirstResponder ];
        return NO;
    }
    else
    {
        
        NSUInteger newLength = (textView.text.length - range.length) + text.length;
        
        
        if(newLength <= 149)
        {
            lblCount.text=[NSString stringWithFormat:@"%lu/150  ",(unsigned long)newLength];

            return YES;
        } else
        {
            lblCount.text=[NSString stringWithFormat:@"150/150  "];
            NSUInteger emptySpace = 149 - (textView.text.length - range.length);
            textView.text = [[[textView.text substringToIndex:range.location]
                              stringByAppendingString:[text substringToIndex:emptySpace]]
                             stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
            return NO;
        }
    }

}


#pragma  mark ----  RATE Button Clicked
-(void)giveRating:(id)sender
{
    if (ISEDIT)
    {
        
    }
    else
    {
        UIButton *btn=(UIButton *)sender;
        if (btn.tag==1) {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
        }
        else if (btn.tag==2)
        {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            
        }
        else if (btn.tag==3) {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
        }
        else if (btn.tag==4)
        {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
        }
        else{
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }
        rating=btn.tag;

    }
      //lblRatingShow.text=[NSString stringWithFormat:@"%d",btn.tag];
}


#pragma mark FeedBack Btn

-(void)SendFeedBack
{
     NSLog(@"FededBack CLicked");
    
    if (rating==0)
    {
        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:@"Please provide rating" cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
        
         [alert showWithAnimation:URBalertAnimationType];;
    }
    else if ([myTextView.text isEqualToString:@""]||[myTextView.text isEqualToString:@"Please enter comments here.."])
    {
        myTextView.text=@"";
        [self AddReview];
        
    }
    else
    {
        [self AddReview];
        
        
        
    }
    [myTextView resignFirstResponder];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --- Back buttonClick

-(void)BackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark ____WEBservices

-(void)AddReview
{
    
    NSString *strRate=[NSString stringWithFormat:@"%d",rating];
    
    NSString *customerId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"data"]valueForKey:@"customer_id"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:customerId forKey:@"customer_id"];
    [dict setValue:strHotelID forKey:@"hotel_id"];
    [dict setValue:strRate forKey:@"ratings"];
    [dict setValue:myTextView.text forKey:@"comments"];
    
    /*
     hotel_id
     customer_id
     ratings
     comments
     */
    
    serviceCount = serviceCount + 1;
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"AddRivew";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/addReview" withParameters:dict];
    
}



#pragma mark ---- Given Rate To Display
-(void)DisplayRate:(id)sender
{
      
        UIButton *btn=(UIButton *)sender;
        if (btn.tag==1) {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            
        }
        else if (btn.tag==2)
        {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            
        }
        else if (btn.tag==3) {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
        }
        else if (btn.tag==4)
        {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"unselected-star1"] forState:UIControlStateNormal];
        }
        else
        {
            [btn1Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn2Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn3Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn4Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [btn5Star setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }
        rating = btn.tag;
        
    
    //lblRatingShow.text=[NSString stringWithFormat:@"%d",btn.tag];
}

#pragma mark---- url manager delegates


- (void)onResult:(NSDictionary *)result
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    serviceCount = 0;
     NSLog(@"The result is...%@", result);
    if([[result valueForKey:@"commandName"] isEqualToString:@"AddRivew"])
    {
        
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            isRate=YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
        }
    }
}
- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    //    [app hudEndProcessMethod];
     NSLog(@"Add Rate The error is...%@", error);
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
//        URBAlertView * alert =[[URBAlertView alloc] initWithTitle:@"Booking" message:[error localizedDescription] cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert setMessageFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13]];
//        
//         [alert showWithAnimation:URBalertAnimationType];;
    }
    
    
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"AddRivew"])
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
                [self AddReview];
            }
        }
    }
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
