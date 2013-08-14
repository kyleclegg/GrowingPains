//
//  GPAddJournalViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/14/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPAddJournalViewController.h"
#import "GPJournal.h"
#import <Parse/Parse.h>
#import "GPAppDelegate.h"

@interface GPAddJournalViewController ()

@end

@implementation GPAddJournalViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIDatePicker *datePicker = [[UIDatePicker alloc] init];
  datePicker.datePickerMode = UIDatePickerModeDate;
  datePicker.maximumDate = [NSDate date];
  [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.birthdateTextField.inputView = datePicker;
}

- (void)datePickerValueChanged:(id)sender
{
  UIDatePicker *datePicker = (UIDatePicker *)sender;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/YYYY"];
  [self.birthdateTextField setText:[formatter stringFromDate:datePicker.date]];
}

#pragma mark - Actions

- (IBAction)cancelPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/YYYY"];
  
  GPJournal *journal = [[GPJournal alloc] init];
  journal.name = self.nameTextField.text;
  journal.birthdate = [formatter dateFromString:self.birthdateTextField.text];
  journal.remindersEnabled = self.remindersEnabledSwitch.isOn;
  journal.remindersFrequency = [NSNumber numberWithInteger:2];
  journal.user = [PFUser currentUser];
  
  [journal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded)
    {
      [self dismissViewControllerAnimated:YES completion:nil];
    }
  }];
}

- (IBAction)dismissKeyboard:(id)sender
{
  if ([self.nameTextField isFirstResponder])
    [self.nameTextField resignFirstResponder];
  else if ([self.birthdateTextField isFirstResponder])
    [self.birthdateTextField resignFirstResponder];
  
  [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.nameTextField)
    [self.birthdateTextField becomeFirstResponder];
  else
    [self.birthdateTextField resignFirstResponder];
  
  return YES;
}

@end
