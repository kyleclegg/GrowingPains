//
//  GPJournal.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/14/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GPJournal : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *birthdate;
@property BOOL remindersEnabled;
@property (strong, nonatomic) NSNumber *remindersFrequency;
@property (strong, nonatomic) NSArray *entries;

@end
