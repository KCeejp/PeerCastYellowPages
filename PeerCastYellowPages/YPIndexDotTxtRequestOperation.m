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
    NSMutableArray *lines = @[].mutableCopy;
    [self.responseString enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        [lines addObject:line];
    }];
    
    NSArray *identifiers = [lines map:^id(id obj) {
        return [(NSString *)obj componentsSeparatedByString:@"<>"][1];
    }];
    
    // [YPChannel MR_truncateAll];
    NSPredicate *predicate = [NSCompoundPredicate notPredicateWithSubpredicate:[NSPredicate predicateWithFormat:@"(identifier IN %@)", identifiers]];
    [YPChannel MR_deleteAllMatchingPredicate:predicate];
    
    NSMutableArray *responseChannels = @[].mutableCopy;
    for (NSString *string in lines) {
        NSArray *elements = [string componentsSeparatedByString:@"<>"];
        
        YPChannel *channel = [YPChannel MR_findFirstByAttribute:@"identifier" withValue:[string componentsSeparatedByString:@"<>"][1]];
        if (!channel) {
            channel = [YPChannel MR_createEntity];
            channel.newValue = YES;
        }
        else {
            channel.newValue = NO;
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
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:nil];
    
    return responseChannels;
}

@end
