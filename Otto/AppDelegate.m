//
//  AppDelegate.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "AppDelegate.h"
#import "AppUtils.h"
#import <Parse/Parse.h>
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Initialize Parse.
  [Parse setApplicationId:@"bEJfrFMvMLFh29yOgLsLvNL5HB9oMrJaFreCw2V4" clientKey:@"yakPkhvmFrk6heIfESd5xbwt7Ks6tc1NksxnviMu"];
  [PFUser enableRevocableSessionInBackground];
  
  // Track statistics around application opens.
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  // Customize navigation bar appearance
  [[UINavigationBar appearance] setTranslucent:false];
  [[UINavigationBar appearance] setBarTintColor:globalColor];
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:15.0], NSFontAttributeName, nil]];
  
  // Customize default font for labels
  [[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0]];
  
  [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                  didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
}

//for login purposes
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}

@end
