//
//  RGFacebookManager.m
//  BluetoothCrashDetector
//
//  Created by i-MaC on 8/13/13.
//  Copyright (c) 2013 One Click IT Consultancy. All rights reserved.
//

#import "RGFacebookManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
static RGFacebookManager *facebookManager = nil;
NSString *const FBSessionStateChangedNotification =
@"com.snuzo.snuzoapp";
@implementation RGFacebookManager
@synthesize postParams;
@synthesize isRGFBlogedin;
@synthesize rgFBSession;
@synthesize Showdelegate;
@synthesize isFromLogin;
@synthesize isFromView;
@synthesize  fbFromCreate;
#pragma mark -
#pragma mark - DataBaseManager initialization
-(id) init
{
    self = [super init];
    if (self)
    {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        //appfbSession=[[FBSession alloc] init];
    }
    return self;
}
+(RGFacebookManager*)facebookManager
{
    if(facebookManager==nil)
    {
        facebookManager = [[RGFacebookManager alloc]init];
    }
    return facebookManager;
}


-(void)login
{
    
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    //    [self.Showdelegate getprocessHud];
    //    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
     NSLog(@"%c",[self openSessionWithAllowLoginUI:YES]);
    // [self openSessionWithAllowLoginUI:YES];
    //        fbButton.tag=1; // login
    //        btn.tag=1;
}
/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_actions,user_photos,publish_stream,email,user_birthday", nil];
    
    
   // NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile,email,publish_actions,user_birthday,user_education_history,user_work_history,user_friends,user_photos,user_interests,user_likes,user_relationships,user_relationship_details", nil];
    
    
    
    return [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error)
            {
                // Check for publish permissions
                [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                          if (!error){
                                              // Walk the list of permissions, see if publish_actions has been granted
                                              NSArray *permissions = (NSArray *)[result data];
                                              BOOL publishActionsSet = FALSE;
                                              
                                              for (NSDictionary *perm in permissions) {
                                                  if ([[perm objectForKey:@"status"] isEqualToString:@"declined"])
                                                  {
                                                      publishActionsSet = TRUE;
                                                       NSLog(@"publish_actions granted.");
                                                      break;
                                                  }
                                              }
                                              if (publishActionsSet)
                                              {
                                                  [FBRequestConnection startWithGraphPath:@"/me/permissions/"
                                                                               parameters:nil
                                                                               HTTPMethod:@"delete"
                                                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
                                                                        }];
                                                  
                                                  UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please allow to share your facebook information with Snuzo App." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                  [alert show];
                                                  
                                                  
                                              } else
                                              {
                                                  [self sessionStateChanged:session state:state error:error];//kp17-3
                                              }
                                              
                                          } else
                                          {
                                              
                                          }
                                      }];
            }];
    
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
            
        case FBSessionStateOpen:
        {
            
            
             NSLog(@"FBSessionStateOpen in Status");
            if (!error) {
                 NSLog(@"User session found");
                
                [FBRequestConnection startWithGraphPath:@"/me/"
                                             parameters:nil
                                             HTTPMethod:@"GET"
                                      completionHandler:^(
                                                          FBRequestConnection *connection,id result,NSError *error) {
                                          
                                           NSLog(@"kalpesh data %@",result);
                                          
                                          genderStr =[result objectForKey:@"gender"];
                                          
                                          
                                               NSLog(@"userdefine array:%@",jsonDictData);
                                              
                                              isRGFBlogedin=YES;
                                              
                                              [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"fbLogin"];
                                              [[NSUserDefaults standardUserDefaults]synchronize];
                                          [self loginWebServiceMethod];

                                              /*
                                              if (isFromLogin)
                                              {
                                                  [self checkForGirls];
                                              }
                                              else
                                              {
                                                   NSLog(@"not from Login");
                                                  //                    [self loginWebServiceMethod];
                                                  if ([isFromView isEqualToString:@"SharingView"])
                                                  {
                                                      //                        [[self delegate]publishStory];
                                                  }
                                                  else if([isFromView isEqualToString:@"AlbumsView"])
                                                  {
                                                      [self getAlbumsFromFaceBook];
                                                  }
                                              }
                                          
                                          */
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          /* handle the result */
                                      }];
                
                
                
                
                
                
            }
            
            break;
        }
        case FBSessionStateClosed:
        {
             NSLog(@"FBSessionStateClosed in Status");
            [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"fbLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            isRGFBlogedin=NO;
             NSLog(@" Not Loggedin");
            
            //[self loginToFacebook];
        }
        case FBSessionStateClosedLoginFailed:
        {
            // Handle the logged out scenario
            //            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            [self.Showdelegate gethideHud];
             NSLog(@"FBSessionStateClosedLoginFailed in Status");
            //[self loginToFacebookCompleted];
            // Close the active session
            [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"fbLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            isRGFBlogedin=NO;
             NSLog(@" Not Loggedin");
            [FBSession.activeSession closeAndClearTokenInformation];
            //[rgFBSession closeAndClearTokenInformation];
            // You may wish to show a logged out view
            
            break;
        }
        default:
            break;
    }
    if (error)
    {
        // Handle authentication errors
    }
}

