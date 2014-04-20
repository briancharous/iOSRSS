//
//  FeedObject.h
//  RSS
//
//  Created by Brian Charous on 4/19/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedObject : NSObject

@property NSURL *url;
@property NSString *title;
@property NSMutableArray *items;

- (id)initWithURL:(NSURL *)url andTitle:(NSString *)title;

@end
