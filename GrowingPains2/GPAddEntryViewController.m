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

@interface GPAddEntryViewController ()

@end

@implementation GPAddEntryViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

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
//  UIImage *scaledImage = [self.image imageWithSize:CGSizeMake(640, 640) contentMode:UIViewContentModeScaleAspectFill];
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
  
  PFObject *entry = [PFObject objectWithClassName:@"Entry"];
  [entry setObject:self.captionTextField.text   forKey:@"caption"];
  [entry setObject:self.currentJournal          forKey:@"journal"];
  [entry setObject:imageFile                    forKey:@"image"];
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
