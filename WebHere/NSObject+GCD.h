//
//  NSObject+GCD.h
//  ObjectiveScrap
//
//  Created by Rui D Lopes on 22/03/13.
//  Copyright (c) 2013 Rui D Lopes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GCD)

- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)wait;

- (void)performAsynchronous:(void(^)(void))block;

- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

@end
