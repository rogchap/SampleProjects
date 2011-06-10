//
//  ImageManipulationAppDelegate.h
//  ImageManipulation
//
//  Created by Roger Chapman on 10/06/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBoothController.h"

@interface ImageManipulationAppDelegate : NSObject <UIApplicationDelegate> {

  PhotoBoothController *_photoBooth;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
