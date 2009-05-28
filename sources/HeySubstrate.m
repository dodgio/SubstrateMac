// =============================================================================
/*
    SubstrateMac

    Screensaver ported to Mac OS X by Warren Dodge of Hey Daddio!
    <http://www.heydaddio.com/>

    Original concept and code by
    Substrate Watercolor by J. Tarbell, June 2004, Albuquerque New Mexico
    Processing 0085 Beta syntax update, April 2005
    <http://complexification.net/>

    Curved crack drawing adapted from xscreensaver version by David Agraz Jan 2005
    The following license applies to the curved crack drawing code:
    xscreensaver, Copyright (c) 1997, 1998, 2002 Jamie Zawinski <jwz@jwz.org>
    Permission to use, copy, modify, distribute, and sell this software 
    and its documentation for any purpose is hereby granted without fee, 
    provided that the above copyright notice appear in all copies and 
    that both that copyright notice and this permission notice appear 
    in supporting documentation. No representations are made about the 
    suitability of this software for any purpose.  It is provided "as is" 
    without express or implied warranty.


    HeySubstrate.m
    SubstrateMac/SubstrateiPhone Projects

    Project globals.

    Copyright (c) Hey Daddio! 2009.
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
const float HeySubstrateAnimationFPS = 30.0f;    // Frames per second to animate


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
