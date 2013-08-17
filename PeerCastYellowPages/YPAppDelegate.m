//
//  YPAppDelegate.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPAppDelegate.h"

#import <WebKit/WebKit.h>
#import "YPChannelUpdator.h"

// Views
#import "YPChannelCellView.h"
#import "MASPreferencesWindowController.h"

#import "YPGeneralPreferencesViewController.h"
#import "YPYellowPagesPreferencesViewController.h"
#import "YPPlayerPreferencesViewController.h"

typedef NS_ENUM(NSUInteger, YPTableViewType) {
    YPTableViewTypeDefault = 1,
    YPTableViewTypeFavorite,
    YPTableViewTypePopular,
};

@interface YPAppDelegate () <NSUserNotificationCenterDelegate>

@property (nonatomic) NSStatusItem *statusItem;

@property (nonatomic) YPTableViewType tableViewType;

@property (nonatomic) NSArray *channels;
@property (nonatomic) NSArray *filteredChannels;

@property (nonatomic) NSArray *menuArray;

@property (nonatomic) MASPreferencesWindowController *preferencesWindowController;

@property (nonatomic) NSTimer *refreshTimer;
@property (nonatomic) id refreshTimerObserver;

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
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"PeerCastYellowPagesLogo"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setEnabled:YES];
    [self.statusItem setTarget:self];
    [self.statusItem setAction:@selector(openWindow:)];

    self.tableViewType = YPTableViewTypeDefault;
    
    self.menuArray = @[
                       @{@"imageName": @"400-list2", @"name": @"Home"},
                       @{@"imageName": @"28-star", @"name": @"Favorite"},
                       ];
    [self.menuTableView reloadData];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [self resetRefreshTimer];
    
    [self fetchYellowPages:nil];
    
    
    YPGeneralPreferencesViewController *generalViewController = [[YPGeneralPreferencesViewController alloc] init];
    YPYellowPagesPreferencesViewController *yellowPagesViewController = [[YPYellowPagesPreferencesViewController alloc] init];
    YPPlayerPreferencesViewController *playerViewController = [[YPPlayerPreferencesViewController alloc] init];
    
    self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:@[
                                                                                                         generalViewController,
                                                                                                         yellowPagesViewController,
                                                                                                         playerViewController,
                                                                                                         ]];
    self.channelArrayController.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    __weak __block __typeof__(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:YPNotificationFavoriteCreated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf.tableView reloadData];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:YPNotificationFavoriteDeleted object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf.tableView reloadData];
    }];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.menuTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    
    [self.webView setCustomUserAgent:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3"];
}

- (void)resetRefreshTimer
{
    [self.refreshTimer invalidate];
    
    NSTimeInterval interval = [YPSettings sharedSettings].refreshInterval;
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(fetchYellowPages:) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.refreshTimerObserver];
    __weak __block __typeof__(self) weakSelf = self;
    self.refreshTimerObserver =  [[NSNotificationCenter defaultCenter] addObserverForName:YPNotificationRefreshIntervalChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf resetRefreshTimer];
    }];
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
    /*
    self.window.menuBarIcon = [NSImage imageNamed:@"PeerCastYellowPagesLogo"];
    self.window.hasMenuBarIcon = YES;
    self.window.attachedToMenuBar = YES;
    self.window.hideWindowControlsWhenAttached = YES;
    */
    
    INAppStoreWindow *window = (INAppStoreWindow*)self.window;
    window.titleBarHeight = 55.f;
    window.centerTrafficLightButtons = YES;
}

