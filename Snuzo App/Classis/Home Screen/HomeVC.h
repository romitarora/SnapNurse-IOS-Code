//
//  HomeVC.h
//  Snoozo App
//
//  Created by HARI on 7/30/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelList.h"
#import "OCCalendarViewController.h"
#import "AKSSegmentedSliderControl.h"
#import "URLManager.h"
#import "USColor.h"
#import "Constant.h"
#import "UIColor+MRColor.h"


@interface HomeVC : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,OCCalendarDelegate,UITableViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AKSSegmentedSliderControlDelegate,URLManagerDelegate,UITabBarControllerDelegate>
{
    AKSSegmentedSliderControl* sliderControl;
    NSInteger selectedindex;
     NSInteger serviceCount;
    NSDictionary * detailDict;
    
    NSArray *Hours,*Minutes;
    OCCalendarViewController *calVC;
    UIView *bgView;
    UIView *bgTimeView;
    HotelList *listVC;
    UILabel *titleForDatePicker;
    UIScrollView *scrlContent;
    UIButton *btnContinue;
    UIImageView *imgmain;
    UITextField *txtlocation;
    UIButton *btnclose;
    UILabel *lblArrivalDate;
    UILabel *DateTitle;
    UILabel * cityTitleLbl,*hospitalNameLbl;
    BOOL isSearching;
    UITableView *tblTime;
    bool istimeClick;
    
    NSMutableArray *filteredContentArray,*locationArray,*filteredhotelarray;
    NSString *flag;
    NSString *name;
    NSMutableArray *maintime;;
    
    UIButton *BtnarrivalTime;
    UIButton *BtnarrivalDate;
    UIButton *cityBtn,*hospitalBtn;
    NSDate *startDate;

    UILabel *toolTipLabel;

    UITableView *tbllocation;
    UITableView *tblCityList;
    UITableView *tblhotel;
    
    UILabel *lbltime;
    UILabel *lblHours;
    UISearchBar *locationsearch;
    UISearchBar *citySearch;
    
    UIButton *BtnTime;
    NSMutableArray *timeArray;
    UILabel *timeTitle;
    
    UIButton *btnsearch;
    
    NSString *strHours;
    NSString *strServerTime;
    NSString *strAm;
    NSDate *selectedDate;
    NSString * strCityName,*strHospitalName,*strHospitalId;
    
    
    NSMutableArray *cityarraymain;
    NSMutableArray *HotelMainarray;
    NSMutableArray *SpicilizationArr,*hospitalArr;
    
    
    
    UIView *timebackview;
    NSMutableArray *tempTimeArr;

    
    BOOL isdateClick;
    BOOL isFromCityPicker,isFromHospital;
    
    NSString * customerId;
    
    NSDate *searchDate;
    
    
    UIView * navView;
    
    
}

@property BOOL isfromNotify;
@end
