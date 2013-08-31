//
//  YPChannelUpdator.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/15/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPChannelUpdator.h"

#import "YPYellowPagesClient.h"
#import "YPYellowPage.h"


@implementation YPChannelUpdator

+ (YPChannelUpdator *)sharedUpdator
{
    static dispatch_once_t once;
    static YPChannelUpdator *instance;
    dispatch_once(&once, ^ {
        instance = [[YPChannelUpdator alloc] init];
    });
    return instance;
}

- (void)fetchWithCompletion:(void(^)(NSArray *channels))completion
{
    __weak __block __typeof__(self) weakSelf = self;
    
    NSArray *yellowPages = [YPYellowPage MR_findAll];
    
    NSMutableArray *operations = @[].mutableCopy;
    for (YPYellowPage *yellowPage in yellowPages) {
        NSURL *URL = yellowPage.indexDotTxtURL;
        YPYellowPagesClient *client = [[YPYellowPagesClient alloc] initWithBaseURL:URL];
        [client registerHTTPOperationClass:[YPIndexDotTxtRequestOperation class]];
        NSURLRequest *request = [client requestWithMethod:@"GET" path:URL.path parameters:nil];
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [operations addObject:operation];
    }
    
    YPYellowPagesClient *sharedClient = [[YPYellowPagesClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com"]];
    [sharedClient registerHTTPOperationClass:[YPIndexDotTxtRequestOperation class]];
    [sharedClient enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } completionBlock:^(NSArray *operations) {
        
        [weakSelf deleteAllAnnouncement];
        
        NSMutableArray *channels = @[].mutableCopy;
        for (AFHTTPRequestOperation *operation in operations) {
            
            YPIndexDotTxtRequestOperation *indexDotTxtOperation = (YPIndexDotTxtRequestOperation *)operation;
            [channels addObjectsFromArray:indexDotTxtOperation.responseChannels];
        }
        
        [weakSelf deleteDisappearedChannels:channels];
        channels = [weakSelf sortByViewerCount:channels].mutableCopy;
        
        if (completion) {
            completion(channels);
        }
    }];
}

- (NSArray *)sortByViewerCount:(NSArray *)channels
{
    return [channels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(YPChannel *)obj1 viewerCountValue] < [(YPChannel *)obj2 viewerCountValue];
    }];
}

- (void)deleteAllAnnouncement
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", YPAnnouncementIdentifier];
    [YPChannel MR_deleteAllMatchingPredicate:predicate];
}

- (void)deleteDisappearedChannels:(NSArray *)channels
{
    NSArray *identifiers = [channels map:^id(id obj) {
        return (NSString *)[(YPChannel *)obj identifier];
    }];

    NSPredicate *predicate = [NSCompoundPredicate notPredicateWithSubpredicate:[NSPredicate predicateWithFormat:@"identifier IN (%@)", identifiers]];
    [YPChannel MR_deleteAllMatchingPredicate:predicate];

    NSLog(@"After Delete: %lu", (unsigned long)[YPChannel MR_countOfEntities]);
}

@end
