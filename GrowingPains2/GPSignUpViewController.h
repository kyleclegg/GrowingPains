//
//  GPSignUpViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/13/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSignUpViewController : UIViewController <UITextFieldDelegate>

- (IBAction)signUpPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
