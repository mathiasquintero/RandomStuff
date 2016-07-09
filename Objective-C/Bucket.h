//
//  Bucket.h
//  MyFirstProgramm
//
//  Created by Mathias Quintero on 7/9/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bucket : NSObject

@property (nonatomic, retain) NSMutableArray *items;

-(id) init;
- (void) push:(NSObject *) item;
- (NSInteger) empty:(NSMutableArray *) array
                   :(NSInteger) at;

@end