-(void)postingFb
{
    {
        
        
        if (!FBSession.activeSession.isOpen) {
            [FBSession openActiveSessionWithAllowLoginUI: YES];
        }
        
        
        // NOTE: pre-filling fields associated with Facebook posts,
        // unless the user manually generated the content earlier in the workflow of your app,
        // can be against the Platform policies: https://developers.facebook.com/policy
        
        // Put together the dialog parameters
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Wing Chick", @"name",
                                       @"Stay in touch with your near by chicks.", @"caption",
                                       @"kkkkkpppppp", @"description",
                                       @"http://www.wingchick.com/", @"link",
                                       @"http://oneclickitsolution.com//wingchicks/wc2.png", @"picture",
                                       nil];
        
        // Make the request
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Link posted successfully to Facebook
                                       NSLog(@"result: %@", result);
                                      [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                  } else
                                  {
                                      
                                      
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                       NSLog(@"%@", error.description);
                                  }
                              }];
    }
}

-(void)checkForGirls
{
     NSLog(@"from Login");
    
    
    //[self postingFb];//jam30-3
    
    
//    [(appDelegate *)[[UIApplication sharedApplication] delegate] hudForprocessMethod];
    
    
//    [self getFacebookFriends];
    
     NSLog(@"Login Successfully");
    
    //                [self loginWebServiceMethod];
    
    //For frined's personel details
    [FBRequestConnection startWithGraphPath:@"/me/"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         
          NSLog(@"kalpesh data %@",result);
         
     /*    emailStr =[result objectForKey:@"id"];
         NSMutableDictionary *dicttt =[[NSMutableDictionary alloc] init];
         URLManager *manager = [[URLManager alloc] init];
         manager.delegate = self;
         manager.commandName = @"getStatus";
         [dicttt setObject:@"checkUserFbId" forKey:@"action"];
         [dicttt setObject:emailStr forKey:@"fb_id"];
         [manager getUrlCall:GlobalWebServiceUrl withParameters:dicttt];*/
         /* handle the result */
     }];
    //                    [self loginWebServiceMethod];
    
}

-(void)logout
{
    [self closeSession];
}
-(void)getPhotosFromFaceBook:(NSString *)str{
     NSLog(@"%s",__PRETTY_FUNCTION__);
    
    NSString *path=[NSString stringWithFormat:@"%@/photos",str];
     NSLog(@"path is %@",path);
    
    [FBRequestConnection
     startWithGraphPath:path
     parameters:nil
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error)
     {
         NSString *alertText;
         if (error)
         {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %ld",
                          error.domain, (long)error.code];
              NSLog(@"alertText is %@",alertText);
             
             
         }
         else
         {
             
             [self.delegate gettingAlbums:result];
             
              NSLog(@"result is %@",result);
             
             //             alertText = [NSString stringWithFormat:
             //                          @"Posted action, id: %@",
             //                          [result objectForKey:@"id"]];
             
         }
         // Show the result in an alert
         //         [[[UIAlertView alloc] initWithTitle:@"Result"
         //                                     message:alertText
         //                                    delegate:self
         //                           cancelButtonTitle:@"OK!"
         //                           otherButtonTitles:nil]
         //          show];
          NSLog(@"result got succesfully");
     }];
    
    
    
}

-(void)getAlbumsFromFaceBook
{
     NSLog(@"%s",__PRETTY_FUNCTION__);
    [FBRequestConnection
     startWithGraphPath:@"me/albums"
     parameters:nil
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error)
         {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %ld",
                          error.domain, (long)error.code];
              NSLog(@"alertText is %@",alertText);
             
             
         }
         else
         {
             
             [self.delegate gettingAlbums:result];
             
              NSLog(@"result is %@",result);
             
             //             alertText = [NSString stringWithFormat:
             //                          @"Posted action, id: %@",
             //                          [result objectForKey:@"id"]];
             
         }
         // Show the result in an alert
         //         [[[UIAlertView alloc] initWithTitle:@"Result"
         //                                     message:alertText
         //                                    delegate:self
         //                           cancelButtonTitle:@"OK!"
         //                           otherButtonTitles:nil]
         //          show];
          NSLog(@"result got succesfully");
     }];
    
}

