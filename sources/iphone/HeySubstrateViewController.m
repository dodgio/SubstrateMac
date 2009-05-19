// =============================================================================
/*
  HeySubstrateViewController.m
  SubstrateiPhone Project

  View controller.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateViewController.h"
#import "HeySubstrateView.h"

@implementation HeySubstrateViewController


// -----------------------------------------------------------------------------
// MARK: Properties

@synthesize animationTimer;
- (void)setAnimationTimer:(NSTimer *)newTimer
{
  [animationTimer invalidate];
  animationTimer = newTimer;
}

@synthesize animationInterval;
- (void)setAnimationInterval:(NSTimeInterval)interval
{
  animationInterval = interval;
  if (animationTimer)
  {
    [self stopAnimation];
    [self startAnimation];
  }
}




// -----------------------------------------------------------------------------
// MARK: Init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
  {
    animationInterval = 1.0f / 60.0f;
  }
  return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
}
*/



- (void)viewDidLoad 
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];
  [self startAnimation];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
 {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning 
{
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
  
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: Animation Methods

- (void)startAnimation
{
  float width = [self.view bounds].size.width;
  float height = [self.view bounds].size.height;
  CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
  //bitContext = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, space, kCGImageAlphaLast);
  bitContext = CGBitmapContextCreate(NULL, width, height, 8, 0, space, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
  CGColorSpaceRelease(space);
  HeySubstrateView *v = (HeySubstrateView *)self.view;
  [v startAnimation];
  self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation
{
  self.animationTimer = nil;
  HeySubstrateView *v = (HeySubstrateView *)self.view;
  [v stopAnimation];
  CGContextRelease(bitContext);
  bitContext = NULL;
  CGImageRelease(bitImage);
  bitImage = NULL;
}


- (void)drawView
{
  HeySubstrateView *v = (HeySubstrateView *)self.view;
  //[v setNeedsDisplayInRect:CGRectNull];
  //[v setNeedsDisplayInRect:CGRectZero];
  //[v setNeedsDisplayInRect:CGRectMake(10.0f, 10.0f, 30.0f, 60.0f)];
  //[v setNeedsDisplay];
  //UIGraphicsBeginImageContext(v.bounds.size);
  //[v animateOneFrame];
  //UIGraphicsEndImageContext();
  
  UIGraphicsPushContext(bitContext);
  [v animateOneFrame];
  if (bitImage)
    CGImageRelease(bitImage);
  bitImage = CGBitmapContextCreateImage(bitContext);
  UIGraphicsPopContext();
  v->ourFuckingOffscreenBitmapImage = bitImage;
  [v setNeedsDisplay];
}








@end


// End of HeySubstrateViewController.m
// =============================================================================
