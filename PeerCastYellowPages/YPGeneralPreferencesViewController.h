//
//  YPGeneralPreferencesViewController.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface YPGeneralPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSTextField *peerCastHostTextField;
@property (weak) IBOutlet NSTextField *peerCastPortTextField;
@property (weak) IBOutlet NSButton *startOnSystemStartUpButton;

@end
