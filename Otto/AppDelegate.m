//
//  AppDelegate.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Initialize Parse.
  [Parse setApplicationId:@"KuDl7XQpzQhJsPagB4It6e5sL1wjODwiXVjVscHZ"
                clientKey:@"zXTm0PGu3d76qLQNAYwfohwgxs5J93fMHZZoWyxS"];
  
  // Track statistics around application opens.
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  // Customize navigation bar appearance
  [[UINavigationBar appearance] setTranslucent:false];
  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:81/255.0 green:191/255.0 blue:243/255.0 alpha:1.0]];
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15.0], NSFontAttributeName, nil]];
  
  // Customize default font for labels
  [[UILabel appearance] setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15.0]];
  
  UITabBarController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TAB_BAR"];
  
  // Customize default tab bar item appearance
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:13.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
 
 [self.window setRootViewController:rootController];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
