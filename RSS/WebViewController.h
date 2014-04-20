//
//  WebViewController.h
//  RSS
//
//  Created by Adam Canady on 4/20/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) IBOutlet UIWebView *webView;
@property NSURL *url;

-(id)initWithUrl:(NSURL *)url;
@end