#pragma mark -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if (aTableView == self.tableView) {
        return self.arrangedChannels.count;
    }
    else {
        return self.menuArray.count;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{
    if (tableView == self.tableView) {
        YPChannel *channel = self.arrangedChannels[row];
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
        YPChannel *channel = self.arrangedChannels[row];
        
        YPChannelCellView *view = [tableView makeViewWithIdentifier:@"YPChannelCellView" owner:self];
        if (channel.identifier) {
            
            view.titleLabel.stringValue = channel.name;
            view.detailLabel.stringValue = channel.detail;
            view.genreLabel.stringValue = channel.genre;
            view.countLabel.stringValue = [NSString stringWithFormat:@"%d/%d %dkbps %@",
                                           channel.viewerCountValue,
                                           channel.relayCountValue,
                                           channel.bitrateValue,
                                           channel.format];
            view.yellowPageNameLabel.stringValue = channel.yellowPageName;
            
            NSImage *starImage = [NSImage imageNamed:@"28-star"];
            view.favoriteButton.image = (channel.favorite)
                ? [starImage hh_imageTintedWithColor:[NSColor yellowColor]]
                : [starImage hh_imageTintedWithColor:[NSColor grayColor]]
                ;
            view.playButton.image = [view.playButton.image hh_imageTintedWithColor:[NSColor redColor]];
            
            if (!channel.contactURLString || [channel.contactURLString isEqualToString:@""]) {
                view.browserButton.alphaValue = 0;
            }
            
            view.playButton.target = self;
            view.playButton.action = @selector(onPlayButtonPressed:);
            
            view.favoriteButton.target = self;
            view.favoriteButton.action = @selector(onFavoriteButtonPressed:);
            
            view.browserButton.target = self;
            view.browserButton.action = @selector(onBrowserButtonPressed:);
        }
        
        return view;
    }
    else {
        NSTableCellView *view = [tableView makeViewWithIdentifier:@"MenuCellView" owner:self];
        
        NSDictionary *dict = self.menuArray[row];
        view.textField.stringValue = dict[@"name"];
        view.imageView.image = [[NSImage imageNamed:dict[@"imageName"]] hh_imageTintedWithColor:[NSColor blueColor]];
        
        return view;
    }
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    BOOL shouldSelectRow = NO;
    if (aTableView == self.tableView) {
        YPChannel *channel = self.arrangedChannels[rowIndex];
        // [channel play];
        [self openWebViewDrawerWithURL:channel.contactURL];
    }
    else {
        switch (rowIndex + 1) {
            case YPTableViewTypeDefault:
                self.tableViewType = YPTableViewTypeDefault;
                break;
            case YPTableViewTypeFavorite:
                self.tableViewType = YPTableViewTypeFavorite;
                break;
            default:
                break;
        }
        self.searchField.stringValue = @"";
        [self.tableView reloadData];
        shouldSelectRow = YES;
    }
    return shouldSelectRow;
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

- (void)onPlayButtonPressed:(id)sender
{
    NSInteger row = [self indexForEvent]; // or use tag on button, maybe?
    YPChannel *channel = self.arrangedChannels[row];
    [channel play];
}

- (void)onFavoriteButtonPressed:(id)sender
{
    NSInteger row = [self indexForEvent]; // or use tag on button, maybe?
    YPChannel *channel = self.arrangedChannels[row];
    [channel toggleFavorite];
}

- (void)onBrowserButtonPressed:(id)sender
{
    NSInteger row = [self indexForEvent]; // or use tag on button, maybe?
    YPChannel *channel = self.arrangedChannels[row];
    [channel openContactURLInBrowser];
}

- (NSUInteger)indexForEvent
{
    NSEvent *event = [NSApp currentEvent];
    NSPoint pointInTable = [self.tableView convertPoint:[event locationInWindow] fromView:nil];
    NSUInteger row = [self.tableView rowAtPoint:pointInTable];
    return row;
}

- (NSArray *)arrangedChannels
{
    NSArray *arrangedChannels;
    if (![self.searchField.stringValue isEqualToString:@""]) {
        arrangedChannels = self.filteredChannels;
    }
    else {
        arrangedChannels = [self baseChannels];
    }
    return arrangedChannels;
}

- (NSArray *)baseChannels
{
    NSArray *arrangedChannels;
    switch (self.tableViewType) {
        case YPTableViewTypeDefault: {
            arrangedChannels = self.channels;
            break;
        }
        case YPTableViewTypeFavorite: {
            NSArray *favorites = [YPFavorite MR_findAll];
            NSArray *keywords = [favorites map:^id(id obj) {
                return [(YPFavorite *)obj keyword];
            }];
            arrangedChannels = [self filterChannels:self.channels byKeywords:keywords];
            break;
        }
        default:
            arrangedChannels = self.channels;
            break;
    }
    return arrangedChannels;
}

- (NSArray *)filterChannels:(NSArray *)channels byKeywords:(NSArray *)keywords
{
    NSMutableArray *predicates = @[].mutableCopy;
    for (NSString *keyword in keywords) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@ || self.detail CONTAINS[cd] %@ || self.genre CONTAINS[cd] %@", keyword, keyword, keyword];
        [predicates addObject:predicate];
    }
    return [channels filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSSearchField *searchField = (NSSearchField *)[obj object];
    self.filteredChannels = [self filterChannels:[self baseChannels] byKeywords:@[searchField.stringValue]];
    [self.tableView reloadData];
}

- (IBAction)onSegmentedControlPressed:(id)sender
{
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *)sender;
    switch (segmentedControl.selectedSegment) {
        case 0: {
            [self displayPreferences];
            break;
        }
        case 1: {
            [self fetchYellowPages:nil];
            break;
        }
        default:
            break;
    }
    segmentedControl.selectedSegment = -1;
}

- (IBAction)onWebViewTopSegmentedControlPressed:(id)sender
{
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *)sender;
    switch (segmentedControl.selectedSegment) {
        case 1: {
            [self.drawer close];
            break;
        }
        default:
            break;
    }
    segmentedControl.selectedSegment = -1;
}

- (IBAction)onWebViewBottomSegmentedControlPressed:(id)sender
{
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *)sender;
    switch (segmentedControl.selectedSegment) {
        case 1:
            [self.webView reload:nil];
            break;
        case 2:
            [self.webView goBack];
            break;
        case 3:
            [self.webView goForward];
            break;
        default:
            break;
    }
    segmentedControl.selectedSegment = -1;
}

- (void)openWindow:(id)sender
{
    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)openWebViewDrawerWithURL:(NSURL *)URL
{
    if (self.drawer.state == NSDrawerOpeningState || self.drawer.state == NSDrawerOpenState) {
        if ([self.webView.mainFrameURL isEqualToString:[URL absoluteString]]) {
            [self.drawer close];
        }
        else {
            [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:URL]];
        }
    }
    else {
        self.drawer.contentSize = NSSizeFromCGSize(self.drawerView.frame.size);
        [self.drawer openOnEdge:NSMaxXEdge];
        [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:URL]];
    }
}

#pragma mark - NSDrawerViewDelegate

- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize
{
    return [sender contentSize];
}

@end
