//
//  URLManager.m
//  Smiggle
//
//  Created by SPEC on 21/02/11.
//  Copyright 2011 ONE CLICK. All rights reserved.
//

#import "URLManager.h"
#import "JSON1.h"

@implementation URLManager
@synthesize delegate;
@synthesize commandName;
@synthesize isString;

#pragma mark -
#pragma mark Network Call Methods
#pragma mark -


- (void)urlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary {
	
	NSString * urlStr = [NSString stringWithFormat:@"%@", path];
	//NSLog(@"URL = %@",urlStr);
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	
	if (dictionary!=nil) {

        NSString *requestStr = [self postStringForTAgsFromDictionary:dictionary]; //use for withoutjson

		NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
		[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        NSString *token=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalCode"];
        NSString *authorization = [NSString stringWithFormat: @"Basic %@",token];
        [theRequest setValue:authorization forHTTPHeaderField:@"Authorization"];
        
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[theRequest setHTTPBody:requestData];
	}
    


	[theRequest setURL:[NSURL URLWithString:urlStr]];
    [theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:30];
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection)
    {
		receivedData = [[NSMutableData data] retain];
    }
}

- (void)getUrlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary {
    //NSLog(@"abc");
	 
	NSString * urlStr = [NSString stringWithFormat:@"%@",path];
	NSLog(@"URL = %@",urlStr);
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	if (dictionary!=nil) {
        
		NSString *requestStr = [self getStringFromDictionary:dictionary];
        urlStr = [NSString stringWithFormat:@"%@?%@",path,requestStr];
        //NSLog(@"the url string is %@",urlStr);
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	}
    
	[theRequest setURL:[NSURL URLWithString:urlStr]];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:30];
	  //NSLog(@"the main connection is %@",theRequest);
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) 
		receivedData = [[NSMutableData data] retain];
}
- (NSString *)getStringFromDictionary:(NSMutableDictionary*)dictionary {
	NSString *argumentStr = @"";
	
	NSArray *myKeys = [dictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	for (int i=0 ; i<[sortedKeys count]; i++)  {
		if ( i != 0) 
			argumentStr = [argumentStr stringByAppendingString:@"&"];
        
		NSString *key = [sortedKeys objectAtIndex:i];
		NSString *value = [dictionary objectForKey:key];
		
		NSString *formateStr = [NSString stringWithFormat:@"%@=%@",key,value];
		argumentStr = [argumentStr stringByAppendingString:formateStr];
	}
	
//	NSLog(@"Request %@",argumentStr);
	return argumentStr;
}

- (NSString *)postStringFromDictionary:(NSMutableDictionary*)dictionary {
	NSString *argumentStr = @"";
	
	NSArray *myKeys = [dictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	for (int i=0 ; i<[sortedKeys count]; i++)  {
		if ( i != 0)
			argumentStr = [argumentStr stringByAppendingString:@"&"];
        
		NSString *key = [sortedKeys objectAtIndex:i];
		NSString *value = [dictionary objectForKey:key];
		
		if ([value isKindOfClass:[NSString class]]) {
			value = [value stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
			value = [value stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
			value = [value stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
			value = [value stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
			value = [value stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			value = [value stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
			value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
			value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
//			value = [value stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
		}
		NSString *formateStr = [NSString stringWithFormat:@"%@=%@",key,value];
		argumentStr = [argumentStr stringByAppendingString:formateStr];
	}
	
//	NSLog(@"Request %@",argumentStr);
	return argumentStr;
}

- (NSString *)postStringForTAgsFromDictionary:(NSMutableDictionary*)dictionary {
	NSString *argumentStr = @"";
	BOOL isDichaveArray=NO;
	NSArray *myKeys = [dictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	for (int i=0 ; i<[sortedKeys count]; i++)  {
		if ( i != 0)
			argumentStr = [argumentStr stringByAppendingString:@"&"];
        
		NSString *key = [sortedKeys objectAtIndex:i];
        NSLog(@"key %@",key);
        
        id value = [dictionary objectForKey:key];

        if ([key isEqualToString:@"synchDataJson"])
        {
            NSString * myString=[dictionary objectForKey:key];
            myString= [myString stringByReplacingOccurrencesOfString:@"\n"
                                                           withString:@""];
            value=myString;
        }
        
        NSLog(@" value %@",value);
		
		if ([value isKindOfClass:[NSString class]]) {
			value = [value stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
			value = [value stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
			value = [value stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
			value = [value stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
			value = [value stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			value = [value stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
			value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
			value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
            //			value = [value stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
            isDichaveArray=NO;
		}
        else if ([value isKindOfClass:[NSMutableArray class]])
        {
            isDichaveArray=YES;
            for (int i=0 ; i<[value count]; i++)
            {
                if ( i != 0)
                argumentStr = [argumentStr stringByAppendingString:@"&"];
                
              NSString *value2 = [value objectAtIndex:i];
                if ([value2 isKindOfClass:[NSString class]]) {
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
                    //			value = [value stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
                   }
                if (isDichaveArray==YES) {
                    NSLog(@"key2 %@",key);
                NSString *formateStr = [NSString stringWithFormat:@"%@=%@",key,value2];
                argumentStr = [argumentStr stringByAppendingString:formateStr];
                    NSLog(@"argumstr %@",argumentStr);
                }
            }// for mutable array
        } // else of 
		if (isDichaveArray==NO) {
            NSString *formateStr = [NSString stringWithFormat:@"%@=%@",key,value];
            argumentStr = [argumentStr stringByAppendingString:formateStr];

        }
	}
	
//	NSLog(@"Request %@",argumentStr);
	return argumentStr;
}

/* 
 //========= post image to server
 http://stackoverflow.com/questions/8564833/ios-upload-image-and-text-using-http-post
 // create request
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
 [request setHTTPShouldHandleCookies:NO];
 [request setTimeoutInterval:30];
 [request setHTTPMethod:@"POST"];
 
 // set Content-Type in HTTP header
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
 [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
 
 // post body
 NSMutableData *body = [NSMutableData data];
 
 // add params (all params are strings)
 for (NSString *param in _params) {
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
 }
 
 // add image data
 NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
 if (imageData) {
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:imageData];
 [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 }
 
 [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
 // setting the body of the post to the reqeust
 [request setHTTPBody:body];
 
 // set the content-length
 NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
 [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
 
 // set URL
 [request setURL:requestURL];
 */





#pragma mark -
#pragma mark NSURLConnection Methods
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    [receivedData release];
	
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	[delegate onError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	[receivedData release];
	
	//NSLog(@"The response is...%@", responseString);
	
	if (self.isString) {
        if (commandName!=nil && commandName!=NULL)
        {
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            [result setObject:responseString forKey:@"result"];
            [result setObject:commandName forKey:@"commandName"];
            
            if (delegate)
                [delegate onResult:result];
            
            [result release];
        }
        else {
            
            if (delegate)
                [delegate onResult:responseString];
        }
		
	}
	else {
		NSError *error;
		SBJSON *json = [[SBJSON new] autorelease];
		
		NSDictionary *response = [json objectWithString:responseString error:&error];
		[responseString release];
		if (response == nil ) {
			
		}
		else {
			if (commandName!=nil && commandName!=NULL) {
				NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
				[result setObject:response forKey:@"result"];
				[result setObject:commandName forKey:@"commandName"];
				
				if (delegate)
					[delegate onResult:result];
				
				[result release];
			}
			else {
				
				if (delegate)
					[delegate onResult:response];
				
			}
		}
		
	}
    
}

#pragma mark -
#pragma mark Cleanup Methods
#pragma mark -

- (void) dealloc {
	[commandName release];
	[super dealloc];
}

@end
