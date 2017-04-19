//
//  TermsConditionVC.h
//  Snuzo App
//
//  Created by Lubhna Shirvastava on 05/10/16.
//  Copyright © 2016 Oneclick IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface TermsConditionVC : UIViewController<UIWebViewDelegate>
{
    UIWebView * webView;
}
@property(nonatomic,strong)NSString * strUrl;
@property(nonatomic,strong)NSString * strTitle;
@end
