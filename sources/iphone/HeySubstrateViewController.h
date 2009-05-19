// =============================================================================
/*
  HeySubstrateViewController.h
  SubstrateiPhone Project

  View controller.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------


#import "HeySubstrate.h"


@interface HeySubstrateViewController : UIViewController 
{
 @private
  NSTimer *animationTimer;
  NSTimeInterval animationInterval;
  CGContextRef bitContext;
  CGImageRef bitImage;
}

@property (nonatomic, assign) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationInterval;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end

// End of HeySubstrateViewController.h
// =============================================================================
