#import "YPChannel.h"
#import "GTMNSString+HTML.h"

static NSString * const YPPeerCastIPAddress = @"localhost";
static const int YPPeerCastPort = 7144;

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
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/pls/%@?tip=%@", YPPeerCastIPAddress, YPPeerCastPort, self.identifier, self.host]];
}

- (NSURL *)streamURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/stream/%@.%@", YPPeerCastIPAddress, YPPeerCastPort, self.identifier, [self.format lowercaseString]]];
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

#pragma mark -

- (void)play
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Now Playing...";
    notification.informativeText = [NSString stringWithFormat:@"%@ %@", self.name, self.detail];
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Flip Player.app", [self.plsURL absoluteString]]];
    [task launch];
    [task waitUntilExit];
}

- (void)openContactURLInBrowser
{
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[self.contactURLString]];
    [task launch];
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
}

- (BOOL)notify
{
    __block BOOL notify = NO;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"ウェブ" options:0 error:nil];
    id block = ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            notify = YES;
        }
    };
    [regex enumerateMatchesInString:self.name options:0 range:NSMakeRange(0, self.name.length) usingBlock:block];
    [regex enumerateMatchesInString:self.detail options:0 range:NSMakeRange(0, self.detail.length) usingBlock:block];
    
    NSLog(@"%@", self.name);
    return notify;
}

@end
