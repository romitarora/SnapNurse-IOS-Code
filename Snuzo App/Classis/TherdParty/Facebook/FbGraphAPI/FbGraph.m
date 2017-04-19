
#import "FbGraph.h"
//#import "SBJSON.h"
#import "FbGraphFile.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation FbGraph

@synthesize facebookClientID;
@synthesize redirectUri;
@synthesize accessToken;
@synthesize webView1;

@synthesize callbackObject;
@synthesize callbackSelector;

@synthesize loadView;
@synthesize actView;

int flag = 0;
- (id)initWithFbClientID:fbcid {
	if (self = [super init]) {
		self.facebookClientID = fbcid;
		self.redirectUri = @"http://www.facebook.com/connect/login_success.html";	
//        mProcessHUD=[[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:mProcessHUD];
        
    
        
	}
	return self;
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    if (interfaceOrientation == UIInterfaceOrientationPortrait|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        return YES;
//    }
//    else
//    {
//        return YES;
//    }
//}



- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions andSuperView:(UIView *)super_view {
	
	self.callbackObject = anObject;
	self.callbackSelector = selector;
    
//    mProcessHUD = [[MBProgressHUD alloc]initWithView:super_view];
//    [super_view addSubview:mProcessHUD];
//    
//    [mProcessHUD show:YES];
	
//    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    activityView.center=super_view.center;
//    
//    [activityView startAnimating];
//    
//    [super_view addSubview:activityView];
    
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch", facebookClientID, redirectUri, extended_permissions];
	NSURL *url = [NSURL URLWithString:url_string];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	CGRect webFrame = [super_view frame];
	
   // CGRect webFrame;
    
	webFrame.origin.y = 0;
	UIWebView *aWebView = [[UIWebView alloc] initWithFrame:webFrame];
	[aWebView setDelegate:self];
//    [self.webView setDelegate:self];
    self.webView1 = aWebView;
	
	[aWebView release];
    //[mProcessHUD hide:YES];
	[webView1 loadRequest:request];
	[super_view addSubview:webView1];
}

-(void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions {
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
//	    mProcessHUD = [[MBProgressHUD alloc]initWithView:window];
//        [window addSubview:mProcessHUD];
//        
//        [mProcessHUD show:YES];
	[self authenticateUserWithCallbackObject:anObject andSelector:selector andExtendedPermissions:extended_permissions andSuperView:window];
    
}

- (FbGraphResponse *)doGraphGet:(NSString *)action withGetVars:(NSDictionary *)get_vars {
	
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/%@?", action];
	
	//tack on any get vars we have...
	if ( (get_vars != nil) && ([get_vars count] > 0) ) {
		
		NSEnumerator *enumerator = [get_vars keyEnumerator];
		NSString *key;
		NSString *value;
		while ((key = (NSString *)[enumerator nextObject])) {
			
			value = (NSString *)[get_vars objectForKey:key];
			url_string = [NSString stringWithFormat:@"%@%@=%@&", url_string, key, value];
			
		}//end while	
	}//end if
	
	if (accessToken != nil) {
		//now that any variables have been appended, let's attach the access token....
		url_string = [NSString stringWithFormat:@"%@access_token=%@", url_string, self.accessToken];
	}
    else
    {
        NSUserDefaults *LoginUser=[NSUserDefaults standardUserDefaults];
        NSString *str = [LoginUser stringForKey:@"accessToken"];
        url_string = [NSString stringWithFormat:@"%@access_token=%@", url_string, str];
    }
	
	//encode the string
	url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	return [self doGraphGetWithUrlString:url_string];
}

- (FbGraphResponse *)doGraphGetWithUrlString:(NSString *)url_string {
	
	FbGraphResponse *return_value = [[[FbGraphResponse alloc] init] autorelease];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
	
	NSError *err;
	NSURLResponse *resp;
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
	
	if (resp != nil) {
		
		/**
		 * In the case we request a picture (avatar) the Graph API will return to us the actual image
		 * bits versus a url to the image.....
		 **/
		if ([resp.MIMEType isEqualToString:@"image/jpeg"]) {
			
			UIImage *image = [UIImage imageWithData:response];
			return_value.imageResponse = image;
			
		} else {
		    
			NSString *stringResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
			return_value.htmlResponse = stringResponse;
			[stringResponse release];			
		}
		
	} else if (err != nil) {
		//return_value.error = err;
	}
	
	return return_value;
	
}

- (FbGraphResponse *)doGraphPost:(NSString *)action withPostVars:(NSDictionary *)post_vars {
	FbGraphResponse *return_value = [[[FbGraphResponse alloc] init] autorelease];
	NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@", action];
	NSURL *url = [NSURL URLWithString:urlString];
	NSString *boundary = @"----1010101010";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	NSEnumerator *enumerator = [post_vars keyEnumerator];
	NSString *key;
	NSString *value;
	NSString *content_disposition;
	//loop through all our parameters
	while ((key = (NSString *)[enumerator nextObject])) {
		//if it's a picture (file)...we have to append the binary data
		if ([key isEqualToString:@"file"]) {
			/*
			 * the FbGraphFile object is smart enough to append it's data to 
			 * the request automagically, regardless of the type of file being
			 * attached
			 */
			FbGraphFile *upload_file = (FbGraphFile *)[post_vars objectForKey:key];
			[upload_file appendDataToBody:body];
			
			//key/value nsstring/nsstring
		} else {
			value = (NSString *)[post_vars objectForKey:key];
			content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
			
		}//end else
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}//end while
	
	//add our access token
	[body appendData:[@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	//[body appendData:[accessToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSUserDefaults *LoginUser=[NSUserDefaults standardUserDefaults];
    NSString *str = [LoginUser stringForKey:@"accessToken"];
    
    [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];

	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//button up the request body
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	[request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField: @"Content-Length"];
	
	//quite a few lines of code to simply do the business of the HTTP connection....
    NSURLResponse *response;
    NSData *data_reply;
	NSError *err;
	
    data_reply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	
	NSString *stringResponse = [[NSString alloc] initWithData:data_reply encoding:NSUTF8StringEncoding];
    return_value.htmlResponse = stringResponse;
	[stringResponse release];
	
	if (err != nil) {
		//return_value.error = err;
	}
	
	/*
	 * return the json array.  we could parse it, but that would incur overhead 
	 * some users might not want (not to mention dependencies), besides someone 
	 * may want raw strings back, keep it simple.
	 *
	 * See:  http://code.google.com/p/json-framework for an easy json parser
	 */
	
	return return_value;
}

#pragma mark -
#pragma mark UIWebViewDelegate Function

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    /*
//    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Other stuff...
     NSLog(@"webViewDidStartLoad...........");
    if(appDelegate.loadWebFlag == 0)
    {
        loadView=[[UIView alloc] init];
        actView=[[UIActivityIndicatorView alloc] init];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loadView.frame=CGRectMake(130, 150, 60, 60);
            actView.frame= CGRectMake(13,13, 35, 35);
            [actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        } else {
            loadView.frame=CGRectMake(320, 412, 120, 120);
            actView.frame= CGRectMake(43,43, 35, 35);
            [actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        
        
        [loadView setBackgroundColor:[UIColor blackColor]];
        loadView.layer.cornerRadius=4.0f;
        loadView.layer.masksToBounds=YES;
        loadView.alpha=0.90;
        
        
        [webView addSubview:loadView];
        [actView startAnimating];
        [loadView addSubview:actView];
        [loadView setHidden:NO];
        appDelegate.loadWebFlag = 1;
    }
    else
    {
        
    }
    
    */
}
//-(UIWebView *)webView
//{
//    return webView;
//}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Loading: %@", [request URL]);
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
	
	/**
	 * Since there's some server side redirecting involved, this method/function will be called several times
	 * we're only interested when we see a url like:  http://www.facebook.com/connect/login_success.html#access_token=..........
	 */
    [loadView removeFromSuperview];
    [loadView setBackgroundColor:[UIColor clearColor]];
    loadView.frame=CGRectMake(0, 0, 0, 0);
    actView.frame= CGRectMake(0,0, 0, 0);

    [actView stopAnimating];
    [loadView setHidden:YES];
    
	//get the url string
	NSString *url_string = [((_webView.request).URL) absoluteString];
	
	//looking for "access_token="
	NSRange access_token_range = [url_string rangeOfString:@"access_token="];
	
	//looking for "error_reason=user_denied"
	NSRange cancel_range = [url_string rangeOfString:@"error_reason=user_denied"];
	
	//it exists?  coolio, we have a token, now let's parse it out....
	if (access_token_range.length > 0) {
		
		//we want everything after the 'access_token=' thus the position where it starts + it's length
		int from_index = access_token_range.location + access_token_range.length;
		NSString *access_token = [url_string substringFromIndex:from_index];
		
		//finally we have to url decode the access token
		access_token = [access_token stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		//remove everything '&' (inclusive) onward...
		NSRange period_range = [access_token rangeOfString:@"&"];
		
		//move beyond the .
		access_token = [access_token substringToIndex:period_range.location];
		
		//store our request token....
		self.accessToken = access_token;
        
         NSUserDefaults *LoginUser=[NSUserDefaults standardUserDefaults];
        [LoginUser setObject:accessToken forKey:@"accessToken"];
        [LoginUser synchronize];
//		appDelegate.accessTokenStr = self.accessToken;
		//remove our window
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];
		}
		
		[_webView removeFromSuperview];
		
		//tell our callback function that we're done logging in :)
		if ( (callbackObject != nil) && (callbackSelector != nil) ) {
			[callbackObject performSelector:callbackSelector];
		}
		
		//the user pressed cancel
	} else if (cancel_range.length > 0) {
		//remove our window
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];
		}
		
		[_webView removeFromSuperview];
		
		//tell our callback function that we're done logging in :)
		if ( (callbackObject != nil) && (callbackSelector != nil) ) {
			[callbackObject performSelector:callbackSelector];
		}
		
	}
}

-(void) dealloc {
	
	[facebookClientID release];
	[redirectUri release];
	[accessToken release];
	[webView1 release];
    [super dealloc];
}

@end