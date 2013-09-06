//
//  YPAppDelegate.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "INAppStoreWindow.h"

@class WebView, MGScopeBar;

@interface YPAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet INAppStoreWindow *window;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableView *menuTableView;

@property (weak) IBOutlet NSArrayController *channelArrayController;
@property (weak) IBOutlet NSArrayController *menuArrayController;

@property (weak) IBOutlet NSSearchField *searchField;

@property (weak) IBOutlet NSDrawer *drawer;
@property (weak) IBOutlet NSView *drawerView;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSView *rightPaneView;
@property (weak) IBOutlet MGScopeBar *scopeBar;

@property (weak) IBOutlet NSMenuItem *stopRecordingMenuItem;
@property (weak) IBOutlet NSMenuItem *recordingMenuItem;

@end
