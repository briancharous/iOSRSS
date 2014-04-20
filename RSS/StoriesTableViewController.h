//
//  StoriesTableViewController.h
//  RSS
//
//  Created by Brian Charous on 4/20/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "FeedObject.h"


@interface StoriesTableViewController : UITableViewController

- (id)initWithFeedUrl:(NSURL *)url;
- (id)initWithFeedUrl:(NSURL *)url andObject:(FeedObject *)obj;

@property NSURL *feedUrl;
@property FeedObject *obj;

@end
