//
//  GPAddEntryViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/15/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPAddEntryViewController.h"
#import "GPAppDelegate.h"
#import "GPEntry.h"

@interface GPAddEntryViewController ()

@end

@implementation GPAddEntryViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.captionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.captionTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];

  if (self.image != nil)
    self.imageView.image = self.image;
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
  CGSize newSize = CGSizeMake(640, 640);
  UIGraphicsBeginImageContext(newSize);
  [self.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  NSData *imageData = UIImagePNGRepresentation(newImage);
  PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
  [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    // Handle success or failure here ...
  } progressBlock:^(int percentDone) {
    // Update your progress spinner here. percentDone will be between 0 and 100.
    NSLog(@"progress: %i", percentDone);
    
  }];
  
  GPEntry *entry = [[GPEntry alloc] init];
  entry.caption = self.captionTextField.text;
  entry.journal = self.currentJournal;
  entry.image = imageFile;
  
  [entry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if ([self.delegate respondsToSelector:@selector(refreshEntries)])
      [self.delegate refreshEntries];
  }];
  
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [self saveEntry];
  
  return YES;
}

@end
