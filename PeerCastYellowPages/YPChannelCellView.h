//
//  YPChannelCellView.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/14/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YPChannelCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *countLabel;
@property (weak) IBOutlet NSTextField *detailLabel;
@property (weak) IBOutlet NSTextField *contactURLLabel;
@property (weak) IBOutlet NSTextField *yellowPageNameLabel;

@end
