//
//  RCArrowControl.m
//  CustomUIViewAnimation
//
//  Created by Roger Chapman on 23/08/13.
//  Copyright (c) 2013 rogchap.com. All rights reserved.
//

#import "RCArrowControl.h"

@implementation RCArrowControl


+(Class)layerClass {
    return [RCArrowControlLayer class];
}

-(void)setPercentage:(CGFloat)percentage {
    _percentage = percentage;
    ((RCArrowControlLayer*)self.layer).percentage = percentage;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        
        self.layer.needsDisplayOnBoundsChange = YES;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

@end
