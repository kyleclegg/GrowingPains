//
//  GPAppDelegate.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPAppDelegate.h"
#import <Parse/Parse.h>
#import "GPHelpers.h"
#import "GPJournal.h"
#import "GPEntry.h"
#import "GPSidePanelController.h"

@implementation GPAppDelegate

+ (GPAppDelegate *)appDelegate
{
  return (GPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Create pointers for our main two screens
  UINavigationController *masterNav = (UINavigationController *)((GPSidePanelController *)self.window.rootViewController).leftPanel;
  self.journalsController = (GPJournalsViewController *)masterNav.topViewController;
  
  // Set the top level controller
  GPSidePanelController *sidePanel = ((GPSidePanelController *)self.window.rootViewController);
  UINavigationController *nav = (UINavigationController *)sidePanel.centerPanel;
  self.homeController = (GPHomeViewController *)nav.topViewController;
  
  // Parse setup
  [GPJournal registerSubclass];
  [GPEntry registerSubclass];
  [Parse setApplicationId:@"tmitmsSZ3G8OUXmvfkA77uL5JeYDyPcNnBGa3Akl" clientKey:@"MZ6xc5neXB5ZZbrEx92x4tJdqcmmHOa7g1zj71ar"];
  [PFTwitterUtils initializeWithConsumerKey:@"wMnNWNPvnS7tlNZBNIQhGg" consumerSecret:@"DMQZAm9LKxxHogSQIZW50suhomusi8pbHyirl9sTFTI"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  [self customizeAppearance];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeAppearance
{
  [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor whiteColor], NSForegroundColorAttributeName,
    [UIFont fontWithName:@"HelveticaNeue-Thin" size:22.0], NSFontAttributeName,nil]];

  NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
  
}

@end
