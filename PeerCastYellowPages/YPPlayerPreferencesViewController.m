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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self populateValues];
    
    __weak __block __typeof__(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:YPNotificationDidResetSettings object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf populateValues];
    }];
}

- (void)populateValues
{
    self.playerCommandTextField.stringValue = [YPSettings sharedSettings].playerCommand;
    self.descriptionLabel.stringValue = [NSString stringWithFormat:@"Use %@ for stream URL, %@ for playlist URL", YPPlaceholderForStreamURL, YPPlaceholderForPlaylistURL];
}

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"PlayerPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Player", @"Toolbar item name for the General preference pane");
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    [YPSettings sharedSettings].playerCommand = [(NSTextField *)obj.object stringValue];
}

@end
