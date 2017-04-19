//
//  HotelListingVC.m
//  Snuzo App
//
//  Created by one click IT consultany on 8/29/15.
//  Copyright (c) 2015 Oneclick IT. All rights reserved.
//

#import "HotelListingVC.h"
#import "MMParallaxCell.h"
#import "Constant.h"
@interface HotelListingVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITextField * searchTextField;
    UIImageView * searchImgGlass;
    BOOL isSearching;
    UIView * headerView;
    NSMutableArray * imgArr;
    NSMutableArray *hotellistarray;
    NSMutableArray *searchdetailarray;
    NSMutableArray *searchArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *Searchbar;
@end


@implementation HotelListingVC
@synthesize  rateVw,searchStr;


- (void)viewDidLoad
{
    
    Count=0;
    serviceCount = 0;
    isError = NO;
    
    imgArr =[[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg", nil];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    hotellistarray=[[NSMutableArray alloc]init];
    
   
    
    [self.navigationItem setHidesBackButton:YES];
    
     
     
    UIView *navigationRightview =[[UIView alloc] initWithFrame:CGRectMake(122, 0, 198, 44)];
    navigationRightview.backgroundColor=[UIColor greenColor];
    navigationRightview.tag=999;
    
    
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    
     UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    bg.image=[UIImage imageNamed:@"bg"];
    [self.view addSubview:bg];
    
    if (IS_IPHONE_4)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-4.png"];
    }
    else if (IS_IPHONE_5)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-5.png"];
    }
    else if (IS_IPHONE_6)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-6.png"];
    }
    else
    {
        bg.image=[UIImage imageNamed:@"bg-ip-6plus.png"];
    }
    
    UIView * backView = [[UIView alloc] init];
   backView.frame = CGRectMake(0, 0, self.view.frame.size.width, viewHeight);
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    headerView =[[UIView alloc] init];
    headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
    //headerView.backgroundColor=[UIColor colorWithRed:30/255.0 green:35.0/255.0 blue:71.0/255.0 alpha:1.0];
    headerView.backgroundColor=[UIColor colorWithRed:201/255.0 green:201.0/255.0 blue:206.0/255.0 alpha:1.0];
    
    [self.view addSubview:headerView];
    
    
    self.Searchbar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.Searchbar.delegate=self;
    //  self.Searchbar.backgroundColor=[UIColor whiteColor];
    // self.Searchbar.barTintColor=[UIColor whiteColor];
    self.Searchbar.placeholder=@"Search Nurse";
    // self.Searchbar.layer.borderColor=[UIColor whiteColor].CGColor;
    // [self.Searchbar setTranslucent:YES];
    // self.Searchbar.tintColor = [UIColor blueColor];
    //self.Searchbar.layer.borderWidth=0.0f;
    // self.Searchbar.layer.cornerRadius=12.0;
    //[self.Searchbar setImage:[UIImage imageNamed:@"NewSearchImg"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
    [headerView addSubview:self.Searchbar];
    
    
    //    self.Searchbar.tintColor=[UIColor grayColor];
    //
    //    //[self.Searchbar setBackgroundImage:[UIImage new]];
    //
    //    UITextField *txfSearchField = [self.Searchbar valueForKey:@"_searchField"];
    //    [txfSearchField setBackgroundColor:[UIColor clearColor]];
    //    [txfSearchField setLeftView:UITextFieldViewModeNever];
    //    [txfSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    //    txfSearchField.layer.borderWidth = 0.50f;
    //    txfSearchField.layer.cornerRadius = 10.0f;
    //    txfSearchField.layer.borderColor = [UIColor colorWithRed:86.0/255.0 green:90.0/255.0 blue:117.0/255.0 alpha:1.0].CGColor;
    //    txfSearchField.textColor=[UIColor whiteColor];
    //
    //
    //    searchImgGlass = [[UIImageView alloc] init];
    //    searchImgGlass.image=[UIImage imageNamed:@"NewSearchImg"];
    //    searchImgGlass.frame=CGRectMake(10, 7.5, 12.5, 12.5);
    //    searchImgGlass.tintColor= [UIColor colorWithRed:254.0/255.0 green:46.0/255.0 blue:108.0/255.0 alpha:1.0];
    //    searchImgGlass.userInteractionEnabled=YES;
    //[txfSearchField addSubview:searchImgGlass];
    
    
    
    //[self.Searchbar setBackgroundImage:[[UIImage alloc]init]];
    
    //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth,kScreenHeight-50-75-49) style:UITableViewStylePlain];
    
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle=normal;
    
    [super viewDidLoad];
    
    pullToRefreshManager_Images =nil;
    [self HotelListing];
    
}
#pragma mark -
-(void)viewWillAppear:(BOOL)animated
{
    
    UIBarButtonItem * backbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BackBtnClick)];
    self.navigationItem.leftBarButtonItem=backbarBtn;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    
    Count=0;
    serviceCount = 0;
    
   // [self hideTabBar:self.tabBarController];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"SnapNurse";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    //    [self.tableView reloadData];
    
}

