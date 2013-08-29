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
#import <Social/Social.h>

#define kGPCenteredImageX 160
#define kGPCenteredImageY 304

@interface GPHomeViewController () // <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) UIDynamicAnimator *animator;
//@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
//@property (strong, nonatomic) UISnapBehavior *snapBehavior;
@property (strong, nonatomic) UIImage *capturedImage;
//@property (strong, nonatomic) UIImageView *draggableImageView;

//@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
//@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation GPHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Initialize our image, twitter, and fb controllers here for faster loading later
  self.imagePickerController = [[UIImagePickerController alloc] init];
  
//  self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAttachmentRecognizer:)];
//  self.panGestureRecognizer.delegate = self;
//  self.panGestureRecognizer.minimumNumberOfTouches = 1;
//  self.panGestureRecognizer.maximumNumberOfTouches = 1;
//  [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  PFUser *currentUser = [PFUser currentUser];
  if (currentUser)
  {
    [self loadCurrentJournals];
    [self loadCurrentJournalEntries];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  PFUser *currentUser = [PFUser currentUser];
  if (!currentUser)
    [self performSegueWithIdentifier:@"Login" sender:self];

//  [self setupAnimator];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  self.animator = nil;
}

#pragma mark - Parse API Calls

- (void)loadCurrentJournals
{
  // Find all journals given the current user
  PFQuery *query = [PFQuery queryWithClassName:@"Journal"];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error)
    {
      [GPAppDelegate appDelegate].journalsController.journals = objects;
      
      // Set the first journal by default (this should come from preferences later
      if (!self.currentJournal && objects.count > 0)
      {
        self.currentJournal = [objects objectAtIndex:0];
        [self loadCurrentJournalEntries];
      }
    }
  }];
}

- (void)loadCurrentJournalEntries
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
  
  if (indexPath.item == self.entries.count)
  {
    // Final row, setup our add button
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addEntryCellIdentifier forIndexPath:indexPath];
    return cell;
  }
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
  imageView.tag = 100;
  [cell addSubview:imageView];
  
  GPEntry *entry = [self.entries objectAtIndex:indexPath.item];
  imageView.file = entry.image;
  [imageView loadInBackground];
  
//  self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//  self.longPressRecognizer.minimumPressDuration = 0.1;
//  self.longPressRecognizer.delegate = self;
//  [cell addGestureRecognizer:self.longPressRecognizer];
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  // Check for + button pressed (last item), in which case we will skip all the code below and open the camera
  if (indexPath.item == self.entries.count)
  {
    [self captureImage];
    return;
  }
  
  UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
  GPEntry *entry = [self.entries objectAtIndex:indexPath.item];
  
  // Copy the image from the cell, create a new imageview directly on top, and then animate it down to the center position
  PFImageView *newImageView = [[PFImageView alloc] initWithFrame:[collectionView convertRect:cell.frame toView:self.view]];
  newImageView.file = entry.image;
  [self.view addSubview:newImageView];
  
  // Use a simple snapbehavior to move the image down
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  CGPoint snapPoint = self.view.center;
  snapPoint.y += 60;
  UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:newImageView snapToPoint:snapPoint];
  [self.animator addBehavior:snapBehavior];
  
  // Animate the caption update
  [self updateCaptionWithText:entry.caption];
  
  // Animate the image size increase
  [UIView animateWithDuration:0.5 animations:^{
    newImageView.frame = CGRectMake(snapPoint.x, snapPoint.y, 240, 240);
  } completion:^(BOOL finished) {
    
//    CGRect twitterFrame = 
    
    [self showSocialButtons];
  }];
  
  // Clear the social buttons and previous image view
  [self hideSocialButtons];
  [self.previouslyDraggedImageView removeFromSuperview];
  self.previouslyDraggedImageView = newImageView;
}

- (void)updateCaptionWithText:(NSString *)text
{
  [UIView animateWithDuration:1.0
                   animations:^{
                     self.captionLabel.alpha = 0.0f;
                     self.captionLabel.text = text;
                     self.captionLabel.alpha = 1.0f;
                   }];
}

- (void)showSocialButtons
{
  [self.view bringSubviewToFront:self.facebookShareView];
  [self.view bringSubviewToFront:self.twitterShareView];
  
  self.twitterShareView.hidden = NO;
  self.facebookShareView.hidden = NO;
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.twitterShareView.alpha = 1.0;
                     self.facebookShareView.alpha = 1.0f;
                   }];
}

- (void)hideSocialButtons
{
   self.twitterShareView.alpha = 0.0;
   self.facebookShareView.alpha = 0.0f;
   self.twitterShareView.hidden = YES;
   self.facebookShareView.hidden = YES;
}

