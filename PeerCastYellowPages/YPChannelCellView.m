//
//  YPChannelCellView.m
//  PeerCastYellowPages
//
//  Created by KCee.jp on 8/14/13.
//  Copyright (c) 2013 KCee.jp. All rights reserved.
//

#import "YPChannelCellView.h"

@interface YPChannelCellView ()

@property (nonatomic) NSTrackingRectTag trackingRect;

@end

@implementation YPChannelCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.overlayView.alphaValue = 0.f;
    
    self.favoriteButton.image = [self.favoriteButton.image hh_imageTintedWithColor:[NSColor grayColor]];
    self.browserButton.image = [self.browserButton.image hh_imageTintedWithColor:[NSColor grayColor]];
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    self.trackingRect = [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
}

- (void)setFrame:(NSRect)frame
{
    [super setFrame:frame];
    
    [self removeTrackingRect:self.trackingRect];
    self.trackingRect = [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [super mouseEntered:theEvent];
    
    self.overlayView.alphaValue = 1.f;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [super mouseExited:theEvent];
    
    self.overlayView.alphaValue = 0.f;
}

@end
