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
  
  PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
  [testObject setObject:@"bar" forKey:@"foo"];
  [testObject save];
}

@end
