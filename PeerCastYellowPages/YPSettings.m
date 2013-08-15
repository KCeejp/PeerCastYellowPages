//
//  YPSettings.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPSettings.h"

static NSString * const YPSettingsInitialLaunchFinished = @"YPSettingsInitialLaunchFinished";
static NSString * const YPSettingsStartOnSystemStartUp = @"YPSettingsStartOnSystemStartUp";
static NSString * const YPSettingsPeerCastHost = @"YPSettingsPeerCastHost";
static NSString * const YPSettingsPeerCastPort = @"YPSettingsPeerCastPort";

@implementation YPSettings

#pragma mark -

+ (YPSettings *)sharedSettings
{
    static dispatch_once_t once;
    static YPSettings *instance;
    dispatch_once(&once, ^ {
        instance = [[YPSettings alloc] init];
        if (!instance.isInitialLaunchFinished) {
            [instance initializeSettings];
        }
    });
    return instance;
}

#pragma mark -

- (void)initializeSettings
{
    self.startOnSystemStartUp = YES;
    
    self.peerCastHost = @"localhost";
    self.peerCastPort = 7144;
    
    self.initialLaunchFinished = YES;
}

#pragma mark - Getter/Setter

- (void)setInitialLaunchFinished:(BOOL)initialLaunchFinished
{
    [[NSUserDefaults standardUserDefaults] setBool:initialLaunchFinished forKey:YPSettingsInitialLaunchFinished];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)initialLaunchFinished
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:YPSettingsInitialLaunchFinished];
}

- (void)setStartOnSystemStartUp:(BOOL)startOnSystemStartUp
{
    [[NSUserDefaults standardUserDefaults] setBool:startOnSystemStartUp forKey:YPSettingsStartOnSystemStartUp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)startOnSystemStartUp
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:YPSettingsStartOnSystemStartUp];
}

- (void)setPeerCastHost:(NSString *)peerCastHost
{
    [[NSUserDefaults standardUserDefaults] setObject:peerCastHost forKey:YPSettingsPeerCastHost];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)peerCastHost
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:YPSettingsPeerCastHost];
}

- (void)setPeerCastPort:(NSUInteger)peerCastPort
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:peerCastPort] forKey:YPSettingsPeerCastPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)peerCastPort
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:YPSettingsPeerCastPort] unsignedIntegerValue];
}

@end
