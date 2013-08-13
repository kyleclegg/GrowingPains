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

- (IBAction)logInPressed:(id)sender
{
  [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text
                                  block:^(PFUser *user, NSError *error) {
                                    if (user) {
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
  if (textField == self.emailTextField)
    [self.passwordTextField becomeFirstResponder];
  else
    [self performSelector:@selector(logInPressed:) withObject:nil];
  
  return YES;
}

@end
