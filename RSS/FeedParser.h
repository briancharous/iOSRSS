//
//  FeedParser.h
//  RSS
//
//  Created by Brian Charous on 4/19/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedParser : NSObject <NSXMLParserDelegate> {
    NSString *curElement;
    NSString *title;
}

- (NSString *)titleForURL:(NSURL *)url;

@end