-(void)PostMessage
{
    [[self delegate] publishStory];
    /*
      NSLog(@"post fb message ");
     if (FBSession.activeSession.isOpen) {
     // Ask for publish_actions permissions in context
     if ([FBSession.activeSession.permissions
     indexOfObject:@"publish_actions"] == NSNotFound) {
     
     // No permissions found in session, ask for it
     [FBSession.activeSession
     requestNewPublishPermissions:
     [NSArray arrayWithObject:@"publish_actions"]
     defaultAudience:FBSessionDefaultAudienceFriends
     completionHandler:^(FBSession *session, NSError *error) {
     if (!error) {
     // If permissions granted, publish the story
     
     //                     [FBSession setActiveSession:session];
     
     [[self delegate] publishStory];
     }
     }];
     }
     else {
     // If permissions present, publish the story
     [[self delegate] publishStory];
     NSLog(@"posted");
     }
     
     
     } else {
     //        UIAlertView *fbAlert=[[UIAlertView alloc] initWithTitle:@"Facebook Login" message:@"Please login facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
     //
     //        [fbAlert show];
     //         NSLog(@"%c", [self openSessionWithAllowLoginUI:NO]);
     // [self openSessionWithAllowLoginUI:NO];
     [[self delegate] publishStory];
      NSLog(@"no session");
     }*/
    
}

/*
 * Callback for session changes.
 */

- (void) closeSession
{
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"fbLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    isRGFBlogedin=NO;
    [FBSession.activeSession closeAndClearTokenInformation];
    
    //    if (FBSession.activeSession)
    //    {
    //         NSLog(@"kkkkkkkk");
    //    }
    //    else
    //    {
    //         NSLog(@"ppppppp");
    //
    //    }
    //
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)getRecentCheckins {
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   @"checkin",@"type",nil];
    //
    //
    //
    //    [FBRequest requestWithGraphPath:@"search" andParams: params andDelegate:self];
    
}
#pragma mark WebServiceMethod
-(void)checkFBEvents
{
    [FBRequestConnection startWithGraphPath:@"me/events"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         
          NSLog(@"my events result =%@",result);
         
         NSMutableArray *eventArr =[[NSMutableArray alloc] init];
         eventArr=[[result objectForKey:@"data"] mutableCopy];
         
         [[NSUserDefaults standardUserDefaults] setObject:eventArr forKey:@"allEvent"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         
         
         
         //                              [self parsetInterest];
         //                              [self createEvent:@"KPtest" Eventdesc:@"Today itself" EventDate:@"1297641600"];
         /* handle the result */
     }];
}
- (NSInteger)age:(NSDate *)dateOfBirth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    }
    else
    {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}
-(void)loginWebServiceMethod
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookEnable" object:nil];
    
    
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
    
    
    /*************************For frined's personel details********************/
    
    
         NSLog(@"Token is available");
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                  NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
                  NSLog(@"Fetched User Information:%@", result);
                 
                // [self checkUserEmailRegisterInDBWebServiceWithFacebookDict:result];
             }
             else {
                  NSLog(@"Error %@",error);
             }
         }];
        
    

    
    [FBRequestConnection startWithGraphPath:@"/me"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                               NSLog(@"kalpesh data %@",result);
                              
                       
                              
                              
                              NSString *emailStr1 =[result objectForKey:@"email"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",emailStr1] forKey:@"email"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"first_name"] forKey:@"firstName"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"gender"] forKey:@"gender"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"id"] forKey:@"facebookId"];
                              
                              NSString *imgStr= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]];
                              
//                              globleImgUrl=imgStr;
                              [[NSUserDefaults standardUserDefaults] setObject:imgStr forKey:@"currentImage"];
                              
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"last_name"] forKey:@"lastname"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"location"] forKey:@"currentLocation"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"name"] forKey:@"fullName"];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[result objectForKey:@"quotes"] forKey:@"quotes"];
                              
                              
                              /* handle the result */
                          }];
    
    
    /*************************for facebook Friends*****************************/
    
    
    
    
    

    
    
}


//-(void)otherMethod
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [delegate facebook].accessToken, @"access_token",
//                                   @"Going To Eat!", @"name",
//                                   @"description of the event", @"description",
//                                   @"2012-08-20T17:00:00+0000", @"start_time",
//                                   @"2012-08-21T17:00:00+0000", @"end_time",
//                                   @"Carlsbad", @"city",
//                                   @"CA", @"state",
//                                   @"900 safe street", @"street",
//                                   @"OPEN", @"privacy",
//                                   @"https://.../img/faces/pizza-port-brewing-carlsbad.jpg", @"@file.jpg",
//                                   nil];
//
//    [[delegate facebook] requestWithGraphPath:@"me/events"
//                                    andParams:params
//                                andHttpMethod:@"POST"
//                                  andDelegate:self];
//
//
//}


