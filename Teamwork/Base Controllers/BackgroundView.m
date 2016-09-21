//
//  BackgroundView.m
//  pro
//
//  Created by Shashank Patel on 12/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "BackgroundView.h"
#import "UIColor+Teamwork.h"

@implementation BackgroundView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _amplitudeFactor = 10;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _amplitudeFactor = 10;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat halfHeight = width / 2;
//    CGFloat height = CGRectGetHeight(rect);
//    CGFloat halfWidth = height / 2;
    CGFloat frequency = 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    [[UIColor colorWithRed:0 green:192/255.0 blue:255/255.0 alpha:1] set];
    [[UIColor teamwork_DarkBlue] set];
    
    CGContextSetShadowWithColor(context, CGSizeMake(3, 3), 20.0, [[UIColor teamwork_DarkBlue] colorWithAlphaComponent:0.5].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGFloat padding = 0;
    CGContextMoveToPoint(context, padding, padding);
    CGContextSaveGState(context);
    
    const CGFloat amplitude = halfHeight / _amplitudeFactor;
    
    CGContextTranslateCTM(context, (0.25 * width), 0);
    for(CGFloat x = -(0.25 * width) + padding; x < width - padding - (0.25 * width); x += 0.5)
    {
        CGFloat y = amplitude * sinf(2 * M_PI * (x / width) * frequency) + halfHeight + 40;
        CGContextAddLineToPoint(context, x, y);
    }
    
    CGContextRestoreGState(context);
    CGContextAddLineToPoint(context, width - padding, padding);
    CGContextAddLineToPoint(context, padding, padding);
    
    CGContextFillPath(context);
}

@end
