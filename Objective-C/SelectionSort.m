//
//  SelectionSort.m
//  MyFirstProgramm
//
//  Created by Mathias Quintero on 7/7/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

#import "SelectionSort.h"

@implementation SelectionSort

- (NSInteger) findMinimum:(NSArray *) array
                         :(NSInteger) start {
    NSInteger min = start;
    for (NSInteger i = start + 1; i < [array count]; i++) {
        if (array[min] > array[i]) {
            min = i;
        }
    }
    return min;
}

- (void) swap:(NSMutableArray *) array
             :(NSInteger) i
             :(NSInteger) j {
    NSObject *tmp = array[i];
    array[i] = array[j];
    array[j] = tmp;
}

- (void) sort:(NSMutableArray *) array {
    for (NSInteger i = 0; i < [array count] - 1; i++) {
        NSInteger min = [self findMinimum:array :i];
        [self swap:array :i :min];
    }
}

@end
