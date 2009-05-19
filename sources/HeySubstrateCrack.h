// =============================================================================
/*
 HeySubstrateCrack.h
 SubstrateMac/SubstrateiPhone Projects
 
 "Crack" drawing abstraction class.
 
 Copyright (c) Hey Daddio! 2009. All rights reserved.
 */
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"

@class HeySubstrateView;


@interface HeySubstrateCrack : NSObject 
{
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
