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


    HeySubstrateCrack.h
    SubstrateMac/SubstrateiPhone Projects

    "Crack" drawing abstraction class.

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"

@class HeySubstrateView;


@interface HeySubstrateCrack : NSObject 
{
@private
    float posX;                 // Current X position of crack
    float posY;                 // "       Y                 "
    float angleOfTravel;        // Direction of travel in degrees
    BOOL curved;                // Is crack curved
    float degrees_drawn;        // How many degrees has crack rotated (grown) thru
    float xs;                   // ??? curve
    float ys;                   // ??? curve
    float t_inc;                // ??? curve
    HeySubstrateView *saverView; // Pointer to view  
    float sandGain;             // Random factor to modulate number of sand grains
    //NSColor *baseSandColor;     // Base color of the sand
    UIColor *baseSandColor;     // Base color of the sand
    float cosAnglePi180;        // Save cosine results
    float sinAnglePi180;        // Save sine results
    HeyVectF_t *vFSource;          // Vector sin() source (paintToX:Y:FromCrackX:Y)
    HeyVectF_t *vFDest;            // Vector sin() dest ...
}

- (id)initWithSSView:(HeySubstrateView *)view;
- (void)dealloc;
- (void)findStartPointAndTravelAngle;
- (void)move;
- (void)regionColor;
- (void)paintToX:(float)xEnd Y:(float)yEnd FromCrackX:(float)crackPosX CrackY:(float)crackPosY;
- (void)setupSand;
- (HeySubstrateRGB const *)randomSubstrateRGB;

@end


// End of HeySubstrateCrack.h
// =============================================================================
