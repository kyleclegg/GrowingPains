//
//  GPEntry.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/15/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPEntry.h"
#import <Parse/PFObject+Subclass.h>

@implementation GPEntry

@dynamic image;
@dynamic caption;
@dynamic journal;

+ (NSString *)parseClassName
{
  return @"Entry";
}

@end
