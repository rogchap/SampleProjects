//
//  RCRootViewController.m
//  CustomUIViewAnimation
//
//  Created by Roger Chapman on 23/08/13.
//  Copyright (c) 2013 rogchap.com. All rights reserved.
//

#import "RCRootViewController.h"

@interface RCRootViewController ()

@end

@implementation RCRootViewController

- (IBAction)touchedArrow:(RCArrowControl *)sender {
    
    [CATransaction setAnimationDuration:1.0];
    sender.percentage = 0.75;
    
}
@end
