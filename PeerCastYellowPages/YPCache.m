//
//  YPCache.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/31/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPCache.h"

@implementation YPCache

+ (YPCache *)sharedCache
{
    static dispatch_once_t once;
    static YPCache *instance;
    dispatch_once(&once, ^ { instance = [[YPCache alloc] init]; });
    return instance;
}

@end
