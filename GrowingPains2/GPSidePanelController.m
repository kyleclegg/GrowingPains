//
//  GPSidePanelController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/13/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPSidePanelController.h"
#import "GPHelpers.h"

@interface GPSidePanelController ()

@end

@implementation GPSidePanelController

- (void)awakeFromNib
{
  [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
  [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
  [self.view setBackgroundColor:[GPHelpers gpBrown]];
  
  self.allowLeftOverpan = NO;
}


@end
