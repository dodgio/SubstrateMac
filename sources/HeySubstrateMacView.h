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
*/
// =============================================================================
// HeySubstrateMacView.h

#include <math.h>
#include <Accelerate/Accelerate.h>
#import <ScreenSaver/ScreenSaver.h>


typedef struct 
{
  unsigned int redValue;
  unsigned int greenValue;
  unsigned int blueValue;
} HeySubstrateRGB;

typedef union
{
	uint32_t	u[4];
	float		  f[4];
	vFloat		v;
} vectF_t;


// -----------------------------------------------------------------------------
@interface HeySubstrateMacView : ScreenSaverView 
{
  IBOutlet id optionSheet;                // Option configuration sheet and
  IBOutlet id numberOfCracksSlider;       //  self-explanatory control outlets
  IBOutlet id speedOfCrackingSlider;      
  IBOutlet id amountOfSandSlider;          
  IBOutlet id densityOfDrawingSlider;     
  IBOutlet id pauseBetweenDrawingsSlider; 
  IBOutlet id drawCracksOnlyOption;  
  IBOutlet id percentCurvedSlider;
  
  float optionNumberOfCracks;
  float optionSpeedOfCracking;
  float optionAmountOfSand;
  float optionDensityOfDrawing;
  float optionPauseBetweenDrawings;
  BOOL  optionDrawCracksOnly;
  int optionPercentCurves;
  
  NSMutableArray *crackArray; // Array of Cracks
  int currNumCracks;          // Current number of Cracks in crackArray
  int maxNumCracks;           // Maximum number of Cracks allowed in crackArray
  BOOL bgCleared;             // Flag, has view background been cleared?
  int iterationsDone;         // Counter for crack-drawing iterations
  BOOL drawingPaused;         // Are we currently paused between drawings?
  int framesToPause;          // How many animation frames to pause
  int framesPaused;           // Counter for pause between drawings
  
  int viewWidth;              // Dimensions of view
  int viewHeight;             // Dimensions of view
  int *crackAngleGrid;        // Array/Grid of cracks, one per pixel
}

// User Interface
- (IBAction)okClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

// Inherited from ScreenSaverView
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview;
- (void) dealloc;
- (void)startAnimation;
- (void)stopAnimation;
- (void)drawRect:(NSRect)rect;
- (void)animateOneFrame;
- (BOOL)isOpaque;
- (BOOL)hasConfigureSheet;
- (NSWindow*)configureSheet;

// HeySubstrateMacView
- (void)makeACrack;
- (void)restartAnimation;
- (void)setupAnimation;
- (int)optionPercentCurves;
- (float)optionAmountOfSand;
- (BOOL)optionDrawCracksOnly;
- (int)viewWidth;
- (int)viewHeight;
- (int *)crackAngleGrid;

@end


// =============================================================================


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
  HeySubstrateMacView *saverView; // Pointer to view  
  float sandGain;             // Random factor to modulate number of sand grains
  NSColor *baseSandColor;     // Base color of the sand
  float cosAnglePi180;        // Save cosine results
  float sinAnglePi180;        // Save sine results
  vectF_t *vFSource;          // Vector sin() source (paintToX:Y:FromCrackX:Y)
  vectF_t *vFDest;            // Vector sin() dest ...
}

- (id)initWithSSView:(HeySubstrateMacView *)view;
- (void) dealloc;
- (void)findStartPointAndTravelAngle;
- (void)move;
- (void)regionColor;
- (void)paintToX:(float)xEnd Y:(float)yEnd 
          FromCrackX:(float)crackPosX CrackY:(float)crackPosY;
- (void)setupSand;
- (HeySubstrateRGB const *)randomSubstrateRGB;

@end


// End of HeySubstrateMacView.h
// =============================================================================
