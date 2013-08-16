//
//  YPAppDelegate.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OBMenuBarWindow.h"

@interface YPAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet OBMenuBarWindow *window;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableView *menuTableView;

@property (weak) IBOutlet NSArrayController *channelArrayController;
@property (weak) IBOutlet NSArrayController *menuArrayController;

@property (weak) IBOutlet NSSearchField *searchField;

@end
