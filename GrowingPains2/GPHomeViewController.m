//
//  GPFirstViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPHomeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "GPAddEntryViewController.h"
#import "GPAppDelegate.h"
#import "GPSidePanelController.h"
#import "GPEntry.h"
#import <Parse/Parse.h>

@interface GPHomeViewController () <UIGestureRecognizerDelegate> {
  CGFloat lastRotation;
}

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) NSArray *entries;

@end

@implementation GPHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.images = @[ @"evaplane.png", @"evasilly.png", @"evafish.png", @"evadress.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  PFUser *currentUser = [PFUser currentUser];
  if (currentUser)
  {
    [self currentJournals];
    [self currentJournalEntries];
  }
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
  
  self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizerFired:)];
  [self.view addGestureRecognizer:self.pinchRecognizer];
  
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

#pragma mark - Parse API Calls

- (void)currentJournals
{
  // Find all journals given the current user
  PFQuery *query = [PFQuery queryWithClassName:@"Journal"];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error)
    {
      [GPAppDelegate appDelegate].journalsController.journals = objects;
    }
  }];
}

- (void)currentJournalEntries
{
  if (self.currentJournal != nil)
  {
    // Find all posts by the current user
    PFQuery *query = [PFQuery queryWithClassName:@"Entry"];
    [query whereKey:@"journal" equalTo:self.currentJournal];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      self.entries = objects;
      [self.tableView reloadData];
    }];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.entries)
    return self.entries.count;
  else
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"EntryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 110.0f, 110.0f)];
  [cell addSubview:imageView];
  
  GPEntry *entry = [self.entries objectAtIndex:indexPath.row];
  imageView.image = [UIImage imageNamed:@"evadress.png"];
  imageView.file = entry.image;
  [imageView loadInBackground];
  
  return cell;
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  return (gestureRecognizer == self.rotationRecognizer && otherGestureRecognizer == self.pinchRecognizer)
        || (gestureRecognizer == self.pinchRecognizer && otherGestureRecognizer == self.rotationRecognizer);
}

#pragma mark - Other GesturesRecognizer Methods

- (void)rotationRecognizerFired:(UIRotationGestureRecognizer *)recognizer
{
  NSString *text = [NSString stringWithFormat:@"Rotated! (r: %0.2f, v: %0.2f)", recognizer.rotation, recognizer.velocity];
  NSLog(@"%@", text);
  
  if([recognizer state] == UIGestureRecognizerStateEnded)
  {
    lastRotation = 0.0;
    return;
  }
  
  CGFloat rotation = 0.0 - (lastRotation - [recognizer rotation]);
  
  CGAffineTransform currentTransform = self.selectedImageView .transform;
  CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
  
  [self.selectedImageView setTransform:newTransform];
  
  lastRotation = [recognizer rotation];
}

- (void)pinchRecognizerFired:(UIPinchGestureRecognizer *)recognizer
{
  NSString *text = [NSString stringWithFormat:@"Pinched! (s: %0.2f, v: %0.2f)",
                    recognizer.scale, recognizer.velocity];
  NSLog(@"%@", text);
  
  static CGRect initialBounds;
  static CGFloat initialScale;
  
  if (recognizer.state == UIGestureRecognizerStateBegan)
  {
    CGPoint point = [recognizer locationInView:self.tableView];
    NSLog(@"point is %@", NSStringFromCGPoint(point));
    
    self.selectedImageView = [self imageViewClosestToPoint:point];
    initialBounds = self.selectedImageView.bounds;
    initialScale = [recognizer scale];
  }
  CGFloat scale = [recognizer scale];
  
  // Set back to initial scale when the user lets go
  if (recognizer.state == UIGestureRecognizerStateEnded)
  {
    scale = initialScale;
  }
  
  CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
  self.selectedImageView.bounds = CGRectApplyAffineTransform(initialBounds, zt);
}

- (UIImageView *)imageViewClosestToPoint:(CGPoint)point
{
  for (UITableViewCell *cell in [self.tableView visibleCells])
  {
    if (CGRectContainsPoint(cell.frame, point))
    {
      NSLog(@"cell frame: %@", NSStringFromCGRect(cell.frame));
      UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
      return imageView;
    }
  }
  return nil;
}

#pragma mark - Actions

- (IBAction)addEntryPressed:(id)sender
{
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
  {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Device has no camera"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    [myAlertView show];
  }
  else if (self.currentJournal == nil)
  {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Select or create a journal to begin"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    [myAlertView show];
  }
  else
  {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  self.capturedImage = info[UIImagePickerControllerEditedImage];
  
  [picker dismissViewControllerAnimated:YES completion:^{
    [self performSegueWithIdentifier:@"AddEntry" sender:self];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"AddEntry"])
  {
    GPAddEntryViewController *controller = [segue destinationViewController];
    controller.image = self.capturedImage;
    controller.currentJournal = self.currentJournal;
    controller.delegate = self;
  }
}

#pragma mark - GPAddEntryDelegate

- (void)refreshEntries
{
  NSLog(@"time to refresh");
  [self currentJournalEntries];
}

#pragma mark - Private methods

@end
