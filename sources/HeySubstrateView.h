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


    HeySubstrateView.h
    SubstrateMac/SubstrateiPhone Projects

    View for fancy drawing.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"
#if TARGET_OS_IPHONE
 #import "HeySubstrateAppDelegate.h"
#endif


// -----------------------------------------------------------------------------
// MARK: HeySubstrateView
#if TARGET_OS_IPHONE
@interface HeySubstrateView : UIView 
#else
@interface HeySubstrateView : ScreenSaverView 
#endif
{
  @private
    IBOutlet id optionSheet;                // Option configuration sheet and
    IBOutlet id numberOfCracksSlider;       //  self-explanatory control outlets
    IBOutlet id speedOfCrackingSlider;      
    IBOutlet id amountOfSandSlider;          
    IBOutlet id densityOfDrawingSlider;     
    IBOutlet id pauseBetweenDrawingsSlider; 
    IBOutlet id drawCracksOnlyOption;  
    IBOutlet id percentCurvedSlider;
    
    HeySubstrateOptions opts;
    
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
    
    
#if TARGET_OS_IPHONE
    HeySubstrateFadeState infoFadeState;  
    NSInteger infoFadeCountdown;
    CGRect infoRect;            // Rect of info icon/button
    UIImage *infoIcon;          // Info icon/button.
  @public
    CGImageRef offscreenBitmapImage;
#endif
}

#if TARGET_OS_IPHONE
- (id)initWithFrame:(CGRect)frame;
#else
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview;
- (BOOL)hasConfigureSheet;
- (NSWindow*)configureSheet;
- (IBAction)okClick:(id)sender;
- (IBAction)cancelClick:(id)sender;
#endif
- (void)dealloc;
- (void)startAnimation;
- (void)stopAnimation;
- (void)drawRect:(HEYRECT)rect;
- (void)animateOneFrame;
- (BOOL)isOpaque;

- (void)makeACrack;
- (void)restartAnimation;
- (void)setupAnimation;
- (int)optionPercentCurves;
- (float)optionAmountOfSand;
- (BOOL)optionDrawCracksOnly;
- (int)viewWidth;
- (int)viewHeight;
- (int *)crackAngleGrid;
- (void)getOptions:(HeySubstrateOptions *)options;
- (void)setOptions:(HeySubstrateOptions *)options;
- (void)writeOptions;


@end


// End of HeySubstrateView.h
// =============================================================================
