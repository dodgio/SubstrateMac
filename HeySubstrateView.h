// ===========================================================================
/*
    SubstrateMac
 
    Screensaver ported to Mac OS X from 
    Substrate Watercolor by J. Tarbell, June 2004, Albuquerque New Mexico
      Processing 0085 Beta syntax update, April 2005
    http://complexification.net
 
    Color palette ported from xscreensaver version by dragorn Oct 10 2004
      dragorn@kismetwireless.net
 
    Port made by Warren Dodge of Hey Daddio! March 2006
 
 !!!!!!!!!!!!!!!!!!! license !!!!!!!!!
*/
// ===========================================================================
// HeySubstrateView.h

#import <ScreenSaver/ScreenSaver.h>
#include <math.h>

typedef struct {
  unsigned int redValue;
  unsigned int greenValue;
  unsigned int blueValue;
} HeySubstrateRGB;


// ---------------------------------------------------------------------------
@interface HeySubstrateView : ScreenSaverView 
{
  IBOutlet id optionSheet;    // Option configuration sheet
  
  int num;                    // Counter for ??? Index into Cracks array
  int maxnum;                 // Maximum number of Cracks
  NSMutableArray *cracks;     // Grid??? array??? of Cracks ???
  BOOL bgCleared;             // Flag for clearing background
}
- (IBAction)cancelClick:(id)sender;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview;
- (void)makeCrack;
- (void)startAnimation;
- (void)stopAnimation;
- (void)drawRect:(NSRect)rect;
- (void)animateOneFrame;
- (BOOL)hasConfigureSheet;
- (NSWindow*)configureSheet;
@end

// ---------------------------------------------------------------------------
@interface SandPainter : NSObject 
{
  subRGB *c;
  float g;
  NSColor *baseSandColor;     // Base color of the sand
}
- (subRGB *)somecolor;
- (void)renderRX:(float)x RY:(float)y X:(float)ox Y:(float)oy;
@end

// ---------------------------------------------------------------------------
@interface Crack : NSObject 
{
  float x;                    // Current x position of crack
  float y;                    // "       y                 "
  float t;                    // Direction of travel in degrees
  SubstrateView *ssView;      // Pointer to view  
  SandPainter *sp;            // Our sand painter
}
- (id)initWithSSView:(SubstrateView *)view;
- (void)findStart;
- (void)startCrackX:(int)intX Y:(int)intY T:(int)intT;
- (void)move;
- (void)regionColor;
@end


// End of SubstrateView.h
// ===========================================================================
