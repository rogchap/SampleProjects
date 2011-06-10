//
//  PhotoBoothController.m
//  ImageManipulation
//
//  Created by Roger Chapman on 10/06/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import "PhotoBoothController.h"


@implementation PhotoBoothController
@synthesize canvas;
@synthesize photoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
  [photoImage release];
  [canvas release];
  [_marque release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private Methods

-(void)showOverlayWithFrame:(CGRect)frame {
  
  if (![_marque actionForKey:@"linePhase"]) {
    CABasicAnimation *dashAnimation;
    dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
    [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
    [dashAnimation setDuration:0.5f];
    [dashAnimation setRepeatCount:HUGE_VALF];
    [_marque addAnimation:dashAnimation forKey:@"linePhase"];
  }
  
  _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
  _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
  
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, frame);
  [_marque setPath:path];
  CGPathRelease(path);
  
  _marque.hidden = NO;
  
}

-(void)scale:(id)sender {
      
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
      _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [photoImage setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    [self showOverlayWithFrame:photoImage.frame];
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
      
      _lastRotation = 0.0;
      return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [photoImage setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    [self showOverlayWithFrame:photoImage.frame];
}


-(void)move:(id)sender {
    
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
    _firstX = [photoImage center].x;
    _firstY = [photoImage center].y;
  }
    
  translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
  [photoImage setCenter:translatedPoint];
  [self showOverlayWithFrame:photoImage.frame];
}

-(void)tapped:(id)sender {
  _marque.hidden = YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (!_marque) {
    _marque = [[CAShapeLayer layer] retain];
    _marque.fillColor = [[UIColor clearColor] CGColor];
    _marque.strokeColor = [[UIColor grayColor] CGColor];
    _marque.lineWidth = 1.0f;
    _marque.lineJoin = kCALineJoinRound;
    _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
    _marque.bounds = CGRectMake(photoImage.frame.origin.x, photoImage.frame.origin.y, 0, 0);
    _marque.position = CGPointMake(photoImage.frame.origin.x + canvas.frame.origin.x, photoImage.frame.origin.y + canvas.frame.origin.y);
  }
  [[self.view layer] addSublayer:_marque];
    
  UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
  [pinchRecognizer setDelegate:self];
  [self.view addGestureRecognizer:pinchRecognizer];
  
  UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
  [rotationRecognizer setDelegate:self];
  [self.view addGestureRecognizer:rotationRecognizer];
  
  UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
  [panRecognizer setMinimumNumberOfTouches:1];
  [panRecognizer setMaximumNumberOfTouches:1];
  [panRecognizer setDelegate:self];
  [canvas addGestureRecognizer:panRecognizer];
  
  UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
  [tapProfileImageRecognizer setNumberOfTapsRequired:1];
  [tapProfileImageRecognizer setDelegate:self];
  [canvas addGestureRecognizer:tapProfileImageRecognizer];
  
}

- (void)viewDidUnload
{
  [self setPhotoImage:nil];
  [self setCanvas:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

@end
