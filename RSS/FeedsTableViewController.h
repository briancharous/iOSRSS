//
//  FeedsTableViewController.h
//  RSS
//
//  Created by Brian Charous on 4/19/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "FeedObject.h"
#import "StoriesTableViewController.h"

@interface FeedsTableViewController : UITableViewController <UIAlertViewDelegate, MWFeedParserDelegate> {
    
    IBOutlet UIBarButtonItem *editButton;
}

- (IBAction)addNewFeed:(id)sender;
- (IBAction)editTable:(id)sender;
- (void)addFeedToTable:(FeedObject *)feedObject;

@property NSMutableArray *feedList;

@end
