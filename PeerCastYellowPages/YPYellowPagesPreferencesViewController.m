//
//  YPYellowPagesPreferencesViewController.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPYellowPagesPreferencesViewController.h"
#import "YPFavorite.h"
#import "YPYellowPage.h"

typedef NS_ENUM(NSUInteger, YPSegmentedControlIndex) {
    YPSegmentedControlIndexAdd = 1,
    YPSegmentedControlIndexRemove = 2,
};

@interface YPYellowPagesPreferencesViewController ()

@end

@implementation YPYellowPagesPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"YPYellowPagesPreferencesViewController" bundle:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.favoriteArrayController.managedObjectContext = [NSManagedObjectContext MR_defaultContext];

    self.yellowPagesArrayController.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
}

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"YellowPagesPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"YellowPages", @"Toolbar item name for the General preference pane");
}

- (IBAction)onYellowPagesSegmentedControlChanged:(id)sender
{
    switch ([(NSSegmentedControl *)sender selectedSegment]) {
        case YPSegmentedControlIndexAdd: {
            [self.yellowPagesArrayController add:nil];
            break;
        }
        case YPSegmentedControlIndexRemove: {
            NSArray *yellowPages = [self.yellowPagesArrayController selectedObjects];
            for (YPFavorite *yellowPage in yellowPages) {
                [self.yellowPagesArrayController remove:yellowPage];
            }
            
            break;
        }
        default:
            break;
    }
}

- (IBAction)onFavoriteSegmentedControlChanged:(id)sender
{
    switch ([(NSSegmentedControl *)sender selectedSegment]) {
        case YPSegmentedControlIndexAdd: {
            // YPFavorite *favorite = [YPFavorite MR_createEntity];
            // favorite.keyword = @"";
            [self.favoriteArrayController add:nil];
            
            break;
        }
        case YPSegmentedControlIndexRemove: {
            NSArray *favorites = [self.favoriteArrayController selectedObjects];
            for (YPFavorite *favorite in favorites) {
                [self.favoriteArrayController remove:favorite];
            }
            break;
        }
        default:
            break;
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    /*
    if (obj.object == self.favoriteTableView) {
        NSArray *favorites = [self.favoriteArrayController selectedObjects];
        for (YPFavorite *favorite in favorites) {
            if (!favorite.keyword || [favorite.keyword isEqualToString:@""]) {
                [self.favoriteArrayController remove:favorite];
            }
        }
    }
    else if (obj.object == self.yellowPagesTableView) {
        NSArray *yellowPages = [self.yellowPagesArrayController selectedObjects];
        for (YPYellowPage *yellowPage in yellowPages) {
            if (!yellowPage.name || [yellowPage.name isEqualToString:@""] || !yellowPage.indexDotTxtURLString || [yellowPage.indexDotTxtURLString isEqualToString:@""]) {
                [self.yellowPagesArrayController remove:yellowPage];
            }
        }
    }
    */
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [self performBlock:^(id sender) {
        NSTableView *tableView = aNotification.object;
        NSIndexSet *indexes = [tableView selectedRowIndexes];
        
        NSUInteger rowSelected = [indexes firstIndex];
        [tableView editColumn:0 row:rowSelected withEvent:nil select:YES];  // This works here!
    } afterDelay:.5f];
}

@end
