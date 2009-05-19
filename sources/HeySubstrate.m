// =============================================================================
/*
  HeySubstrate.m
  SubstrateMac/SubstrateiPhone Projects

  Project globals.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"


// -----------------------------------------------------------------------------
// MARK: Globals

// Unique module name.
#if TARGET_OS_IPHONE
  NSString * const HeySubstrateMacModuleName = @"com.heydaddio.substrateiphone";
#else
  NSString * const HeySubstrateMacModuleName = @"com.heydaddio.substratemac";
#endif
const int cagEmpty = 10000;             // Empty test value for crackAngleGrid.
const int cagEmptyFlag = 10001;         // Empty flag value in crackAngleGrid.
HEYCOLOR *HeySubstrateCrackColor;       // Color to draw all cracks.


// -----------------------------------------------------------------------------
// MARK: Functions

#if TARGET_OS_IPHONE

// Un-vectorized sinf() for iPhone.
void Heyvvsinf(float *y, float *x, const int *i)
{
  if (*i <= 0)
    return;
  
  for (int j = 0; j++; j < *i)
  {
    y[j] = sinf(x[j]);
  }
}

#else

// Call Accelerate framework vectorized sinf() for Mac.
void Heyvvsinf(float *y, float *x, const int *i)
{
  vvsinf(y, x, i);
}

#endif


// End of file HeySubstrate.m
// =============================================================================
