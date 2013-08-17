//
//  YPSettings.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPSettings : NSObject

+ (YPSettings *)sharedSettings;

- (void)resetSettings;

@property (nonatomic, getter=isInitialLaunchFinished) BOOL initialLaunchFinished;
@property (nonatomic) BOOL startOnSystemStartUp;

@property (nonatomic, copy) NSString *peerCastHost;
@property (nonatomic) NSUInteger peerCastPort;
@property (nonatomic) NSUInteger refreshInterval;
@property (nonatomic, copy) NSString *playerCommand;

@end
