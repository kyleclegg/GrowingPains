//
//  GPTabBarViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPTabBarViewController.h"
#import <Parse/Parse.h>

@interface GPTabBarViewController ()

@end

@implementation GPTabBarViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  

  PFUser *currentUser = [PFUser currentUser];
  if (!currentUser)
    [self performSegueWithIdentifier:@"Login" sender:self];
}

@end
