//
//  OCCalendarViewController.m
//  OCCalendar
//
//  Created by Oliver Rickard on 3/31/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "OCCalendarViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OCCalendarViewController ()

@end

@implementation OCCalendarViewController
@synthesize delegate, startDate, endDate, selectionMode;

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap selectionMode:(OCSelectionMode)sm {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        insertPoint = point;
        parentView = v;
        arrowPos = OCArrowPositionNone;
        selectionMode = sm;
    }
    return self;
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap {
    return [self initAtPoint:point inView:v arrowPosition:ap selectionMode:OCSelectionDateRange];
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v {
    return [self initAtPoint:point inView:v arrowPosition:OCArrowPositionNone];
}

- (void)loadView {
    [super loadView];
    self.view.frame = CGRectMake(-6, 0, 320, parentView.frame.size.height);
    
    
    titleForDatePicker=[[UILabel alloc]initWithFrame:CGRectMake(5,185, self.view.frame.size.width+5, 40)];
    titleForDatePicker.text=@"Select Arrival Date";
    titleForDatePicker.backgroundColor=[UIColor colorWithRed: 180.0/255.0 green: 46.0/255.0 blue: 218.0/255.0 alpha: 1];
    UITapGestureRecognizer *tapG1 =[[UITapGestureRecognizer alloc] init];
    tapG1.delegate = self;
    [titleForDatePicker setUserInteractionEnabled:YES];

    [titleForDatePicker addGestureRecognizer:[tapG1 autorelease]];
    titleForDatePicker.textColor =[UIColor whiteColor];
    titleForDatePicker.textAlignment=NSTextAlignmentCenter;
    titleForDatePicker.font=[UIFont boldSystemFontOfSize:16.];
//    titleForDatePicker.userInteractionEnabled=true;
    

    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapG =[[UITapGestureRecognizer alloc] init];
    tapG.delegate = self;
    [bgView addGestureRecognizer:[tapG autorelease]];
    [bgView setUserInteractionEnabled:YES];
    [self.view addSubview:[bgView autorelease]];
    
   whiteview=[[UIView alloc]initWithFrame:CGRectMake(05, 190, self.view.frame.size.width+10, self.view.frame.size.height)];
    whiteview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whiteview];
    
    
    UITapGestureRecognizer *tapG2 =[[UITapGestureRecognizer alloc] init];
    tapG2.delegate = self;
    
    btndone=[UIButton buttonWithType:UIButtonTypeCustom];
    btndone.frame=CGRectMake(self.view.frame.size.width-40,185, 45,45);
    [btndone addGestureRecognizer:tapG2];
    btndone.backgroundColor=[UIColor clearColor];
    
    [btndone setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    btndone.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    //    [closeButton setImage:clsImg forState:UIControlStateNormal];

    closebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closebtn.frame=CGRectMake(0,185, 45,45);
    [closebtn addGestureRecognizer:tapG];
    closebtn.backgroundColor=[UIColor clearColor];
    [closebtn setImage:[UIImage imageNamed:@"closeMenu"] forState:UIControlStateNormal];
    closebtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    //    [closeButton setImage:clsImg forState:UIControlStateNormal];
    


    
    int width = 390;
    int height = 300;
    
   
    calView = [[OCCalendarView alloc] initAtPoint:insertPoint withFrame:CGRectMake((self.view.frame.size.width/2)-(width/2),175, width, height) arrowPosition:OCArrowPositionNone];
    //arrowPosition:OCArrowPositionCentered
    [calView setSelectionMode:selectionMode];
    if(self.startDate) {
        [calView setStartDate:startDate];
    }
    if(self.endDate) {
        [calView setEndDate:endDate];
    }
    [self.view addSubview:[calView autorelease]];
    [self.view addSubview:titleForDatePicker];

    [self.view addSubview:btndone];
    [self.view addSubview:closebtn];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setStartDate:(NSDate *)sDate {
    if(startDate) {
        [startDate release];
        startDate = nil;
    }
    startDate = [sDate retain];
    [calView setStartDate:startDate];
}

- (void)setEndDate:(NSDate *)eDate {
    if(endDate) {
        [endDate release];
        endDate = nil;
    }
    endDate = [eDate retain];
    [calView setEndDate:endDate];
}


- (void)removeCalView {
    startDate = [[calView getStartDate] retain];
    endDate = [[calView getEndDate] retain];
    
    //NSLog(@"startDate:%@ endDate:%@", startDate.description, endDate.description);
    
    //NSLog(@"CalView Selected:%d", [calView selected]);
    
    if([calView selected]) {
        if([startDate compare:endDate] == NSOrderedAscending)
            [self.delegate completedWithStartDate:startDate endDate:endDate];
        else
            [self.delegate completedWithStartDate:endDate endDate:startDate];
    } else {
        [self.delegate completedWithNoSelection];
    }
    
   
    

    [calView removeFromSuperview];
    calView = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(calView)
    {
            [self performSelector:@selector(removeCalView) withObject:nil afterDelay:0.4f];
    } else {
        //Recreate the calendar if it doesn't exist.
        
        //CGPoint insertPoint = CGPointMake(200+130*0.5, 200+10);
        CGPoint point = [touch locationInView:self.view];
        int width = 390;
        int height = 300;
        
        calView = [[OCCalendarView alloc] initAtPoint:point withFrame:CGRectMake(point.x - width*0.5, point.y - 31.4, width, height)];
        [self.view addSubview:[calView autorelease]];
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    self.startDate = nil;
    self.endDate = nil;
    [super dealloc];
}

@end
