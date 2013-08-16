//
//  GPAddEntryViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/15/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPJournal.h"


@protocol GPAddEntryDelegate <NSObject>

- (void)refreshEntries;

@end

@interface GPAddEntryViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *captionLabel;

@property (weak, nonatomic) id<GPAddEntryDelegate> delegate;
@property (strong, nonatomic) GPJournal *currentJournal;
@property (strong, nonatomic) UIImage *image;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)savePressed:(id)sender;

@end
