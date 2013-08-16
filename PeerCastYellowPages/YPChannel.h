#import "_YPChannel.h"

@interface YPChannel : _YPChannel {}
// Custom logic goes here.

- (NSString *)host;
- (NSURL *)plsURL;
- (NSURL *)streamURL;

- (void)play;
- (void)openContactURLInBrowser;
- (void)notifyNewChannel;

@property (nonatomic) NSURL *contactURL;
@property (nonatomic) NSURL *yellowPageURL;
@property (nonatomic, copy) NSString *yellowPageName;

@property (nonatomic) YPFavorite *favorite;
- (void)toggleFavorite;

@end
