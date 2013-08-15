//
//  YPChannelUpdator.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YPChannel.h"

@interface YPChannelUpdator : NSObject

+ (YPChannelUpdator *)sharedUpdator;
- (void)fetchWithCompletion:(void(^)(NSArray *channels))completion;

@end
