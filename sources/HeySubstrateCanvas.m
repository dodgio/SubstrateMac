// =============================================================================
/*
  HeySubstrateCanvas.h
  SubstrateMac/SubstrateiPhone Projects

  Canvas drawing abstraction class.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateCanvas.h"
#import "HeySubstrateCrack.h"


// -----------------------------------------------------------------------------
// MARK: Constants







// -----------------------------------------------------------------------------
// MARK: Private Category Interface

@interface HeySubstrateCanvas : (Private)

@end


// -----------------------------------------------------------------------------
// MARK: Private Category Implementation

@implementation HeySubstrateCanvas (Private)



@end


// -----------------------------------------------------------------------------
// MARK: HeySubstrateCanvas

@implementation HeySubstrateCanvas







// Designated initializer.
- (id)initWithFrame:(CGRect)frame options:(HeySubstrateOptions *)options
{
  if ((self = [super init]))
  {
    size = frame.size;
    if (options)
    {
      opts.numberOfCracks = options->numberOfCracks;
      opts.speedOfCracking = options->speedOfCracking;
      opts.amountOfSand = options->amountOfSand;
      opts.densityOfDrawing = options->densityOfDrawing;
      opts.pauseBetweenDrawings = options->pauseBetweenDrawings;
      opts.drawCracksOnly = options->drawCracksOnly;
      opts.percentCurves = options->percentCurves;
    }
    else
    {
      [super dealloc];
      self = nil;
    }
  }
  return self;
}


- (void)dealloc
{
  free(crackAngleGrid);
  crackAngleGrid = NULL;
  [crackArray release];
  crackArray = nil;
  [super dealloc];
}












@end
