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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Initialize Parse.
  [Parse setApplicationId:@"q29iMM7Y2t9qmfheI3LX5agt3eTFvQmUkuGYtYtC" clientKey:@"pcrzLIXaRMb1m3uFlFwaZSoAkGKCHCGpoRxHpTwP"];
  [PFUser enableRevocableSessionInBackground];
  
  // Track statistics around application opens.
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  // Customize navigation bar appearance
  [[UINavigationBar appearance] setTranslucent:false];
  [[UINavigationBar appearance] setBarTintColor:globalColor];
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:15.0], NSFontAttributeName, nil]];
  
  // Customize default font for labels
  [[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0]];
  
  UITabBarController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TAB_BAR"];
  
  // Customize default tab bar item appearance
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:13.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
 
 [self.window setRootViewController:rootController];
  return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
}


@end
