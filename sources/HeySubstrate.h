// =============================================================================
/*
  HeySubstrate.h
  SubstrateMac/SubstrateiPhone Projects

  Project header

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// MARK: System Headers

//#import <stdlib.h>                          // For srandom(), random()
//#import <unistd.h>                          // For getpid()
//#import <time.h>                            // For time()
//#import <math.h>                            // sin(), etc.
#if TARGET_OS_IPHONE
  #import <Foundation/Foundation.h>         // Apple basics
  #import <UIKit/UIKit.h>                   // Cocoa Touch
#else
  #import <Cocoa/Cocoa.h>                   // Cocoa
  #import <ScreenSaver/ScreenSaver.h>       // Apple's ScreenSaver library
  #import <Accelerate/Accelerate.h>         // Vectorized sin(), etc.
#endif


// -----------------------------------------------------------------------------
// MARK: Platform-Specific Types

#if TARGET_OS_IPHONE
  typedef UIColor HEYCOLOR;
  typedef UIView HEYVIEW;
  typedef float vFloat;
#else
  typedef NSColor HEYCOLOR;
  typedef NSView HEYVIEW;
#endif


// -----------------------------------------------------------------------------
// MARK: Project Types

typedef struct 
{
  unsigned int redValue;
  unsigned int greenValue;
  unsigned int blueValue;
} HeySubstrateRGB;

typedef union
{
  uint32_t u[4];
  float f[4];
  vFloat v;
} HeyVectF_t;

typedef struct
{
  float numberOfCracks;
  float speedOfCracking;
  float amountOfSand;
  float densityOfDrawing;
  float pauseBetweenDrawings;
  float percentCurves;
  BOOL  drawCracksOnly;
} HeySubstrateOptions;


// -----------------------------------------------------------------------------
// MARK: Platform-Specific Project Headers

#if TARGET_OS_IPHONE
  #import "UIColor-HeyUIColor.h"            // Spiffy UIColor category.
#else
  #import "NSColor-HeyNSColor.h"
#endif


// -----------------------------------------------------------------------------
// MARK: Globals

extern NSString * const HeySubstrateMacModuleName;
extern HEYCOLOR *HeySubstrateCrackColor;                 // Color to draw _all_ cracks
extern const int cagEmpty;          // Empty test value for crackAngleGrid
extern const int cagEmptyFlag;      // Empty flag value in crackAngleGrid
extern const float HeySubstrateAnimationFPS;    // Frames per second to animate


// -----------------------------------------------------------------------------
// MARK: Functions

// Replacement for vecLib function.
void Heyvvsinf(float *y, float *x, const int *i);


// End of file HeySubstrate.h
// =============================================================================
