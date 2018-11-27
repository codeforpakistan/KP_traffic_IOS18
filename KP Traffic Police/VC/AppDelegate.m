//
//  AppDelegate.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 28/06/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBtAjDLDYeqxyiWKhzmvCQMonsd_6RiZKw"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyBtAjDLDYeqxyiWKhzmvCQMonsd_6RiZKw"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

//    self.window.rootViewController = [storyboard instantiateInitialViewController];
//    [self.window makeKeyAndVisible];
    
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:@"login_status"];
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;

    if (!check) {
        LoginVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [navController pushViewController:vc animated:NO];
    }
    else{
        SWRevealViewController *rootController = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        _window.rootViewController = rootController;
        [self.window makeKeyAndVisible];
    }
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bar1"] forBarMetrics:UIBarMetricsDefault];

    
    [Fabric with:@[[Crashlytics class]]];
    [FIRApp configure];
    
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 1],
                                     kFIRParameterItemName:@"SplashScreen"
                                     }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
