//
//  RGFacebookManager.h
//  BluetoothCrashDetector
//
//  Created by i-MaC on 8/13/13.
//  Copyright (c) 2013 One Click IT Consultancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"


@class SaveDesignVewcontroller;
@class WCAppDelegate;

@protocol showFacebookData <NSObject>

-(void)getFbData:(NSDictionary *)fbUser;
-(void)getprocessHud;
-(void)gethideHud;

//-(void)hideindicator;
//-(void)joineeShowIndicator;

@end
@protocol RGFacebookManagerDelegate

@optional

-(void)gettingAlbums:(id)result;
-(void)publishStory;
-(void)updateBtnImage;

@required

@end

@interface RGFacebookManager : NSObject
{

    NSString                         *userImageURL;
    NSData                           *imgData;
    NSMutableArray                   *userArray;
    NSMutableDictionary              *jsonDictData;
    BOOL                             flag;
    AppDelegate                    *appDelegate;
    
    NSString * genderStr ;

    NSMutableArray *myIntestArr;
    
    NSString *emailStr;
    
    


}
+(RGFacebookManager*)facebookManager;
@property (nonatomic,assign) id <RGFacebookManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) FBSession *rgFBSession;
@property (nonatomic,assign) BOOL isRGFBlogedin;
@property (nonatomic,assign) BOOL isFromLogin;
@property (nonatomic,copy) NSString *isFromView;

-(void)login;
-(void)logout;
-(void)PostMessage;
-(void)getPhotosFromFaceBook:(NSString *)str;
-(void)getAlbumsFromFaceBook;

@property (nonatomic, retain) id<showFacebookData> Showdelegate;

@property BOOL fbFromCreate;
@end
