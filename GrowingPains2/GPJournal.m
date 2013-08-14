//
//  GPJournal.m
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/14/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import "GPJournal.h"
#import <Parse/PFObject+Subclass.h>

@implementation GPJournal

@dynamic user;
@dynamic name;
@dynamic birthdate;
@dynamic remindersEnabled;
@dynamic remindersFrequency;
@dynamic entries;

+ (NSString *)parseClassName
{
  return @"Journal";
}

@end
