//
//  AppDelegate.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [[UINavigationBar appearance] setTranslucent:false];
  
  [[UILabel appearance] setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15.0]];
  
//  UITabBarController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TAB_BAR"];
//  self.window.rootViewController = rootController;
//  //UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
// 
//  UITabBar *tabBar = rootController.tabBar;
//  
//  UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
//  UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
//  UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
//  UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
//  tabBar.translucent = NO;
//  tabBar.barTintColor = [UIColor whiteColor];
//  
//  UIImage *image1 = [UIImage imageNamed:@"ottoactivity.png"];
//  UIImage *image2 = [UIImage imageNamed:@"ottostart.png"];
//  UIImage *image3 = [UIImage imageNamed:@"ottoid.png"];
//  UIImage *image4 = [UIImage imageNamed:@"ottoaccident.png"];
//  
//  tabBarItem1 = [tabBarItem1 initWithTitle:@"Activity" image:image1 selectedImage:image1];
//  tabBarItem2 = [tabBarItem1 initWithTitle:@"Start/Stop" image:image2 selectedImage:image2];
//  tabBarItem3 = [tabBarItem1 initWithTitle:@"Card" image:image3 selectedImage:image3];
//  tabBarItem4 = [tabBarItem1 initWithTitle:@"Accident" image:image4 selectedImage:image4];
//  
// [self.window setRootViewController:rootController];
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
