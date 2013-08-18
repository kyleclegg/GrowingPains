//
//  GPEntryCell.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/16/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPEntryCell.h"

@implementation GPEntryCell

- (void)prepareForReuse
{
  UIImageView *imageView = (UIImageView *)[self viewWithTag:200];
  imageView.image = nil;
}

@end
