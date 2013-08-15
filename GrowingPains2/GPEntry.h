//
//  GPEntry.h
//  GrowingPains2
//
//  Created by Kyle Clegg on 8/15/13.
//  Copyright (c) 2013 Paperplate LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GPJournal.h"

@interface GPEntry : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) PFFile *image;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) GPJournal *journal;

@end
