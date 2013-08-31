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
static NSString * const YPSettingsRefreshInterval = @"YPSettingsRefreshInterval";
static NSString * const YPSettingsPlayerCommand = @"YPSettingsPlayerCommand";

@implementation YPSettings

#pragma mark -

+ (YPSettings *)sharedSettings
{
    static dispatch_once_t once;
    static YPSettings *instance;
    dispatch_once(&once, ^ {
        instance = [[YPSettings alloc] init];
        if (!instance.isInitialLaunchFinished) {
            [instance resetSettings];
        }
    });
    return instance;
}

#pragma mark -

- (void)resetSettings
{
    self.startOnSystemStartUp = YES;
    
    self.peerCastHost = @"localhost";
    self.peerCastPort = 7144;
    self.refreshInterval = 2 * 60;
    self.playerCommand = [NSString stringWithFormat:@"/usr/bin/open -a \"/Applications/Flip Player.app\" %@", YPPlaceholderForPlaylistURL];
    self.playerCommand = [NSString stringWithFormat:@"/Applications/MPlayerX.app/Contents/Resources/binaries/x86_64/mplayer -loop 0 -playlist %@", YPPlaceholderForPlaylistURL];
    self.playerCommand = [NSString stringWithFormat:@"\"/Applications/VLC.app/Contents/MacOS/VLC\" %@", YPPlaceholderForStreamURLMMSH];
    
    [self initializeYellowPages];
    
    self.initialLaunchFinished = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YPNotificationDidResetSettings object:nil];
}

- (void)initializeYellowPages
{
    [YPYellowPage MR_truncateAll];
    
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

- (void)setRefreshInterval:(NSUInteger)refreshInterval
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:refreshInterval] forKey:YPSettingsRefreshInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YPNotificationRefreshIntervalChanged object:nil];
}

- (NSUInteger)refreshInterval
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:YPSettingsRefreshInterval] unsignedIntegerValue];
}

- (void)setPlayerCommand:(NSString *)playerCommand
{
    [[NSUserDefaults standardUserDefaults] setObject:playerCommand forKey:YPSettingsPlayerCommand];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YPNotificationPlayerCommendChanged object:nil];
}

- (NSString *)playerCommand
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:YPSettingsPlayerCommand];
}

@end
