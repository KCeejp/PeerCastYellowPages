//
//  YPAppDelegate.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPAppDelegate.h"

#import "YPYellowPagesClient.h"
#import "YPIndexDotTxtRequestOperation.h"
#import "YPChannelCellView.h"

@interface YPAppDelegate () <NSUserNotificationCenterDelegate>

@property (nonatomic) NSStatusItem *statusItem;

@property (nonatomic) NSArray *channels;
@property (nonatomic) NSArray *menuArray;

@end

@implementation YPAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [self fetchYellowPages:nil];
    
    NSTimeInterval interval = 2 * 60;
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(fetchYellowPages:) userInfo:nil repeats:YES];
    
    self.menuArray = @[
                       @{@"imageName": @"53-house", @"name": @"Home"},
                       @{@"imageName": @"28-star", @"name": @"Favorite"},
                       @{@"imageName": @"28-star", @"name": @"Popular"},
                       ];
    [self.menuTableView reloadData];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [MagicalRecord setupCoreDataStack];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)fetchYellowPages:(id)sender
{
    __weak __block __typeof__(self) weakSelf = self;
    
    NSArray *URLs = @[
                      [NSURL URLWithString:@"http://bayonet.ddo.jp/sp/index.txt"],
                      [NSURL URLWithString:@"http://temp.orz.hm/yp/index.txt"],
                      ];
    
    NSMutableArray *operations = @[].mutableCopy;
    for (NSURL *URL in URLs) {
        YPYellowPagesClient *client = [[YPYellowPagesClient alloc] initWithBaseURL:URL];
        [client registerHTTPOperationClass:[YPIndexDotTxtRequestOperation class]];
        NSURLRequest *request = [client requestWithMethod:@"GET" path:URL.path parameters:nil];
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [operations addObject:operation];
    }
    
    YPYellowPagesClient *sharedClient = [[YPYellowPagesClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com"]];
    [sharedClient registerHTTPOperationClass:[YPIndexDotTxtRequestOperation class]];
    [sharedClient enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } completionBlock:^(NSArray *operations) {
        
        NSMutableArray *channels = @[].mutableCopy;
        for (AFHTTPRequestOperation *operation in operations) {
            
            YPIndexDotTxtRequestOperation *indexDotTxtOperation = (YPIndexDotTxtRequestOperation *)operation;
            for (YPChannel *channel in indexDotTxtOperation.responseChannels) {
                [channels addObject:channel];
            }
            
        }
        
        [channels sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(YPChannel *)obj1 viewerCountValue] < [(YPChannel *)obj2 viewerCountValue];
        }];
        
        weakSelf.channels = channels;
        [weakSelf.tableView reloadData];
        // [weakSelf searchAndNotify];
    }];
}

- (void)awakeFromNib
{
    self.window.menuBarIcon = [NSImage imageNamed:@"PeerCastYellowPagesLogo"];
    self.window.hasMenuBarIcon = YES;
    self.window.attachedToMenuBar = YES;
    self.window.hideWindowControlsWhenAttached = YES;
}

#pragma mark -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if (aTableView == self.tableView) {
        return self.channels.count;
    }
    else {
        return self.menuArray.count;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{
    if (tableView == self.tableView) {
        YPChannel *channel = self.channels[row];
        return channel.name;
    }
    else {
        NSDictionary *dict = self.menuArray[row];
        return dict[@"name"];
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == self.tableView) {
        YPChannel *channel = self.channels[row];
        
        YPChannelCellView *view = [tableView makeViewWithIdentifier:@"YPChannelCellView" owner:self];
        if (channel.identifier) {
            
            view.titleLabel.stringValue = channel.name;
            view.detailLabel.stringValue = channel.detail;
            view.countLabel.stringValue = [NSString stringWithFormat:@"%ld", (long)channel.viewerCount];
            view.contactURLLabel.stringValue = [channel.contactURL absoluteString];
        }
        
        return view;
    }
    else {
        NSTableCellView *view = [tableView makeViewWithIdentifier:@"MenuCellView" owner:self];
        
        NSDictionary *dict = self.menuArray[row];
        view.textField.stringValue = dict[@"name"];
        view.imageView.image = [NSImage imageNamed:dict[@"imageName"]];
        
        return view;
    }
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    YPChannel *channel = self.channels[rowIndex];
    
    // [channel openContactURLInBrowser];
    [channel play];
    
    return NO;
}

@end
