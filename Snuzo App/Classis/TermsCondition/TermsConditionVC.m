//
//  TermsConditionVC.m
//  Snuzo App
//
//  Created by Lubhna Shirvastava on 05/10/16.
//  Copyright © 2016 Oneclick IT. All rights reserved.
//

#import "TermsConditionVC.h"

@interface TermsConditionVC ()

@end

@implementation TermsConditionVC

- (void)viewDidLoad
{
    //[self hideTabBar:self.tabBarController];
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back icon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackBtnClick)];
    back.tintColor=globelColor;
    self.navigationItem.leftBarButtonItem=back;
    self.navigationItem.leftBarButtonItem.tintColor=globelColor;
    self.navigationItem.title = _strTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:globelColor}];
    
   webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [ webView canGoBack];
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    webView.delegate = self;
    
    [self.view addSubview:webView];
    NSURL * webUrl = [NSURL URLWithString:_strUrl];
    [ webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
    
    

    
    // Do any additional setup after loading the view.
}
-(void)BackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  SHOW TAB BAR AT BOTTOM


#pragma mark -
#pragma  mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
     webView.delegate = self; // setup the delegate as the web view is shown
   // [self hideTabBar:self.tabBarController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [webView stopLoading]; // in case the web view is still loading its content
     webView.delegate = nil; // disconnect the delegate as the webview is hidden
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

// this helps dismiss the keyboard when the "Done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [ webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[textField text]]]];

    return YES;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [webView loadHTMLString:errorString baseURL:nil];
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
