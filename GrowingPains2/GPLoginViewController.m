//
//  GPLoginViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPLoginViewController.h"
#import <Parse/Parse.h>

@interface GPLoginViewController ()

@end

@implementation GPLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)loginPressed:(id)sender
{
  [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text
                                  block:^(PFUser *user, NSError *error) {
                                    if (user)
                                    {
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                    }
                                    else
                                    {
                                      NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                      NSLog(@"error: %@", errorString);
                                    }
                                  }];
}

- (IBAction)dismissKeyboard:(id)sender
{
  [self.view endEditing:YES];
}

- (IBAction)twitterLoginPressed:(id)sender
{
  [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
    if (user)
    {
      if (user.isNew)
        NSLog(@"User signed up and logged in with Twitter!");
      else
        NSLog(@"User logged in with Twitter!");
      
      [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
      NSString *errorString = [[error userInfo] objectForKey:@"error"];
      NSLog(@"error: %@", errorString);
    }
  }];
}

- (IBAction)facebookLoginPressed:(id)sender
{
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.emailTextField)
    [self.passwordTextField becomeFirstResponder];
  else
    [self performSelector:@selector(loginPressed:) withObject:nil];
  
  return YES;
}

@end
