//
//  GPSidePanelController.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/13/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPSidePanelController.h"

@interface GPSidePanelController ()

@end

@implementation GPSidePanelController

- (void)awakeFromNib
{
  [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
  [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
}


@end
