//
//  GPEditJournalViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/14/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPEditJournalViewController : UIViewController <UITextFieldDelegate>

- (IBAction)savePressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;

@end
