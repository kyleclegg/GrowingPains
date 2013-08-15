//
//  GPJournalsViewController.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/13/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GPJournalSelectedDelegate <NSObject>

- (void)refreshEntries;

@end

@interface GPJournalsViewController : UITableViewController

@property (weak, nonatomic) id<GPJournalSelectedDelegate> delegate;
@property (strong, nonatomic) NSArray *journals;

- (IBAction)logoutPressed:(id)sender;

@end
