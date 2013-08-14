//
//  GPEditJournalViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/14/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPEditJournalViewController.h"

@interface GPEditJournalViewController ()

@end

@implementation GPEditJournalViewController

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

- (IBAction)savePressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
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
