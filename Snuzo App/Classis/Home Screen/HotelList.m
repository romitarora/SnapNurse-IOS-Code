//
//  HotelList.m
//  Snozu App
//
//  Created by HARI on 8/4/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "HotelList.h"
#import "AppDelegate.h"
@interface HotelList ()

@end

@implementation HotelList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.backItem.title = nil;
//    self.title=@"Snuzo";
    
    
   tblhoteList=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight-64)];
    tblhoteList.delegate=self;
    tblhoteList.dataSource=self;
    tblhoteList.backgroundColor=[UIColor whiteColor];
    tblhoteList.separatorStyle=normal;
    tblhoteList.separatorColor=[UIColor clearColor];
    [self.view addSubview:tblhoteList];
    
    
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    HotelListcell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[HotelListcell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *stringForCell;
    stringForCell= [NSString stringWithFormat:@"Location %ld",indexPath.row+1];
    cell.lblline.frame=CGRectMake(0, 139, self.view.frame.size.width, 1);
    
    return cell;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSString *strlocation=[NSString stringWithFormat:@"%@",cell.textLabel.text];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
