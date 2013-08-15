//
//  GPAddEntryViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/15/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPAddEntryViewController.h"
#import "GPAppDelegate.h"
#import "UIImage+ImageResizing.h"
#import "DAProgressOverlayView.h"

@interface GPAddEntryViewController ()

@property (strong, nonatomic) DAProgressOverlayView *progressOverlayView;

@end

@implementation GPAddEntryViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  if (self.image != nil)
    self.imageView.image = self.image;
  
  self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.imageView.bounds];
  [self.imageView addSubview:self.progressOverlayView];
  self.progressOverlayView.hidden = YES;
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(id)sender
{
  [self.view endEditing:YES];
}

- (IBAction)savePressed:(id)sender
{
  self.saveButton.enabled = NO;
  [self saveEntry];
}

- (void)saveEntry
{
  self.progressOverlayView.hidden = NO;
  
  UIImage *scaledImage = [self.image imageWithSize:CGSizeMake(640, 640) contentMode:UIViewContentModeScaleAspectFill];
  NSData *imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
  PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
  [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    // Handle success or failure here ...
    NSLog(@"block");
  } progressBlock:^(int percentDone) {
    // Update your progress spinner here. percentDone will be between 0 and 100.
//    NSLog(@"progress: %i", percentDone);
    
    CGFloat progress = (float)percentDone/100;
    NSLog(@"progress is %f", progress);
    if (progress > 1) {
      [UIView animateWithDuration:0.2 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.progressOverlayView.alpha = 0.;
      } completion:^(BOOL finished) {
        self.progressOverlayView.progress = 0.;
        self.progressOverlayView.alpha = 1.;
        self.progressOverlayView.hidden = YES;
      }];
    } else {
      self.progressOverlayView.progress = progress;
    }
    
  }];
  
  PFObject *entry = [PFObject objectWithClassName:@"Entry"];
  [entry setObject:self.captionTextField.text   forKey:@"caption"];
  [entry setObject:self.currentJournal          forKey:@"journal"];
  [entry setObject:imageFile                    forKey:@"image"];
  [entry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    NSLog(@"done saving entry, popping it like it's hot");
    [self.navigationController popViewControllerAnimated:YES];
  }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [self saveEntry];
  
  return YES;
}

@end
