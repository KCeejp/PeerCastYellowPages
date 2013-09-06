//
//  YPRecordingManager.h
//  PeerCastYellowPages
//
//  Created by KCee.jp on 9/7/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPRecordingManager : NSObject

+ (YPRecordingManager *)sharedManager;
- (void)enqueueRecordingOperation:(NSOperation *)operation;

@end
