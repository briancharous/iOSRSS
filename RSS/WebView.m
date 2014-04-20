//
//  WebView.m
//  RSS
//
//  Created by Adam Canady on 4/20/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import "WebView.h"

@implementation WebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)loadAViewer:(NSURL*)viewerURL
{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:viewerURL];
    [self loadRequest:requestObj];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
