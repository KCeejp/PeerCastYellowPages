//
//  YPIndexDotTxtRequestOperation.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/13/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPIndexDotTxtRequestOperation.h"

@implementation YPIndexDotTxtRequestOperation

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"text/plain", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"txt"] || [super canProcessRequest:request];
}

- (NSArray *)responseChannels
{
    NSLog(@"Begin: %lu", (unsigned long)[YPChannel MR_countOfEntities]);
    
    NSMutableArray *lines = @[].mutableCopy;
    [self.responseString enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        [lines addObject:line];
    }];
    
    NSMutableArray *responseChannels = @[].mutableCopy;
    for (NSString *string in lines) {
        NSArray *elements = [string componentsSeparatedByString:@"<>"];
        
        NSString *identifier = elements[1];
        YPChannel *channel = [YPChannel MR_findFirstByAttribute:@"identifier" withValue:identifier];
        if (channel) {
            channel.newValue = NO;
        }
        else {
            channel = [YPChannel MR_createEntity];
            channel.newValue = YES;
        }
        
        channel.yellowPageURLString = [self.request.URL absoluteString];
        channel.name = elements[0];
        channel.identifier = elements[1];
        
        NSString *host = elements[2];
        if (host && ![host isEqualToString:@""]) {
            channel.ipAddress = [host componentsSeparatedByString:@":"][0];
            channel.port = [NSNumber numberWithInteger:[[host componentsSeparatedByString:@":"][1] integerValue]];
        }
        
        channel.contactURLString = elements[3];
        channel.genre = elements[4];
        channel.detail = elements[5];
        channel.viewerCount = [NSNumber numberWithInteger:[elements[6] integerValue]];
        channel.relayCount = [NSNumber numberWithInteger:[elements[7] integerValue]];
        channel.bitrate = [NSNumber numberWithInteger:[elements[8] integerValue]];
        channel.format = elements[9];
        channel.status = elements[17];
        channel.comment = elements[18];
        
        [channel notifyNewChannel];
        
        [responseChannels addObject:channel];
    }
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    [mainContext MR_saveToPersistentStoreAndWait];
    
    return responseChannels;
}

@end
