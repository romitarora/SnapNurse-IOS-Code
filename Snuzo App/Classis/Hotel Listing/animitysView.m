//
//  animitysView.m
//  Snuzo App
//
//  Created by Oneclick IT on 9/17/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "animitysView.h"

@interface animitysView ()

@end

@implementation animitysView
@synthesize strHotelId;


-(void)viewWillAppear:(BOOL)animated
{

}
-(void)viewWillDisappear:(BOOL)animated
{
    strisfromAnimity=@"YES";
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    serviceCount = 0;
    
    hotelamenity=[[NSMutableArray alloc]init];
    
    self.view.backgroundColor=[UIColor blackColor];

    
    
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.translucent=NO;
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    

    self.navigationItem.title=@"Hotel Ameneties";
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bgLogin"];
    [self.view addSubview:bg];
    
    
    
    
    tblAmeneties=[[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,viewHeight-70)];
    tblAmeneties.backgroundColor=[UIColor clearColor];
    tblAmeneties.delegate=self;
    tblAmeneties.dataSource=self;
    tblAmeneties.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblAmeneties.separatorColor=[UIColor clearColor];
    
    
    [self.view addSubview:tblAmeneties];
    
    
    [self getAnimity];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)getAnimity
{
    serviceCount = serviceCount +1;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];

    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:strHotelId forKey:@"hotel_id"];
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"Getanimitys";
    manager.delegate = self;
    [manager urlCall:@"http://snapnurse.com/webservice/hotelAmeneties" withParameters:dict];
}

#pragma mark UrlManager Delegates

- (void)onResult:(NSDictionary *)result
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    serviceCount = 0;
    
     NSLog(@"The result is...%@", result);
    if([[result valueForKey:@"commandName"] isEqualToString:@"Getanimitys"])
    {
        
        for (int i=0; i<[[[result valueForKey:@"result"]valueForKey:@"service"] count]; i++)
        {
            NSString *strservicenamr=[[[[[result valueForKey:@"result"]valueForKey:@"service"]objectAtIndex:i]valueForKey:@"hotel_services"]valueForKey:@"service_name"];
            
            [hotelamenity addObject:strservicenamr];
            
        }
        [tblAmeneties reloadData];
        
    }
    else
    {
        
    }
}
- (void)onError:(NSError *)error
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    //    [app hudEndProcessMethod];
     NSLog(@"The error is...%@", error);
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
        if ([commandName isEqualToString:@"Getanimitys"])
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
                [self getAnimity];
            }
        }
    }
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
#pragma mark - UITableview Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [hotelamenity count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
  
    aminitycellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[aminitycellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.lbltext.frame=CGRectMake(10, 0, 320-15, 40);
        cell.lblline.frame=CGRectMake(0,39, 320, 1);
        cell.selectionStyle=normal;
        
    }
    
    cell.lbltext.text=[hotelamenity objectAtIndex:indexPath.row];
    cell.lbltext.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
    
    cell.lbltext.textColor=[UIColor whiteColor];
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor=[UIColor colorWithRed:30/255.0 green:35.0/255.0 blue:71.0/255.0 alpha:1.0];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //    ConfirmBookVC *confBook=[[ConfirmBookVC alloc]init];
    //    [self.navigationController pushViewController:confBook animated:YES];
    //
    
    
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