#pragma mark - Gesture Handling

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//  return ((gestureRecognizer == self.panGestureRecognizer && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
//        || (otherGestureRecognizer == self.panGestureRecognizer && [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]));
//}
//
//- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
//{
//  UICollectionViewCell *cell = (UICollectionViewCell *)[recognizer view];
//
//  if (recognizer.state == UIGestureRecognizerStateBegan)
//  {
//    NSLog(@"Long Press Began");
//    
//    CGRect theFrame = [recognizer view].frame;
//    self.draggableImageView = [[UIImageView alloc] initWithFrame:theFrame];
//    self.draggableImageView.image = ((UIImageView *)[cell viewWithTag:100]).image;
//    [self.view addSubview:self.draggableImageView];
////    [self setupAnimator];
//    
//    cell.hidden = YES;
//  }
//  else if (recognizer.state == UIGestureRecognizerStateEnded)
//  {
//    NSLog(@"Long Press Ended");
//    recognizer = nil;
//    cell.hidden = NO;
//    
//    // Done - remove the old imageview and set the current one to be the new previous one
//    [self.previouslyDraggedImageView removeFromSuperview];
//    self.previouslyDraggedImageView = self.draggableImageView;
//  }
//}
//
//- (void)handleAttachmentRecognizer:(UIPanGestureRecognizer *)recognizer
//{
//  [self.attachmentBehavior setAnchorPoint:[recognizer locationInView:self.collectionView]];
//  
//  if (recognizer.state == UIGestureRecognizerStateBegan)
//  {
//    NSLog(@"Pan Began");
//  }
//  else if (recognizer.state == UIGestureRecognizerStateEnded)
//  {
//    NSLog(@"Pan Ended");
//    
//    if (self.draggableImageView.frame.origin.y > (self.collectionView.frame.origin.y + self.collectionView.frame.size.height))
//    {
//      // Snap to its place!
//      CGPoint snapPoint = CGPointMake(kGPCenteredImageX, kGPCenteredImageY);
//      self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.draggableImageView snapToPoint:snapPoint];
//      [self.animator addBehavior:self.snapBehavior];
//      
//      NSLog(@"%@", NSStringFromCGRect(self.draggableImageView.frame));
//      [self performSelector:@selector(growImage) withObject:nil];
//    }
//    else
//    {
//      // Go back to your home!
//      [self.draggableImageView removeFromSuperview];
//    }
//  }
//}
//
//- (void)growImage
//{
//  [UIView animateWithDuration:0.5 animations:^{
//    CGFloat xPos = kGPCenteredImageX - 75.0;
//    CGFloat yPos = kGPCenteredImageY - 75.0;
//    self.draggableImageView.frame = CGRectMake(xPos, yPos, 150, 150);
//    NSLog(@"the new frame is %@", NSStringFromCGRect(self.draggableImageView.frame));
//    
//  } completion:^(BOOL finished) {
//    NSLog(@"done");
//  }];
//}
//
//#pragma mark - Dynamics
//
//- (void)setupAnimator
//{
//  if (self.draggableImageView == nil)
//    return;
//  
//  UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//  UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.draggableImageView]];
//  
//  CGPoint squareCenterPoint = CGPointMake(self.draggableImageView.center.x, self.draggableImageView.center.y - 100.0);
//  UIOffset offset = UIOffsetMake(0.0, 0.0);
//  UIAttachmentBehavior* attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.draggableImageView offsetFromCenter:offset attachedToAnchor:squareCenterPoint];
//  collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//
//  [animator addBehavior:attachmentBehavior];
//  self.animator = animator;
//  
//  self.attachmentBehavior = attachmentBehavior;
//}

#pragma mark - Actions

- (IBAction)addEntryPressed:(id)sender
{
  [self captureImage];
}

- (void)captureImage
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
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
  }
}

- (IBAction)twitterSharePressed:(id)sender
{
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetController setInitialText:[NSString stringWithFormat:@"%@ via @growingpainsapp", self.captionLabel.text]];
    [tweetController addImage:self.previouslyDraggedImageView.image];
    [self presentViewController:tweetController animated:YES completion:nil];
  }
}

- (IBAction)facebookSharePressed:(id)sender
{
  if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
  {
    SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookController setInitialText:self.captionLabel.text];
    [facebookController addImage:self.previouslyDraggedImageView.image];
    [self presentViewController:facebookController animated:YES completion:Nil];
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
  [self loadCurrentJournalEntries];
}

@end
