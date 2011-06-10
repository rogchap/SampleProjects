//
//  PhotoBoothController.h
//  ImageManipulation
//
//  Created by Roger Chapman on 10/06/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PhotoBoothController : UIViewController<UIGestureRecognizerDelegate> {
  
  CGFloat _lastScale;
	CGFloat _lastRotation;  
	CGFloat _firstX;
	CGFloat _firstY;
  
  UIImageView *photoImage;
  UIView *canvas;
  
  CAShapeLayer *_marque;
}

@property (nonatomic, retain) IBOutlet UIView *canvas;
@property (nonatomic, retain) IBOutlet UIImageView *photoImage;

@end
