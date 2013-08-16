//
//  GPJournalsViewController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/13/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPJournalsViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import <Parse/Parse.h>
#import "GPJournal.h"
#import "GPAppDelegate.h"

@interface GPJournalsViewController ()

@end

@implementation GPJournalsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.delegate = [GPAppDelegate appDelegate].homeController;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Find all journals given the current user
  PFQuery *query = [PFQuery queryWithClassName:@"Journal"];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error)
    {
      NSLog(@"Successfully retrieved %d journals.", objects.count);
      self.journals = objects;
      [self.tableView reloadData];
      
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
}

#pragma mark - Actions

- (IBAction)logoutPressed:(id)sender
{
  [PFUser logOut];
  [self.sidePanelController showCenterPanelAnimated:YES];
  UINavigationController *navController = [[(UINavigationController *)[self.sidePanelController centerPanel] viewControllers] objectAtIndex:0];
  [navController performSegueWithIdentifier:@"Login" sender:self];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.journals.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = @"JournalCell";
  
  // If last row, it is the add journal button
  if (indexPath.row == self.journals.count)
    cellIdentifier = @"AddJournal";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  if (indexPath.row < self.journals.count)
  {
    GPJournal *journal = [self.journals objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = journal.name;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  // Check for a valid index
  if (indexPath.row < self.journals.count)
  {
    GPJournal *selectedJournal = [self.journals objectAtIndex:indexPath.row];
    
    if ([GPAppDelegate appDelegate].homeController.currentJournal != selectedJournal)
    {
      // Update current journal
      [GPAppDelegate appDelegate].homeController.currentJournal = selectedJournal;
      [[GPAppDelegate appDelegate].homeController.previouslyDraggedImageView removeFromSuperview];
      [GPAppDelegate appDelegate].homeController.captionLabel.alpha = 0.0f;
    }
    
    // Return to home view controller
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    // Kick off a refresh
    if ([self.delegate respondsToSelector:@selector(refreshEntries)])
      [self.delegate refreshEntries];
  }
}

@end
