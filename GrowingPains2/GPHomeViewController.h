//
//  GPFirstViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/12/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPJournal.h"
#import "GPAddEntryViewController.h"
#import "GPJournalsViewController.h"

@interface GPHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GPAddEntryDelegate, GPJournalSelectedDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) GPJournal *currentJournal;

- (IBAction)addEntryPressed:(id)sender;

@end
