//
//  GPSignUpViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/13/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPSignUpViewController.h"
#import <Parse/Parse.h>

@interface GPSignUpViewController ()

@end

@implementation GPSignUpViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

}

#pragma mark - Actions

- (IBAction)signUpPressed:(id)sender;
{
  PFUser *user = [PFUser user];
  user.username = self.emailTextField.text;
  user.password = self.passwordTextField.text;
  user.email = self.emailTextField.text;
  
  // other fields can be set just like with PFObject
  [user setObject:self.firstNameTextField.text forKey:@"firstName"];
  [user setObject:self.lastNameTextField.text forKey:@"lastName"];
  
  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      // Hooray! Let them use the app now.
      [self dismissViewControllerAnimated:YES completion:nil];
      
    } else {
      NSString *errorString = [[error userInfo] objectForKey:@"error"];
      NSLog(@"error: %@", errorString);
    }
  }];

}

- (IBAction)dismissKeyboard:(id)sender
{
  [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.firstNameTextField)
    [self.lastNameTextField becomeFirstResponder];
  else if (textField == self.lastNameTextField)
    [self.emailTextField becomeFirstResponder];
  else if (textField == self.emailTextField)
    [self.passwordTextField becomeFirstResponder];
  else
    [self performSelector:@selector(signUpPressed:) withObject:nil];
  
  return YES;
}



@end
