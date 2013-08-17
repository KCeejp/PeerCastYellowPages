#import "GTMNSString+HTML.h"
#import "CHCSVParser.h"

@interface YPChannel ()

// Private interface goes here.

@end

@implementation YPChannel

// Custom logic goes here.

- (NSString *)host
{
    return [NSString stringWithFormat:@"%@:%@", self.ipAddress, self.port];
}

- (NSURL *)plsURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%lu/pls/%@?tip=%@", [YPSettings sharedSettings].peerCastHost, (unsigned long)[YPSettings sharedSettings].peerCastPort, self.identifier, self.host]];
}

- (NSURL *)streamURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%lu/stream/%@.%@", [YPSettings sharedSettings].peerCastHost, (unsigned long)[YPSettings sharedSettings].peerCastPort, self.identifier, [self.format lowercaseString]]];
}

- (NSString *)name
{
    return [self.primitiveName gtm_stringByUnescapingFromHTML];
}

- (NSString *)detail
{
    return [self.primitiveDetail gtm_stringByUnescapingFromHTML];
}

#pragma mark -

- (void)setContactURL:(NSURL *)contactURL
{
    self.contactURLString = [contactURL absoluteString];
}

- (NSURL *)contactURL
{
    return [NSURL URLWithString:self.contactURLString];
}

- (void)setYellowPageURL:(NSURL *)yellowPageURL
{
    self.yellowPageURLString = [yellowPageURL absoluteString];
}

- (NSURL *)yellowPageURL
{
    return [NSURL URLWithString:self.yellowPageURLString];
}

- (NSString *)yellowPageName
{
    YPYellowPage *yellowPage = [YPYellowPage MR_findFirstByAttribute:@"indexDotTxtURLString" withValue:self.yellowPageURLString];
    return yellowPage.name;
}

#pragma mark -

- (void)play
{
    NSArray *commands = [self parsePlayerCommand];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:commands[0] arguments:[commands objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, commands.count - 1)]]];
    [task waitUntilExit];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Now Playing...";
    notification.informativeText = [NSString stringWithFormat:@"%@ %@", self.name, self.detail];
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    [self parsePlayerCommand];
}

- (NSArray *)parsePlayerCommand
{
    NSString *playerCommand = [YPSettings sharedSettings].playerCommand;
    playerCommand = [playerCommand stringByReplacingOccurrencesOfString:@" " withString:@","];
    
    NSArray *strings = [playerCommand CSVComponents][0];
    
    NSMutableArray *commands = @[].mutableCopy;
    for (NSString *string in strings) {
        NSString *command;
        if ([string isEqualToString:YPPlaceholderForPlaylistURL]) {
            command = [self.streamURL absoluteString];
        }
        else if ([string isEqualToString:YPPlaceholderForStreamURL]) {
            command = [self.streamURL absoluteString];
        }
        else {
            command = string;
        }
        command = [command stringByReplacingOccurrencesOfString:@"," withString:@" "];
        command = [command stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        [commands addObject:command];
    }
    return commands;
}

- (void)openContactURLInBrowser
{
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[self.contactURLString]];
    [task waitUntilExit];
}

- (void)notifyNewChannel
{
    if (!self.newValue) return;
    if (![self notify]) return;
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = [NSString stringWithFormat:@"%@ became online", self.name];
    notification.informativeText = self.detail;
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    NSLog(@"%@", self.name);
    NSLog(@"%@", self.identifier);
}

- (BOOL)notify
{
    __block BOOL notify = NO;
    
    NSArray *favorites = [YPFavorite MR_findAll];
    
    NSArray *keywords = [favorites map:^id(id obj) {
        return [(YPFavorite *)obj keyword];
    }];
    
    NSString *pattern = [keywords componentsJoinedByString:@"|"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    id block = ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            notify = YES;
        }
    };
    [regex enumerateMatchesInString:self.name options:0 range:NSMakeRange(0, self.name.length) usingBlock:block];
    [regex enumerateMatchesInString:self.detail options:0 range:NSMakeRange(0, self.detail.length) usingBlock:block];
    
    return notify;
}

- (void)toggleFavorite
{
    YPFavorite *favorite = self.favorite;
    
    if (favorite) {
        [self deleteFavorite];
    }
    else {
        [self addFavorite];
    }
}

- (void)addFavorite
{
    if (self.favorite) return;
    
    YPFavorite *favorite = [YPFavorite MR_createEntity];
    favorite.keyword = self.name;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YPNotificationFavoriteCreated object:self];
}

- (void)deleteFavorite
{
    if (!self.favorite) return;
    
    [self.favorite MR_deleteEntity];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YPNotificationFavoriteDeleted object:self];
}

- (YPFavorite *)favorite
{
    return [YPFavorite MR_findFirstByAttribute:@"keyword" withValue:self.name];
}

@end
