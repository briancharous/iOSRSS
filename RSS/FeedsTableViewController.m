//
//  FeedsTableViewController.m
//  RSS
//
//  Created by Brian Charous on 4/19/14.
//  Copyright (c) 2014 Brian Charous. All rights reserved.
//

#import "FeedsTableViewController.h"

@interface FeedsTableViewController ()

@end

@implementation FeedsTableViewController

- (IBAction)addNewFeed:(id)sender {
    // show alert view with a textboxfor text entry
    UIAlertView *newFeedAlert = [[UIAlertView alloc] initWithTitle:@"Add new feed" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [newFeedAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[newFeedAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeURL];
    [[newFeedAlert textFieldAtIndex:0] setKeyboardAppearance:UIKeyboardAppearanceDark];
    [newFeedAlert show];
}

- (IBAction)editTable:(id)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [editButton setTitle:@"Edit"];
    }
    else {
        [self.tableView setEditing:YES animated:YES];
        [editButton setTitle:@"Done"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // clicked ok
        UITextField *textField = [alertView textFieldAtIndex:0]; // get main text field
        NSString *urlString = [textField text];
        NSURL *url = [NSURL URLWithString:urlString];
        if (url && url.scheme && url.host) {
            // url is good, start paring the feed
            [NSThread detachNewThreadSelector:@selector(addNewFeedInThread:) toTarget:self withObject:url];
            [self.refreshControl beginRefreshing];
        }
        else {
            // URL was malformed
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid URL" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [errorAlert show];
        }
    }
}

- (void)addNewFeedInThread:(NSURL *)url {
    // dispatch new thread to parse feed xml
    MWFeedParser *parser = [[MWFeedParser alloc] initWithFeedURL:url];
    [parser setDelegate:self];
    [parser parse];
}

- (void)addFeedToTable:(FeedObject *)feedObject {
    // add a feed to the table
    [self.feedList addObject:feedObject];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.feedList count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
    if (refreshingCount <= 0) {
    // Provides info about the feed
        NSString *title = [info title];
        FeedObject *obj = [[FeedObject alloc] init];
        [obj setUrl:[parser url]];
        obj.items = [[NSMutableArray alloc] init];
        if (title) {
            [obj setTitle:title];
        } else {
            NSString *url = [[parser url] absoluteString];
            [obj setTitle:url];
        }
        [self addFeedToTable:obj];
    }
}

- (void) feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    for (int i = 0; i < [self.feedList count]; i++) {
        FeedObject *obj = [self.feedList objectAtIndex:i];
        if ([[obj url] isEqual:[parser url]]) {
            if (![obj.items containsObject:item]) {
                [obj.items addObject:item];
            }
//            NSLog(@"Added item");
            break;
        }
    }
    [self saveState];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    refreshingCount--;
    
    // if no more feeds are refreshing, hide the refresh spinner
    if (refreshingCount <= 0) {
        [self.refreshControl endRefreshing];
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Something went wrong :(" message:[NSString stringWithFormat:@"Here's a technical error message: %@", error] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)saveState {
    // save data to file
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [docsPath stringByAppendingPathComponent:@"archive.dat"];
    [NSKeyedArchiver archiveRootObject:self.feedList toFile:filename];
}

- (void)startRefreshFeedsInNewThread {
    [NSThread detachNewThreadSelector:@selector(refreshFeeds) toTarget:self withObject:nil];
}

- (void)refreshFeeds {
    // keep track of how many feeds we are refreshing so we know when its done
    refreshingCount = 0;
    for (int i=0; i < [self.feedList count]; i++) {
        refreshingCount++;
        FeedObject *f = [self.feedList objectAtIndex:i];
        MWFeedParser *p = [[MWFeedParser alloc] initWithFeedURL:[f url]];
        [p setDelegate:self];
        [p parse];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self setRefreshControl:refreshControl];
    [refreshControl addTarget:self action:@selector(startRefreshFeedsInNewThread) forControlEvents:UIControlEventValueChanged];
    
    // read data back or initialize new array
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [docsPath stringByAppendingPathComponent:@"archive.dat"];
    NSMutableArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];

    if (savedArray) {
        [self setFeedList:savedArray];
        [self.tableView reloadData];
    }
    else {
        self.feedList = [[NSMutableArray alloc] init];
    }
    
    // don't show empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:@"enteringBackground" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.feedList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // get title
    NSString *urlString = [[self.feedList objectAtIndex:[indexPath row]] title];
    [cell.textLabel setText:urlString];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.feedList removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // show the corresponding stories
    
    NSURL *feedUrl = [[self.feedList objectAtIndex:[indexPath row]] url];
    
    FeedObject *obj = [self.feedList objectAtIndex:[indexPath row]];
    
    StoriesTableViewController *storiesVC = [[StoriesTableViewController alloc] initWithFeedUrl:feedUrl andObject:obj];
    [storiesVC.navigationItem setTitle:[[self.feedList objectAtIndex:[indexPath row]] title]];
    [self.navigationController pushViewController:storiesVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
