//
//  RadixSort.m
//  MyFirstProgramm
//
//  Created by Mathias Quintero on 7/9/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

#import "RadixSort.h"
#import "Bucket.h"

@implementation RadixSort

- (void) sort:(NSMutableArray *)array {
    NSMutableArray *buckets = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        buckets[i] = [[Bucket alloc] init];
    }
    for (int pow = 1; pow > 0; pow *= 10) {
        for (NSObject *item in array) {
            NSInteger actualItem = (NSInteger) item;
            int bucketIndex = (actualItem % (10 * pow)) / pow;
            [((Bucket *) buckets[bucketIndex]) push:item];
        }
        NSInteger index = 0;
        for (NSObject *bucket in buckets) {
            index = [(Bucket *) bucket empty:array :index];
        }
    }
}

@end
