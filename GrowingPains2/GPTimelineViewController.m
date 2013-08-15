//
//  GPFirstViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPTimelineViewController.h"
#import <Parse/Parse.h>

@interface GPTimelineViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSArray *images;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;

@end

@implementation GPTimelineViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.images = @[ @"evaplane.png", @"evasilly.png", @"evafish.png", @"evadress.png"];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  PFUser *currentUser = [PFUser currentUser];
  if (!currentUser)
    [self performSegueWithIdentifier:@"Login" sender:self];
  
  [self setupGestureRecognizers];
//  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//  NSTimer* timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(gravityIt) userInfo:nil repeats:YES];
//  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  self.animator = nil;
}

- (void)setupGestureRecognizers
{
  self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationRecognizerFired:)];
  [self.view addGestureRecognizer:self.rotationRecognizer];
  [self.rotationRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
  
  self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizerFired:)];
  [self.view addGestureRecognizer:self.pinchRecognizer];
  [self.pinchRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
  
  self.rotationRecognizer.delegate = self;
  self.pinchRecognizer.delegate = self;
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

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.images.count * 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"EntryCell";
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  UIImageView *iv = (UIImageView *)[cell viewWithTag:100];
  if (indexPath.row < 4)
    iv.image = [UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];
  else
    iv.image = [UIImage imageNamed:[self.images objectAtIndex:0]];
  
  return cell;
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  return (gestureRecognizer == self.rotationRecognizer && otherGestureRecognizer == self.pinchRecognizer)
        || (gestureRecognizer == self.pinchRecognizer && otherGestureRecognizer == self.rotationRecognizer);
}

#pragma mark - Gestures Fired

- (void)rotationRecognizerFired:(UIRotationGestureRecognizer *)recognizer
{
  NSString *text = [NSString stringWithFormat:@"Rotated! (r: %0.2f, v: %0.2f)",
                    recognizer.rotation, recognizer.velocity];
  NSLog(@"%@", text);
}

- (void)pinchRecognizerFired:(UIPinchGestureRecognizer *)recognizer
{
  NSString *text = [NSString stringWithFormat:@"Pinched! (s: %0.2f, v: %0.2f)",
                    recognizer.scale, recognizer.velocity];
  NSLog(@"%@", text);
  
  CGPoint point = [recognizer locationInView:self.view];
  NSLog(@"the point is %@", NSStringFromCGPoint(point));
}

#pragma mark - Gesture Recognizer State Monitoring

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(UIGestureRecognizer *)recognizer
                        change:(NSDictionary *)change
                       context:(void *)context
{
  NSLog(@"Gesture recognizer changed");
}


@end
