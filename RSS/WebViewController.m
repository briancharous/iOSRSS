//
//  WebViewController.m
//  RSS
//
//  Created by Adam Canady on 4/20/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUrl:(NSURL *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.url = url;
        self.webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:requestURL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
