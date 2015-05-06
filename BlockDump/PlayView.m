//
//  PlayView.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    CGFloat w = CGRectGetWidth(bounds);
    CGFloat h = CGRectGetHeight(bounds);
    
    //draw the grid
    w -= 50.0f;
    h -= 100.0f;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 50, 150);
    CGContextAddLineToPoint(context, 50, h);
    CGContextMoveToPoint(context, w, 150);
    CGContextAddLineToPoint(context, 50, 150);
    CGContextMoveToPoint(context, w, h);
    CGContextAddLineToPoint(context, 50, h);
    CGContextMoveToPoint(context, w, 150);
    CGContextAddLineToPoint(context, w, h);
    [[UIColor grayColor] setStroke];             // use gray as stroke color
    CGContextDrawPath( context, kCGPathStroke );
    
    
}



@end
