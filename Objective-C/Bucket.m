//
//  Bucket.m
//  MyFirstProgramm
//
//  Created by Mathias Quintero on 7/9/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

#import "Bucket.h"

@implementation Bucket

@synthesize items;

- (id) init {
    self = [super init];
    self.items = [[NSMutableArray alloc] init];
    return self;
}

- (void) push:(NSObject *)item {
    [items addObject:item];
}

- (NSInteger) empty:(NSMutableArray *)array
                   :(NSInteger)at {
    NSInteger index = at + [items count];
    for (NSInteger i = 0; i < [items count]; i++) {
        array[at +i] = items[i];
    }
    [items removeAllObjects];
    return index;
}

@end
