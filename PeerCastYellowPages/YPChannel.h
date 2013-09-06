#import "_YPChannel.h"

@interface YPChannel : _YPChannel {}
// Custom logic goes here.

- (NSString *)host;
- (NSURL *)plsURL;
- (NSURL *)streamURL;
- (NSURL *)streamURLMMS;
- (NSURL *)streamURLMMSH;
- (NSURL *)yellowPageSiteURL;
- (NSURL *)yellowPageSiteURLForChannel;

- (void)play;
- (void)playInMPlayerX;
- (void)playInVLC;
- (void)playInFlipPlayer;

- (void)recordInMPlayerX;

- (void)openContactURLInBrowser;
- (void)openYellowPageURLInBrowser;
- (void)notifyNewChannel;

@property (nonatomic) NSURL *contactURL;
@property (nonatomic) NSURL *yellowPageURL;
@property (nonatomic, copy, readonly) NSString *yellowPageName;

@property (nonatomic, readonly) YPFavorite *favorite;
- (void)toggleFavorite;

@end
