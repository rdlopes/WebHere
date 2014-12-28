//
//  WHSearchRequest.m
//  WebHere
//
//  Created by Rui Lopes on 28/12/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import "WHSearchRequest.h"
#import "WHSearchResponse.h"

@interface WHSearchRequest ()

@end

@implementation WHSearchRequest

- (instancetype)init {
    self = [super initWithPath:@"/search" target:[WHSearchResponse class]];
    if (self) {
    }
    return self;
}

@end
