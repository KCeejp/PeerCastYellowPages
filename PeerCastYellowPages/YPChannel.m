#import "GTMNSString+HTML.h"
#import "CHCSVParser.h"
#import "YPCache.h"
#import "STPrivilegedTask.h"

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

- (NSURL *)streamURLMMS
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"mms://%@:%lu/stream/%@.%@", [YPSettings sharedSettings].peerCastHost, (unsigned long)[YPSettings sharedSettings].peerCastPort, self.identifier, [self.format lowercaseString]]];
}

- (NSURL *)streamURLMMSH
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"mmsh://%@:%lu/stream/%@.%@", [YPSettings sharedSettings].peerCastHost, (unsigned long)[YPSettings sharedSettings].peerCastPort, self.identifier, [self.format lowercaseString]]];
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
    NSString *key = [NSString stringWithFormat:@"yp:name:%@", self.yellowPageURLString];
    NSString *yellowPageName = [[YPCache sharedCache] objectForKey:key];
    if (!yellowPageName) {
        YPYellowPage *yellowPage = [YPYellowPage MR_findFirstByAttribute:@"indexDotTxtURLString" withValue:self.yellowPageURLString];
        yellowPageName = yellowPage.name;
        
        [[YPCache sharedCache] setObject:yellowPageName forKey:key];
    }
    return yellowPageName;
}

- (NSURL *)yellowPageSiteURLForChannel
{
    NSDictionary *dict = @{@"find":self.name};
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",
                           [self.yellowPageSiteURL absoluteString],
                           [self.yellowPageSiteURL query] ? @"&" : @"?", [self buildQueryFromDictionary:dict]];
    NSURL *URL = [NSURL URLWithString:URLString];
    return URL;
}

- (NSURL *)yellowPageSiteURL
{
    return [self.yellowPageURL URLByDeletingLastPathComponent];
}

- (NSString *)buildQueryFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *array = @[].mutableCopy;
    for (NSString *key in [dictionary allKeys]) {
        NSString *kv = ({
            NSString *value = [dictionary objectForKey:key];
            NSArray *array = @[
                               [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               ];
            [array componentsJoinedByString:@"="];
        });
        [array addObject:kv];
    }
    return [array componentsJoinedByString:@"&"];
}

#pragma mark -


- (void)openContactURLInBrowser
{
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[self.contactURLString]];
    [task waitUntilExit];
}

- (void)openYellowPageURLInBrowser
{
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[
                                                                                   [self.yellowPageSiteURLForChannel absoluteString]
                                                                                   ]];
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

#pragma mark - Player

- (void)playInMPlayerX
{
    NSString *playerCommand = [NSString stringWithFormat:@"/Applications/MPlayerX.app/Contents/Resources/binaries/x86_64/mplayer -loop 0 -playlist %@", [self.plsURL absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    [self executePlayerCommand:commands];
}

- (void)playInVLC
{
    [self startRecievingInMPlayerX];
    
    NSString *playerCommand = [NSString stringWithFormat:@"\"/Applications/VLC.app/Contents/MacOS/VLC\" %@", [self.streamURLMMSH absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    [self executePlayerCommand:commands];
}

- (void)playInFlipPlayer
{
    NSString *playerCommand = [NSString stringWithFormat:@"/usr/bin/open -a \"/Applications/Flip Player.app\" %@", [self.plsURL absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    [self executePlayerCommand:commands];
}

// open playlist but do nothing
// opening playlist will trigger channel recieving
- (void)startRecievingInVLC
{
    NSString *playerCommand = [NSString stringWithFormat:@"\"/Applications/VLC.app/Contents/MacOS/VLC\" %@ vlc://pause:0.1 vlc://quit --intf=rc --play-and-exit", [self.plsURL absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    NSTask *task = [self executePlayerCommand:commands];
    [task waitUntilExit];
}

- (void)startRecievingInMPlayerX
{
    NSString *playerCommand = [NSString stringWithFormat:@"/Applications/MPlayerX.app/Contents/Resources/binaries/x86_64/mplayer -slave %@", [self.plsURL absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    NSTask *task = [self executePlayerCommand:commands];
    [task waitUntilExit];
}

- (NSTask *)executePlayerCommand:(NSArray *)commands
{
    NSTask *task = [NSTask launchedTaskWithLaunchPath:commands[0] arguments:[commands objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, commands.count - 1)]]];
    return task;
}

- (NSArray *)commandArrayFromPlayerCommand:(NSString *)playerCommand
{
    playerCommand = [playerCommand stringByReplacingOccurrencesOfString:@" " withString:@","];
    
    NSArray *strings = [playerCommand CSVComponents][0];
    
    NSMutableArray *commands = @[].mutableCopy;
    for (NSString *string in strings) {
        NSString *command = string;
        command = [command stringByReplacingOccurrencesOfString:@"," withString:@" "];
        command = [command stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [commands addObject:command];
    }
    return commands;
}

- (void)play
{
    NSArray *commands = [self parsePlayerCommand];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:commands[0] arguments:[commands objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, commands.count - 1)]]];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Now Playing...";
    notification.informativeText = [NSString stringWithFormat:@"%@ %@", self.name, self.detail];
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
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
            command = [self.plsURL absoluteString];
        }
        else if ([string isEqualToString:YPPlaceholderForStreamURL]) {
            command = [self.streamURL absoluteString];
        }
        else if ([string isEqualToString:YPPlaceholderForStreamURLMMS]) {
            command = [self.streamURLMMS absoluteString];
        }
        else if ([string isEqualToString:YPPlaceholderForStreamURLMMSH]) {
            command = [self.streamURLMMSH absoluteString];
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

#pragma mark -

- (void)recordInMPlayerX
{
    [self startRecievingInMPlayerX];
    NSString *playerCommand = [NSString stringWithFormat:@"/Applications/MPlayerX.app/Contents/Resources/binaries/x86_64/mplayer -dumpstream -dumpfile stream_video_name.wmv %@", [self.streamURLMMSH absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    [self executeRecordingCommand:commands];
}

- (void)recordInVLC
{
    [self startRecievingInMPlayerX];
    NSString *playerCommand = [NSString stringWithFormat:@"/Applications/VLC.app/Contents/MacOS/VLC %@ --sout=file/wmv:peercast_stream.wmv", [self.streamURLMMSH absoluteString]];
    NSArray *commands = [self commandArrayFromPlayerCommand:playerCommand];
    [self executeRecordingCommand:commands];
}

- (STPrivilegedTask *)executeRecordingCommand:(NSArray *)commands
{
    STPrivilegedTask *task = [STPrivilegedTask launchedPrivilegedTaskWithLaunchPath:commands[0] arguments:[commands objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, commands.count - 1)]]];
    return task;
}

@end
