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

@interface GPHomeViewController () 

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) NSArray *entries;

@end

@implementation GPHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
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
  
//  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
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
      [self.collectionView reloadData];
    }];
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  // +1 for the add entry cell
  if (self.entries)
    return self.entries.count + 1;
  else
    return 1;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"EntryCell";
  static NSString *addEntryCellIdentifier = @"AddEntryCell";
  
  if (indexPath.row == self.entries.count)
  {
    // Final row, setup our add button
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addEntryCellIdentifier forIndexPath:indexPath];
    return cell;
  }
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
  [cell addSubview:imageView];
  
  GPEntry *entry = [self.entries objectAtIndex:indexPath.row];
  imageView.file = entry.image;
  [imageView loadInBackground];
  
  return cell;
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
