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
@property (nonatomic) BOOL wasAcceptingMouseEvents;

@end

@implementation YPChannelCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.playButton.alphaValue = 0.f;
    /*
    self.favoriteButton.image = [self.favoriteButton.image hh_imageTintedWithColor:[NSColor grayColor]];
    self.browserButton.image = [self.browserButton.image hh_imageTintedWithColor:[NSColor grayColor]];
    */
}

- (void)setFrame:(NSRect)frame
{
    [super setFrame:frame];
    
    [self removeTrackingRect:self.trackingRect];
    self.trackingRect = [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
}

- (void)setBounds:(NSRect)bounds
{
    [super setBounds:bounds];
    
    [self removeTrackingRect:self.trackingRect];
    self.trackingRect = [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    self.trackingRect = [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    if ([self window] && self.trackingRect) {
        [self removeTrackingRect:self.trackingRect];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [super mouseEntered:theEvent];
    
    self.wasAcceptingMouseEvents = [self.window acceptsMouseMovedEvents];
    [self.window setAcceptsMouseMovedEvents:YES];
    
    [self.window makeFirstResponder:self];
    self.playButton.alphaValue = 1.f;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [super mouseExited:theEvent];
    [self.window setAcceptsMouseMovedEvents:self.wasAcceptingMouseEvents];
    
    self.playButton.alphaValue = 0.f;
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
}

@end
