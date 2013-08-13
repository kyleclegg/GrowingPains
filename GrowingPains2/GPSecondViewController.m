//
//  GPSecondViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPSecondViewController.h"
#import <Parse/Parse.h>

@interface GPSecondViewController ()

@end

@implementation GPSecondViewController

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
