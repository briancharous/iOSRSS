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

// conform to NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.items forKey:@"items"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self setUrl:[decoder decodeObjectForKey:@"url"]];
        [self setTitle:[decoder decodeObjectForKey:@"title"]];
        [self setItems:[decoder decodeObjectForKey:@"items"]];
    }
    return self;
}

@end
