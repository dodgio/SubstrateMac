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


    HeySubstrate.h
    SubstrateMac/SubstrateiPhone Projects

    Project header

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// MARK: System Headers

#if TARGET_OS_IPHONE
 #import <Foundation/Foundation.h>         // Apple basics
 #import <UIKit/UIKit.h>                   // Cocoa Touch
 #import <QuartzCore/QuartzCore.h>         // Animations
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

typedef enum 
{
    kHeySubstrateFadeOff,
    kHeySubstrateFadeIn,
    kHeySubstrateFadeOn,
    kHeySubstrateFadeOut
} HeySubstrateFadeState;

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
