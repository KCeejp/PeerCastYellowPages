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
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
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

@end
