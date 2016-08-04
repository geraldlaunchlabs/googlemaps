//
//  AppDelegate.m
//  gMaps
//
//  Created by LLDM on 04/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;


#import "JAAppDelegate.h"

#import "JASidePanelController.h"
#import "JACenterViewController.h"
#import "JALeftViewController.h"
#import "JARightViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


NSString *APIKey = @"AIzaSyD4tNWj_YczPH2riZWVLz_ZNiNGX5yxCkw";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSServices provideAPIKey:APIKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = [[JALeftViewController alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[JACenterViewController alloc] init]];
    self.viewController.rightPanel = [[JARightViewController alloc] init];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    //[GMSPlacesClient provideAPIKey:APIKey];
    
    // Override point for customization after application launch.
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
