//
//  NumberInputAppDelegate.h
//  NumberInput
//
//  Created by Roger Chapman on 13/07/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberInputController.h"

@interface NumberInputAppDelegate : NSObject <UIApplicationDelegate> {
  NumberInputController *_mainController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
