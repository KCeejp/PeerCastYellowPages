//
//  YPYellowPagesPreferencesViewController.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface YPYellowPagesPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSTableView *yellowPagesTableView;
@property (weak) IBOutlet NSSegmentedControl *yellowPagesSegmentedControl;
@property (strong) IBOutlet NSArrayController *yellowPagesArrayController;

@property (weak) IBOutlet NSSegmentedControl *favoriteSegmentedControl;
@property (weak) IBOutlet NSTableView *favoriteTableView;
@property (strong) IBOutlet NSArrayController *favoriteArrayController;

@end
