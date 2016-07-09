//
//  SortingAlgorithm.h
//  MyFirstProgramm
//
//  Created by Mathias Quintero on 7/7/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortingAlgorithm <NSObject>

- (void) sort:(NSMutableArray *) array;

@end
