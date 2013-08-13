//
//  GPLoginViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLoginViewController : UIViewController <UITextFieldDelegate>

- (IBAction)loginPressed:(id)sender;
- (IBAction)twitterLoginPressed:(id)sender;
- (IBAction)facebookLoginPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
