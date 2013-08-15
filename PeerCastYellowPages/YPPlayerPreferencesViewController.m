//
//  YPPlayerPreferencesViewController.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/16/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPPlayerPreferencesViewController.h"

@interface YPPlayerPreferencesViewController ()

@end

@implementation YPPlayerPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"YPPlayerPreferencesViewController" bundle:nil];
}

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"PlayerPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Player", @"Toolbar item name for the General preference pane");
}

@end
