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

@interface GPJournalsViewController ()

@property (strong, nonatomic) NSArray *journals;

@end

@implementation GPJournalsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
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
  [[[(UINavigationController *)[self.sidePanelController centerPanel] viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"Login" sender:self];
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
    cell.textLabel.text = journal.name;
  }
  
  // Configure the cell...
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.row < self.journals.count)
    [self.sidePanelController showCenterPanelAnimated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