#pragma mark --url MAnager Delegates


- (void)onResult:(NSDictionary *)result
{
    
    NSLog(@"The result is...%@", result);
    serviceCount = 0;
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"searchDestinations"])//jam27-07
    {
        
        if ([[[result valueForKey:@"result"]valueForKey:@"result"]isEqualToString:@"true"])
        {
            NSMutableArray*   tempFeedsArray=[[NSMutableArray alloc]init];
            tempFeedsArray=[[[result valueForKey:@"result"]valueForKey:@"result_data"]mutableCopy];
            searchdetailarray=[[result valueForKey:@"result"]valueForKey:@"search_data"];
            if (Count==0)
            {
                [hotellistarray removeAllObjects];
            }
            [hotellistarray addObjectsFromArray:tempFeedsArray ];
            [lblMessage removeFromSuperview];
            lblMessage=nil;
            
            [self.tableView reloadData];
            
            if ([tempFeedsArray count] >
                10)
            {
                pullToRefreshManager_Images =[[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tableView withClient:self];
                [pullToRefreshManager_Images tableViewReloadFinished];
                [pullToRefreshManager_Images setPullToRefreshViewVisible:YES];
            }
            else
            {
                if (pullToRefreshManager_Images!=nil)
                {
                    [pullToRefreshManager_Images tableViewReloadFinished];
                    [pullToRefreshManager_Images setPullToRefreshViewVisible:NO];
                }
            }
            if ([tempFeedsArray count]==0)
            {
                {
                    [lblMessage removeFromSuperview];
                    lblMessage=nil;
                    lblMessage=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, viewHeight-50)];
                    lblMessage.text=@"Nurse not found please change your search credentials";
                    lblMessage.textColor=[UIColor blackColor];
                    lblMessage.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                    lblMessage.textAlignment=NSTextAlignmentCenter;
                    lblMessage.numberOfLines=2;
                    [self.view addSubview:lblMessage];
                }
            }
        }
        else
        {
            [lblMessage removeFromSuperview];
            lblMessage=nil;
            if (Count==0)
            {
                [hotellistarray removeAllObjects];
                [searchdetailarray removeAllObjects];
                lblMessage=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, viewHeight-50)];
                lblMessage.text=@"Nurse not found please change your search credentials";
                lblMessage.textColor=[UIColor blackColor];
                lblMessage.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15];
                lblMessage.textAlignment=NSTextAlignmentCenter;
                lblMessage.numberOfLines=2;
                [self.view addSubview:lblMessage];
            }
        }
    }
    else
    {
        
    }
}
- (void)onError:(NSError *)error
{
    
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    [pullToRefreshManager_Images tableViewReleased];
    
    
    NSLog(@"Hotel list ==> The error is...%@", error);
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
//        [alert showWithAnimation:URBalertAnimationType];;
    }
}
- (void)onNetworkError:(NSError *)error didFailWithCommandName:(NSString *)commandName
{
    NSLog(@"OnNetworkErrorCall");
    if (error.code == -1005)
    {
        if ([commandName isEqualToString:@"searchDestinations"])
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
                [self HotelListing];
                
            }
        }
    }

}