- (UIImage *)imageWithURLString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}



/*
#pragma mark Response
- (void)onResult:(NSDictionary *)result
{
    if([[result valueForKey:@"commandName"] isEqualToString:@"getStatus"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"response"] isEqualToString:@"true"])
        {
            
            //            [self checkFBEvents];
             NSLog(@"the server data is =%@",result);
            
            
            allProfilePics=[[NSMutableArray alloc] init];
            allProfilePics=[[[result objectForKey:@"result"]objectForKey:@"data"] objectForKey:@"userPhotos"];
            
            if ([allProfilePics count]==0)
            {
                allProfilePics=[[NSMutableArray alloc] init];

                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"currentImage"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[allProfilePics objectAtIndex:0]] forKey:@"currentImage"];


            }
            
            
            
            
            NSMutableArray *totalPlc =[[NSMutableArray alloc] init];
            totalPlc=[[[result objectForKey:@"result"]objectForKey:@"data"] objectForKey:@"place"];
            
            NSMutableArray *totalInts =[[NSMutableArray alloc] init];
            totalInts=[[[result objectForKey:@"result"]objectForKey:@"data"] objectForKey:@"interest"];
            
            [[NSUserDefaults standardUserDefaults] setObject:allProfilePics forKey:@"ProfilePics"];
            
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"status"] forKey:@"userStatus"];
            
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"age"] forKey:@"age"];
            
            NSString *emailStr1 =[result objectForKey:@"email"];
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"email"] forKey:@"email"];
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"name"] forKey:@"firstName"];
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"level_color"] forKey:@"level_color"];
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"level"] forKey:@"level"];
            
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"title"] forKey:@"title"];
            
            
            [[NSUserDefaults standardUserDefaults]setValue:[[result objectForKey:@"result"] objectForKey:@"facebook_id"] forKey:@"facebookId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:[[result objectForKey:@"result"] objectForKey:@"occupation"] forKey:@"occupation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:[[result objectForKey:@"result"] objectForKey:@"status"] forKey:@"status"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:totalInts forKey:@"thingsPicked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[totalInts count]] forKey:@"totalThings"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:totalPlc forKey:@"placesPicked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[totalPlc count]] forKey:@"totalPlaces"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:[[result objectForKey:@"result"] objectForKey:@"user_id"] forKey:@"userId"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [(appDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoHomeView" object:nil];
            
            
            [self setToken];
            
        }
        else
        {
            [(appDelegate *)[[UIApplication sharedApplication] delegate] hudEndProcessMethod];
            
            [self loginWebServiceMethod];
            
            
        }
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"setToken"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"response"] isEqualToString:@"true"])
        {
             NSLog(@"successfully Token added");
        }
    }
    
    
    
    
    
}
- (void)onError:(NSError *)error
{
     NSLog(@"The error is...%@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookEnable" object:nil];
    
    
    //    [self hideProgressBar];
    int ancode = [error code];
    if (ancode == -1009) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connectivity" message:@"There is no network connectivity. This application requires a network connection."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//         [alert showWithAnimation:URBalertAnimationType];;
        
        
        
        
    }
    else if(ancode == -1001)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The request time out."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//         [alert showWithAnimation:URBalertAnimationType];;
        
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
        
        
    }
    
}
*/
#pragma mark Alert Delegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 200)
    {
        //        [appDelegate.belovedlink_btn setHidden:NO];
        //        [(appDelegate *)[[UIApplication sharedApplication] delegate] setSlideRootNavigation];
        
        
        
        
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoHomeView" object:nil];
        
        
        
    }
}


#pragma mark - Helper methods

/*
 * This sets up the placeholder text.
 */
- (void)resetPostMessage
{
    //self.postMessageTextView.text = kPlaceholderPostMessage;
    //self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

/*
 * Publish the story
 */
- (void)publishStory
{
    NSString *postmsg=[NSString stringWithFormat:@"Test message from Bluetooth APP %@",[NSDate date]];
    //    NSString *logoPath = [[[NSBundle mainBundle] resourcePath]
    //                          stringByAppendingPathComponent:@"wclogo.png"];
    
    self.postParams =[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      postmsg,@"message"
                      ,nil];
    
     NSLog(@"%s",__PRETTY_FUNCTION__);
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %ld",
                          error.domain, (long)error.code];
             
             
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
          NSLog(@"posted succesfully");
     }];
    
}
- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}
@end
