//
//  YPPlayerPreferencesViewController.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/16/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface YPPlayerPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSTextField *playerCommandTextField;
@property (weak) IBOutlet NSTextField *descriptionLabel;

@end
