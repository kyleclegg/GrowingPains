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
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    //Call your function or whatever work that needs to be done
    //Code in this part is run on a background thread
 
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    
  });
  
}

@end
