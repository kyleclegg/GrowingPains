//
//  GPFirstViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPTimelineViewController.h"
#import <Parse/Parse.h>

@interface GPTimelineViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation GPTimelineViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
 
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  PFUser *currentUser = [PFUser currentUser];
  if (!currentUser)
    [self performSegueWithIdentifier:@"Login" sender:self];
  
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//  NSTimer* timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(gravityIt) userInfo:nil repeats:YES];
//  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  self.animator = nil;
}

- (void)gravityIt
{
  UIView *box = [[UIView alloc] init];
  [box setFrame:CGRectMake(100, 100, 50, 50)];
  [box setBackgroundColor:[UIColor redColor]];
  [self.view addSubview:box];
  
  UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[ box ]];
  [self.animator addBehavior:gravityBehavior];
}

@end
