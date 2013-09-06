//
//  YPRecordingManager.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 9/7/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPRecordingManager.h"

@interface YPRecordingManager ()

@property (nonatomic) NSOperationQueue *operationQueue;

@end

@implementation YPRecordingManager

+ (YPRecordingManager *)sharedManager
{
    static dispatch_once_t once;
    static YPRecordingManager *instance;
    dispatch_once(&once, ^ {
        instance = [[YPRecordingManager alloc] init];
        instance.operationQueue = [[NSOperationQueue alloc] init];
    });
    return instance;
}

- (void)enqueueRecordingOperation:(NSOperation *)operation
{
    [self.operationQueue addOperation:operation];
}

@end
