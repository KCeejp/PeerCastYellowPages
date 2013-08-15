#import "YPYellowPage.h"


@interface YPYellowPage ()

// Private interface goes here.

@end


@implementation YPYellowPage

// Custom logic goes here.

- (void)setIndexDotTxtURL:(NSURL *)indexDotTxtURL
{
    self.indexDotTxtURLString = [indexDotTxtURL absoluteString];
}

- (NSURL *)indexDotTxtURL
{
    return [NSURL URLWithString:self.indexDotTxtURLString];
}

@end
