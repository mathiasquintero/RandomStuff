//
//  main.m
//  MyFirstProgramm
//
//  Created by Mathias Quintero on 7/7/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortingAlgorithm.h"
#import "RadixSort.h"

NSMutableArray* randomArray(NSInteger size) {
    id numbers[size];
    for (int x = 0; x < size; ++x)
        numbers[x] =  [NSNumber numberWithInt: arc4random_uniform(100)];
    return [NSMutableArray arrayWithObjects:numbers count:size];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        id <SortingAlgorithm> sorter = [RadixSort alloc];
        NSMutableArray *array = randomArray(100);
        NSLog(@"%@", [array description]);
        [sorter sort:array];
        NSLog(@"%@", [array description]);
    }
    return 0;
}
