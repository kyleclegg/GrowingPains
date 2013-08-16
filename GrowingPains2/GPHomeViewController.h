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

@interface GPHomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GPAddEntryDelegate, GPJournalSelectedDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) GPJournal *currentJournal;
@property (strong, nonatomic) UIImageView *previouslyDraggedImageView;

- (IBAction)addEntryPressed:(id)sender;

@end