#pragma marrk Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshManager_Images tableViewReleased];
}
#pragma mark Hotel List
-(void)HotelListing
{
    serviceCount = serviceCount +1;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:self.flag forKey:@"destination_flag"];
    [dict setObject:self.name forKey:@"destination_value"];
    [dict setObject:self.date forKey:@"date"];
    [dict setObject:self.Time forKey:@"time"];
    [dict setObject:self.NOofhours forKey:@"hours"];
    [dict setObject:self.cityStr forKey:@"city"];
    [dict setObject:[NSString stringWithFormat:@"%d",Count] forKey:@"start"];
    
    NSLog(@"DICT == %@",dict);
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"searchDestinations";
    manager.delegate = self;
  //  [manager urlCall:@"http://www.chillyn.com/webservice/searchDestinations" withParameters:dict];
    [manager urlCall:@"http://snapnurse.com/webservice/searchNurses" withParameters:dict];

    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
}
#pragma mark - UITableview Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
    {
        return filteredContentArray.count;
    }
    else
    {
        return hotellistarray.count;
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5.0;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
   // cell.backgroundColor=[UIColor clearColor];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    
    NurseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //MMParallaxCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[NurseListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell.parallaxRatio = 1.2f;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell SpecialiZationNureseField:[[hotellistarray objectAtIndex:indexPath.row] valueForKey:@"specialization"] atIndexPath:indexPath];
    
    cell.lblNameNurese.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:12];
    
    if (isSearching)
    {
        NSURL *url = [NSURL URLWithString:[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"hotel_image"]];
        
        cell.lblNameNurese.text=[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"hotel_name"];
        cell.lblCastPerHour.text=[NSString stringWithFormat:@"$ %@ / Hours",[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"min_price"]];
        [cell.imgNursePic setImageURL:url];
        double rate=[[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"average_ratings"]doubleValue];
        cell.nurseRate.rating=rate;
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"hotel_image"]];
        cell.lblNameNurese.text=[[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"hotel_name"];
        cell.lblCastPerHour.text=[NSString stringWithFormat:@"$ %@  %@ Hrs",[[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"min_price"],self.NOofhours];
        [cell.imgNursePic setImageURL:url];
        double rate=[[[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"average_ratings"]doubleValue];
        cell.nurseRate.rating=rate;
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:cell.lblCastPerHour.text];
    NSRange range2 = [cell.lblCastPerHour.text rangeOfString:[NSString stringWithFormat:@" %@ Hrs",self.NOofhours]];
    cell.lblCastPerHour.textColor=[UIColor colorWithRed:0/255.0 green:32/255.0f blue:194.0/255.0 alpha:1.0];
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                            range:range2];
    
    cell.lblCastPerHour.attributedText = attributedText;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *  sectionHeader = [[UIView alloc]init];
    sectionHeader.frame = CGRectMake(10, 0, kScreenWidth-20, 30);
    sectionHeader.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleNameLbl = [[UILabel alloc]init];
    titleNameLbl.frame = CGRectMake(0, 0, sectionHeader.frame.size.width, 30);
    titleNameLbl.text =searchStr;
    ;
    titleNameLbl.textColor = globelColor;
    titleNameLbl.textAlignment = NSTextAlignmentCenter;
    titleNameLbl.backgroundColor = [UIColor clearColor];
    titleNameLbl.font = [UIFont systemFontOfSize:10];
    [sectionHeader addSubview:titleNameLbl];
    return  sectionHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    hoteldetailVC *hotelDetail=[[hoteldetailVC alloc]init];
    if (isSearching)
    {
        hotelDetail.strid=[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"hotel_id"];
        hotelDetail.date=self.date;
        hotelDetail.time=self.Time;
        hotelDetail.hours=self.NOofhours;
        hotelDetail.timevalue=self.timevalue;
        hotelDetail.nurseStartTime = self.nurseStartTime;
        hotelDetail.strHospitalName = self.strHospitalName;
        hotelDetail.strHospitalId = self.strHospitalId;
        hotelDetail.titleStr = [[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"hotel_name"];
        hotelDetail.specializationArr = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"specialization"];
        hotelDetail.priceStr = [[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"min_price"];
        hotelDetail.imgUrlStr = [[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"hotel_image"];
        
    }
    else
    {
        hotelDetail.strid=[[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"hotel_id"];
        hotelDetail.date=self.date;
        hotelDetail.time=self.Time;
        hotelDetail.nurseStartTime = self.nurseStartTime;
        hotelDetail.hours=self.NOofhours;
        hotelDetail.timevalue=self.timevalue;
        hotelDetail.strHospitalName = self.strHospitalName;
        hotelDetail.strHospitalId = self.strHospitalId;
        hotelDetail.titleStr = [[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"hotel_name"];
        hotelDetail.specializationArr = [[[hotellistarray objectAtIndex:indexPath.row] valueForKey:@"specialization"] mutableCopy];
        hotelDetail.priceStr = [[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"min_price"];
         hotelDetail.imgUrlStr = [[hotellistarray objectAtIndex:indexPath.row]valueForKey:@"hotel_image"];
       
    }
   
    hotelDetail.searchdetailarray=[searchdetailarray mutableCopy];
   
    [self.Searchbar resignFirstResponder];
    [self.navigationController pushViewController:hotelDetail animated:YES];
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
    [self HotelListing];
    
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

#pragma mark - Button Click
-(void)BackBtnClick
{
   // [self showTabBar:self.tabBarController];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchBar *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText1
{
    if ([searchText1 length]>0)
    {
        [self filterContentForSearchText:searchText1];
        searchBar.showsCancelButton = NO;
    }
    else
    {
        //         NSLog(@"Hello");
        searchBar.showsCancelButton = NO;
        [searchBar resignFirstResponder];
        isSearching = NO;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchStr1 = [NSString stringWithFormat:@"%@",searchBar.text];
    
    if (searchStr1.length >0)
    {
        
        //        [HUD show:YES];
        
        //        [self searchUserWebService:searchStr1];
        searchBar.showsCancelButton = YES;
        
    }
    [searchBar resignFirstResponder];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBar.text=@"";
    searchImgGlass.hidden=YES;
    self.tableView.hidden=NO;
    //    [self prefersStatusBarHidden];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
    if (searchBar.text.length==0)
    {
        searchImgGlass.hidden=NO;
    }
    else
    {
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    // if you want the keyboard to go away
    searchBar.text = @"";
    
    isSearching=NO;
    
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
    
    
}

-(void)filterContentForSearchText:(NSString *)searchText
{
    // Remove all objects from the filtered search array
    [filteredContentArray removeAllObjects];
    
    
    // Filter the array using NSPredicate
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self[cd] %@",searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hotel_name contains[cd] %@",searchText];
    
    NSArray *filterdArr =[[NSArray alloc] init];
    
    
    filterdArr = [hotellistarray filteredArrayUsingPredicate:predicate];
    
    
    
    if (filteredContentArray)
    {
        filteredContentArray = nil;
    }
    filteredContentArray = [[NSMutableArray alloc] initWithArray:filterdArr];
    
    //     NSLog(@"filteredListContent:%@",filteredContentArray);
    
    if (searchText == nil || [searchText isEqualToString:@""])
        isSearching = NO;
    else
        isSearching = YES;
    
    [self.tableView reloadData];
}

#pragma mark  SHOW TAB BAR AT BOTTOM

- (void) hideTabBar:(UITabBarController *) tabbarcontroller
{
    /*
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:0.4];
     for(UIView *view in tabbarcontroller.view.subviews)
     {
     if([view isKindOfClass:[UITabBar class]])
     {
     if ([[UIScreen mainScreen] bounds].size.height == 568)
     {
     [view setFrame:CGRectMake(view.frame.origin.x, 568, view.frame.size.width, view.frame.size.height)];
     }
     else if ([[UIScreen mainScreen] bounds].size.height == 480)
     {
     [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
     }
     }
     else
     {
     if ([[UIScreen mainScreen] bounds].size.height == 568)
     {
     [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 568)];
     }
     else if ([[UIScreen mainScreen] bounds].size.height == 480)
     {
     [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
     }
     }
     }
     
     [UIView commitAnimations];*/
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 519, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 618, view.frame.size.width, view.frame.size.height)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 687, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 519)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 618)];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 687)];
            }
        }
    }
    [UIView commitAnimations];
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
