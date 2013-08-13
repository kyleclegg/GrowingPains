//
//  GPSecondViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPEntryViewController.h"
#import <Parse/Parse.h>

@interface GPEntryViewController ()

@end

@implementation GPEntryViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

}

#pragma mark - Actions

- (IBAction)logOutPressed:(id)sender
{
  [self.tabBarController performSegueWithIdentifier:@"Login" sender:self];
  [PFUser logOut];
}

@end
