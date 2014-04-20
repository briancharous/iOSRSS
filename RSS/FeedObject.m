//
//  FeedObject.m
//  RSS
//
//  Created by Brian Charous on 4/19/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import "FeedObject.h"

@implementation FeedObject

- (id)initWithURL:(NSURL *)url andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self setUrl:url];
        [self setTitle:title];
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
