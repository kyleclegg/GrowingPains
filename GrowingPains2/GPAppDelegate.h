//
//  GPAppDelegate.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPJournalsViewController.h"
#import "GPHomeViewController.h"

@interface GPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GPJournalsViewController *journalsController;
@property (strong, nonatomic) GPHomeViewController *homeController;

+ (GPAppDelegate *)appDelegate;

@end
