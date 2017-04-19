//
//  URLManager.h
//  Smiggle
//
//  Created by SPEC on 21/02/11.
//  Copyright 2011 ONE CLICK. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UniversalObject.h"
NSString *responseString;
@protocol URLManagerDelegate

- (void)onResult:(NSDictionary *)result;
- (void)onError:(NSError *)error;

@end


@interface URLManager : NSObject  {
	NSMutableData *receivedData;
	id<URLManagerDelegate> delegate;
	NSString *commandName;
	BOOL isString;
}

@property (nonatomic, retain) id<URLManagerDelegate> delegate;
@property (nonatomic, retain) NSString *commandName;
@property (nonatomic, assign) BOOL isString;

- (void)urlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary;
- (NSString *)postStringFromDictionary:(NSMutableDictionary*)dictionary;
- (void)getUrlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary;
- (NSString *)getStringFromDictionary:(NSMutableDictionary*)dictionary;
- (NSString *)postStringForTAgsFromDictionary:(NSMutableDictionary*)dictionary;
@end
