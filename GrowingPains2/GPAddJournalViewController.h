//
//  GPAddJournalViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/14/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPAddJournalViewController : UIViewController <UITextFieldDelegate>

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;
@property (weak, nonatomic) IBOutlet UISwitch *remindersEnabledSwitch;

@end
