//
//  YPGeneralPreferencesViewController.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPGeneralPreferencesViewController.h"

@interface YPGeneralPreferencesViewController ()

@end

@implementation YPGeneralPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"YPGeneralPreferencesViewController" bundle:nil];
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
    self.peerCastHostTextField.stringValue = [YPSettings sharedSettings].peerCastHost;
    self.peerCastPortTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)[YPSettings sharedSettings].peerCastPort];
    self.refreshIntervalForm.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)[YPSettings sharedSettings].refreshInterval];
}

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

#pragma mark -

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    if (self.peerCastHostTextField == obj.object) {
        [YPSettings sharedSettings].peerCastHost = self.peerCastHostTextField.stringValue;
    }
    if (self.peerCastPortTextField == obj.object) {
        [YPSettings sharedSettings].peerCastPort = [self.peerCastPortTextField.stringValue integerValue];
    }
    if (self.refreshIntervalForm == obj.object) {
        [YPSettings sharedSettings].refreshInterval = [self.refreshIntervalForm.stringValue integerValue];
    }
}

- (IBAction)onStartOnSystemStartUpChanged:(id)sender
{
    switch ([(NSButton *)sender state]) {
        case NSOnState:
            [YPSettings sharedSettings].startOnSystemStartUp = YES;
            break;
        default:
            [YPSettings sharedSettings].startOnSystemStartUp = NO;
            break;
    }
}

- (IBAction)onResetButtonPressed:(id)sender
{
    [[YPSettings sharedSettings] resetSettings];
}

@end
