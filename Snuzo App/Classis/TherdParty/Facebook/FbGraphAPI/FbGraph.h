
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FbGraphResponse.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>



@class AppDelegate;
@interface FbGraph : NSObject <UIWebViewDelegate> {

	NSString *facebookClientID;
	NSString *redirectUri;
	NSString *accessToken;
	
	UIWebView *webView1;
	
}

@property (nonatomic, retain) NSString *facebookClientID;
@property (nonatomic, retain) NSString *redirectUri;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) UIWebView *webView1;

@property (nonatomic, retain) UIView                      *loadView;
@property (nonatomic, retain) UIActivityIndicatorView     *actView;



@property (assign) id callbackObject;
@property (assign) SEL callbackSelector;

- (id)initWithFbClientID:fbcid;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions andSuperView:(UIView *)super_view;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions;
- (FbGraphResponse *)doGraphGet:(NSString *)action withGetVars:(NSDictionary *)get_vars;
- (FbGraphResponse *)doGraphGetWithUrlString:(NSString *)url_string;
- (FbGraphResponse *)doGraphPost:(NSString *)action withPostVars:(NSDictionary *)post_vars;

@end
