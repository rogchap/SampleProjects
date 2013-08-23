//
//  RCArrowControlLayer.m
//  CustomUIViewAnimation
//
//  Created by Roger Chapman on 23/08/13.
//  Copyright (c) 2013 rogchap.com. All rights reserved.
//

#import "RCArrowControlLayer.h"

@implementation RCArrowControlLayer

@dynamic percentage;

+(BOOL)needsDisplayForKey:(NSString*)key {
    if ([key isEqualToString:@"percentage"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

-(CABasicAnimation *)makeAnimationForKey:(NSString *)key {
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
	anim.fromValue = [[self presentationLayer] valueForKey:key];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	anim.duration = [CATransaction animationDuration];
    
	return anim;
}

-(id<CAAction>)actionForKey:(NSString *)event {
	if ([event isEqualToString:@"percentage"]) {
		return [self makeAnimationForKey:event];
	} else {
        return [super actionForKey:event];
    }
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.271 green: 0.302 blue: 0.714 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.208 green: 0.231 blue: 0.542 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow = color;
    CGSize shadowOffset = CGSizeMake(2.1, 2.1);
    CGFloat shadowBlurRadius = 5;
    
    //// Frames
    CGRect frame = self.bounds;
    
    //// Subframes
    CGRect innerFrame = CGRectMake((CGRectGetMinX(frame) + 228) * self.percentage, CGRectGetMinY(frame), 59, 51);
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(innerFrame) + 20.5, CGRectGetMinY(innerFrame) + 29.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 134.5, CGRectGetMinY(frame) + 200.5) controlPoint1: CGPointMake(CGRectGetMinX(innerFrame) + 20.5, CGRectGetMinY(innerFrame) + 62.75) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 134.5, CGRectGetMinY(frame) + 160.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 154.5, CGRectGetMinY(frame) + 200.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(innerFrame) + 40.5, CGRectGetMinY(innerFrame) + 29.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 154.62, CGRectGetMinY(frame) + 159.88) controlPoint2: CGPointMake(CGRectGetMinX(innerFrame) + 40.5, CGRectGetMinY(innerFrame) + 63.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(innerFrame) + 51, CGRectGetMinY(innerFrame) + 29.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(innerFrame) + 30.11, CGRectGetMinY(innerFrame) + 8.61)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(innerFrame) + 9.24, CGRectGetMinY(innerFrame) + 29.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(innerFrame) + 20.5, CGRectGetMinY(innerFrame) + 29.5)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [fillColor setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    [strokeColor setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    

    
    
    UIGraphicsPopContext();
}

@end
