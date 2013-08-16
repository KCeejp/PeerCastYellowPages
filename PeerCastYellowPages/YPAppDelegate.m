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
    
    self.tableViewType = YPTableViewTypeDefault;
    
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
    
    __weak __block __typeof__(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:YPNotificationFavoriteCreated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf.tableView reloadData];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:YPNotificationFavoriteDeleted object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf.tableView reloadData];
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
    self.window.menuBarIcon = [NSImage imageNamed:@"PeerCastYellowPagesLogo"];
    self.window.hasMenuBarIcon = YES;
    self.window.attachedToMenuBar = YES;
    self.window.hideWindowControlsWhenAttached = YES;

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
            view.countLabel.stringValue = [NSString stringWithFormat:@"%ld", (long)channel.viewerCount];
            view.yellowPageNameLabel.stringValue = channel.yellowPageName;
            
            NSImage *starImage = [NSImage imageNamed:@"28-star"];
            view.favoriteButton.image = (channel.favorite)
                ? [starImage hh_imageTintedWithColor:[NSColor yellowColor]]
                : [starImage hh_imageTintedWithColor:[NSColor grayColor]]
                ;
            
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
    if (aTableView == self.tableView) {
        YPChannel *channel = self.arrangedChannels[rowIndex];
        [channel play];
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
    }
    
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
            arrangedChannels = [self filterChannels:self.channels ByKeywords:keywords];
            break;
        }
        default:
            arrangedChannels = self.channels;
            break;
    }
    return arrangedChannels;
}

- (NSArray *)filterChannels:(NSArray *)channels ByKeywords:(NSArray *)keywords
{
    NSMutableArray *predicates = @[].mutableCopy;
    for (NSString *keyword in keywords) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@ || self.detail CONTAINS[cd] %@", keyword, keyword];
        [predicates addObject:predicate];
    }
    return [channels filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSSearchField *searchField = (NSSearchField *)[obj object];
    self.filteredChannels = [self filterChannels:[self baseChannels] ByKeywords:@[searchField.stringValue]];
    [self.tableView reloadData];
}

@end
