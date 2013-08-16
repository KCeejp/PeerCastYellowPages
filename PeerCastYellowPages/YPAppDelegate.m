//
//  YPAppDelegate.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPAppDelegate.h"

#import "YPChannelUpdator.h"
#import "YPYellowPage.h"

// Views
#import "YPChannelCellView.h"
#import "MASPreferencesWindowController.h"

#import "YPGeneralPreferencesViewController.h"
#import "YPYellowPagesPreferencesViewController.h"
#import "YPPlayerPreferencesViewController.h"

@interface YPAppDelegate () <NSUserNotificationCenterDelegate>

@property (nonatomic) NSStatusItem *statusItem;

@property (nonatomic) NSArray *channels;
@property (nonatomic) NSArray *menuArray;

@property (nonatomic) MASPreferencesWindowController *preferencesWindowController;

@end

@implementation YPAppDelegate

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [MagicalRecord setupCoreDataStack];
    
    // [self initializeYellowPages];
    
    self.menuArray = @[
                       @{@"imageName": @"53-house", @"name": @"Home"},
                       @{@"imageName": @"28-star", @"name": @"Favorite"},
                       @{@"imageName": @"28-star", @"name": @"Popular"},
                       ];
    [self.menuTableView reloadData];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    
    [self fetchYellowPages:nil];
    
    NSTimeInterval interval = 2 * 60;
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(fetchYellowPages:) userInfo:nil repeats:YES];
    
    YPGeneralPreferencesViewController *generalViewController = [[YPGeneralPreferencesViewController alloc] init];
    YPYellowPagesPreferencesViewController *yellowPagesViewController = [[YPYellowPagesPreferencesViewController alloc] init];
    YPPlayerPreferencesViewController *playerViewController = [[YPPlayerPreferencesViewController alloc] init];
    
    self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:@[
                                                                                                         generalViewController,
                                                                                                         yellowPagesViewController,
                                                                                                         playerViewController,
                                                                                                         ]];
    self.channelArrayController.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)fetchYellowPages:(id)sender
{
    __weak __block __typeof__(self) weakSelf = self;
    [[YPChannelUpdator sharedUpdator] fetchWithCompletion:^(NSArray *channels) {
        weakSelf.channels = channels;
        [weakSelf.tableView reloadData];
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
        return [(NSArray *)self.channelArrayController.arrangedObjects count];
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
            view.yellowPageNameLabel.stringValue = channel.yellowPageName;
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
    
    [channel openContactURLInBrowser];
    [channel play];
    
    return NO;
}

- (void)initializeYellowPages
{
    NSArray *URLs = @[
                      @{@"name":@"SP", @"url":[NSURL URLWithString:@"http://bayonet.ddo.jp/sp/index.txt"]},
                      @{@"name":@"TP", @"url":[NSURL URLWithString:@"http://temp.orz.hm/yp/index.txt"]},
                      @{@"name":@"DP", @"url":[NSURL URLWithString:@"http://dp.prgrssv.net/index.txt"]},
                      @{@"name":@"HKTV", @"url":[NSURL URLWithString:@"http://games.himitsukichi.com/hktv/index.txt"]},
                      ];
    for (NSDictionary *dict in URLs) {
        YPYellowPage *yellowPage = [YPYellowPage MR_createEntity];
        yellowPage.name = dict[@"name"];
        yellowPage.indexDotTxtURL = dict[@"url"];
    }
}

- (IBAction)onPreferencesButtonPressed:(id)sender
{
    [self displayPreferences];
}

- (IBAction)onPreferencesPressed:(id)sender
{
    [self displayPreferences];
}

- (void)displayPreferences
{
    [self.preferencesWindowController showWindow:nil];
}

@end
