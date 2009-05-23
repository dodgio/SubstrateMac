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
#import "HeySubstrateAppDelegate.h"


// -----------------------------------------------------------------------------
// MARK: HeySubstrateViewController

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
    animationInterval = 1.0f / HeySubstrateAnimationFPS;
  }
  return self;
}


- (void)dealloc 
{
  
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UIViewController Methods

- (void)viewDidLoad 
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];
  [self startAnimation];
}


- (void)didReceiveMemoryWarning 
{
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


// -----------------------------------------------------------------------------
// MARK: Animation Methods

- (void)startAnimation
{
  float width = [self.view bounds].size.width;
  float height = [self.view bounds].size.height;
  CGColorSpaceRef space;
  if (!bitContext)
  {
    space = CGColorSpaceCreateDeviceRGB();
    //bitContext = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, space, kCGImageAlphaLast);
    bitContext = CGBitmapContextCreate(NULL, width, height, 8, 0, space, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(space);
  }
  HeySubstrateView *v = (HeySubstrateView *)self.view;
  //HeySubstrateAppDelegate *del = ((HeySubstrateAppDelegate *)([UIApplication sharedApplication].delegate));
  //[v setOptions:[del options]];
//  [v startAnimation];
  [v restartAnimation];
  self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation
{
  self.animationTimer = nil;
  HeySubstrateView *v = (HeySubstrateView *)self.view;
  [v stopAnimation];
//  CGContextRelease(bitContext);
//  bitContext = NULL;
//  CGImageRelease(bitImage);
//  bitImage = NULL;
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

  
  // Tell the system to process user events.
  // TODO: move runloop time var to proper place
  // CFTimeInterval HeySubstrateRunLoopUserInterval = 0.009;
  //CFTimeInterval HeySubstrateRunLoopUserInterval = 0.009;
  //while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, HeySubstrateRunLoopUserInterval, FALSE) == kCFRunLoopRunHandledSource)
  //{
  //  // Nothing. We just want the run loop to do its thing.
  //}
  
  CFTimeInterval HeySubstrateRunLoopUserInterval = 0.001;
  SInt32 runLoopStatus;
  while (1)
  {
    runLoopStatus = CFRunLoopRunInMode(kCFRunLoopDefaultMode, HeySubstrateRunLoopUserInterval, TRUE);
    if (runLoopStatus != kCFRunLoopRunHandledSource)
      break;
  }
  
  [v setNeedsDisplay];
}


@end


// End of HeySubstrateViewController.m
// =============================================================================
