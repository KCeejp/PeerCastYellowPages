//
//  YPIndexDotTxtRequestOperation.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "YPChannel.h"

@interface YPIndexDotTxtRequestOperation : AFHTTPRequestOperation

@property (nonatomic) NSArray *responseChannels;

@end
