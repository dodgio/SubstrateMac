// =============================================================================
/*
  HeySubstrateView.m
  SubstrateMac/SubstrateiPhone Projects

  View for fancy drawing.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------



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

#import "HeySubstrateView.h"
#import "HeySubstrateCrack.h"


// -----------------------------------------------------------------------------
// MARK: Constants
static NSString * const defaultsKeyNumberOfCracks = @"NumberOfCracks";
static NSString * const defaultsKeySpeedOfCracking = @"SpeedOfCracking";
static NSString * const defaultsKeyAmountOfSand = @"AmountOfSand";
static NSString * const defaultsKeyDensityOfDrawing = @"DensityOfDrawing";
static NSString * const defaultsKeyPauseBetweenDrawings = @"PauseBetweenDrawings";
static NSString * const defaultsKeyDrawCracksOnly = @"DrawCracksOnly";
static NSString * const defaultsKeyPercentageOfCurvedCracks = @"PercentageOfCurvedCracks";
static NSString * const optionSheetNibName = @"SubstrateMacOptions";
static const float animationFPS = 60.0f;    // Frames per second to animate


// -----------------------------------------------------------------------------
// MARK: Private Category Interface

@interface HeySubstrateView (Private)

- (void)internalInitializer;

@end


// -----------------------------------------------------------------------------
// MARK: Private Category Implementation

@implementation HeySubstrateView (Private)

- (void)internalInitializer
{
  //ScreenSaverDefaults *defaults;
  NSUserDefaults *defaults;
  //defaults = [ScreenSaverDefaults defaultsForModuleWithName:SubstrateMacModuleName];
  defaults = [NSUserDefaults standardUserDefaults];
  [defaults registerDefaults:
    [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithFloat:11.0f],      defaultsKeyNumberOfCracks,
      [NSNumber numberWithFloat:1.0f],       defaultsKeySpeedOfCracking,
      [NSNumber numberWithFloat:-0.05f],     defaultsKeyAmountOfSand,
      [NSNumber numberWithFloat:100000.0f],  defaultsKeyDensityOfDrawing,
      [NSNumber numberWithFloat:15.0f],      defaultsKeyPauseBetweenDrawings,
      @"NO",                                 defaultsKeyDrawCracksOnly,
      [NSNumber numberWithFloat:15.0f],      defaultsKeyPercentageOfCurvedCracks,
      nil]];
  
  optionNumberOfCracks        = [defaults floatForKey:defaultsKeyNumberOfCracks];
  optionSpeedOfCracking       = [defaults floatForKey:defaultsKeySpeedOfCracking];
  optionAmountOfSand          = [defaults floatForKey:defaultsKeyAmountOfSand];
  optionDensityOfDrawing      = [defaults floatForKey:defaultsKeyDensityOfDrawing];
  optionPauseBetweenDrawings  = [defaults floatForKey:defaultsKeyPauseBetweenDrawings];
  optionDrawCracksOnly        = [defaults boolForKey: defaultsKeyDrawCracksOnly];
  optionPercentCurves         = [defaults floatForKey:defaultsKeyPercentageOfCurvedCracks];
  
  [self setAnimationTimeInterval:1 / animationFPS];
  
  //viewWidth = frame.size.width;
  //viewHeight = frame.size.height;
  viewWidth = [self frame].size.width;
  viewHeight = [self frame].size.height;
  maxNumCracks = 100;
  iterationsDone = 0;
  drawingPaused = NO;
  framesPaused = 0;
  
  // crackAngleGrid contains the (single, latest) angle of travel of any 
  //  cracks that pass through the corresponding pixel.
  crackAngleGrid = (int*)malloc(sizeof(int) * viewWidth * viewHeight);
  crackArray = [NSMutableArray arrayWithCapacity:maxNumCracks];
  [crackArray retain];
  // TODO: handle memory error here!
  
  if (!HeySubstrateCrackColor)
    //crackColor = [NSColor colorWithDeviceRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    HeySubstrateCrackColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
  [HeySubstrateCrackColor retain];
}


@end


// =============================================================================


// -----------------------------------------------------------------------------
// MARK: HeySubstrateMacView

@implementation HeySubstrateView


// -----------------------------------------------------------------------------
// MARK: Init and dealloc

// Designated initializer.
#if TARGET_OS_IPHONE
- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
    [self internalInitializer];
  return self;
}
#else
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
  if ((self = [super initWithFrame:frame isPreview:isPreview]))
    [self internalInitializer];
  return self;
}
#endif


// NSCoding initializer
- (id)initWithCoder:(NSCoder *)coder
{
  if ((self = [super initWithCoder:coder]))
    [self internalInitializer];
  return self;
}


// Destroy the view.
- (void) dealloc 
{
  [HeySubstrateCrackColor release];
  [crackArray release], crackArray = nil;
  free(crackAngleGrid), crackAngleGrid = NULL;
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: Drawing and animation methods

- (void)makeACrack 
{
  if (currNumCracks < optionNumberOfCracks ) 
  {
    // make a new crack instance
    HeySubstrateCrack *newCrack;
    newCrack = [[HeySubstrateCrack alloc] initWithSSView:self];
    [crackArray insertObject:newCrack atIndex:currNumCracks++];
    [newCrack release];
  }
}


- (void)startAnimation 
{
  //[super startAnimation];
  [self setupAnimation];
  return;
}


- (void)stopAnimation 
{
  //[super stopAnimation];
}


- (void)restartAnimation 
{
  [crackArray removeAllObjects];
  bgCleared = NO;
  [self setupAnimation];
}


- (void)setupAnimation 
{
  // Erase crackAngleGrid
  int x, y;
  for (y = 0; y < viewHeight; y++) 
  {
    for (x = 0; x < viewWidth; x++) 
    {
      crackAngleGrid[y * viewWidth + x] = cagEmptyFlag;     
    }
  }
  
  // Make random crack seeds
  int i, k;
  srandom(time(0));
  for (k = 0; k < 16; k++) 
  {
    i = random() % (viewWidth * viewHeight);
    crackAngleGrid[i] = random() % 360;
  }
  
  // Make just three cracks to start with
  int c;
  currNumCracks = 0;
  for (c = 0; c < 3; c++) 
  {
    [self makeACrack];
  }
  return;
}


- (void)setAnimationTimeInterval:(NSTimeInterval)timeInterval
{
  // TODO: finish function
}


//- (void)drawRect:(NSRect)rect 
- (void)drawRect:(CGRect)rect 
{
#if TARGET_OS_IPHONE
  //[self animateOneFrame];
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextDrawImage(ctx, self.bounds, ourFuckingOffscreenBitmapImage);
#else
  [super drawRect:rect];
#endif
}


- (void)animateOneFrame 
{
  // Clear background
  if (bgCleared == NO) 
  {
    //[[NSColor whiteColor] set];
    // Warm up the canvas a bit: RGB:255/251/239
    //[[NSColor colorWithDeviceRed:1.0f green:0.9843f blue:0.9373f alpha:1.0f] set];
    [[UIColor colorWithRed:1.0f green:0.9843f blue:0.9373f alpha:1.0f] set];
    //[NSBezierPath fillRect:[self frame]];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, CGRectMake([self frame].origin.x, [self frame].origin.y, [self frame].size.width, [self frame].size.height));
    bgCleared = YES;
  }
  
  int i;
  int spdLoops;

  if (drawingPaused) 
  {
    if (framesPaused++ >= framesToPause) 
    {
      drawingPaused = NO;
      framesPaused = 0;
      iterationsDone = 0;
      [self restartAnimation];
    }
  } 
  else 
  {
    // crack all cracks
    for (spdLoops = (int)optionSpeedOfCracking; spdLoops > 0; spdLoops--) 
    {
      for (i = 0; i < currNumCracks; i++) 
      {
        iterationsDone++;
        [[crackArray objectAtIndex:i] move];
      }
      if (iterationsDone >= optionDensityOfDrawing) 
      {
        drawingPaused = YES;
        framesPaused = 0;
        iterationsDone = 0;
        framesToPause = (int)optionPauseBetweenDrawings * animationFPS;
      }
    }
  }
  return;
}


- (BOOL)isOpaque 
{
  return YES;
}


- (BOOL)hasConfigureSheet 
{
  return YES;
}


// Set up the option sheet.
//- (NSWindow*)configureSheet 
- (UIView*)configureSheet 
{
  //ScreenSaverDefaults *defaults;
  NSUserDefaults *defaults;
  //defaults = [ScreenSaverDefaults defaultsForModuleWithName:SubstrateMacModuleName];
  defaults = [NSUserDefaults standardUserDefaults];
  
  if (!optionSheet) 
  {
    //if (![NSBundle loadNibNamed:optionSheetNibName owner:self]) 
    if (![[NSBundle mainBundle] loadNibNamed:optionSheetNibName owner:self options:nil]) 
    {
      NSLog(@"Unable to load options configuration sheet.");
      //NSBeep();
    }
  }
  //[numberOfCracksSlider       setFloatValue:[defaults floatForKey:defaultsKeyNumberOfCracks]];
  [numberOfCracksSlider setValue:[defaults floatForKey:defaultsKeyNumberOfCracks] animated:NO];
  
  //[speedOfCrackingSlider      setFloatValue:[defaults floatForKey:defaultsKeySpeedOfCracking]];
  [speedOfCrackingSlider setValue:[defaults floatForKey:defaultsKeySpeedOfCracking] animated:NO];
  //[amountOfSandSlider         setFloatValue:[defaults floatForKey:defaultsKeyAmountOfSand]];
  [amountOfSandSlider setValue:[defaults floatForKey:defaultsKeyAmountOfSand] animated:NO];
  //[densityOfDrawingSlider     setFloatValue:[defaults floatForKey:defaultsKeyDensityOfDrawing]];
  [densityOfDrawingSlider setValue:[defaults floatForKey:defaultsKeyDensityOfDrawing] animated:NO];
  //[pauseBetweenDrawingsSlider setFloatValue:[defaults floatForKey:defaultsKeyPauseBetweenDrawings]];
  [pauseBetweenDrawingsSlider setValue:[defaults floatForKey:defaultsKeyPauseBetweenDrawings] animated:NO];
  //[drawCracksOnlyOption       setState:     [defaults boolForKey: defaultsKeyDrawCracksOnly]];
  [drawCracksOnlyOption setOn:[defaults boolForKey: defaultsKeyDrawCracksOnly]animated:NO];
  //[percentCurvedSlider        setFloatValue:[defaults floatForKey:defaultsKeyPercentageOfCurvedCracks]];
  [percentCurvedSlider setValue:[defaults floatForKey:defaultsKeyPercentageOfCurvedCracks] animated:NO];
  
  return optionSheet;
}


// Save the options.
- (IBAction)okClick:(id)sender 
{
  (void)sender;
  //ScreenSaverDefaults *defaults;
  NSUserDefaults *defaults;
  //defaults = [ScreenSaverDefaults defaultsForModuleWithName:SubstrateMacModuleName];
  defaults = [NSUserDefaults standardUserDefaults];
  [defaults setFloat:[numberOfCracksSlider        floatValue] forKey:defaultsKeyNumberOfCracks];
  [defaults setFloat:[speedOfCrackingSlider       floatValue] forKey:defaultsKeySpeedOfCracking];
  [defaults setFloat:[amountOfSandSlider          floatValue] forKey:defaultsKeyAmountOfSand];
  [defaults setFloat:[densityOfDrawingSlider      floatValue] forKey:defaultsKeyDensityOfDrawing];
  [defaults setFloat:[pauseBetweenDrawingsSlider  floatValue] forKey:defaultsKeyPauseBetweenDrawings];
  [defaults setBool: [drawCracksOnlyOption        state]      forKey:defaultsKeyDrawCracksOnly];
  [defaults setFloat:[percentCurvedSlider         floatValue] forKey:defaultsKeyPercentageOfCurvedCracks];
  [defaults synchronize];
  
  //[[NSApplication sharedApplication] endSheet:optionSheet];
  //[[UIApplication sharedApplication] endSheet:optionSheet];
  // TODO: pop the options view and go back to the display

  optionNumberOfCracks        = [defaults floatForKey:defaultsKeyNumberOfCracks];
  optionSpeedOfCracking       = [defaults floatForKey:defaultsKeySpeedOfCracking];
  optionAmountOfSand          = [defaults floatForKey:defaultsKeyAmountOfSand];
  optionDensityOfDrawing      = [defaults floatForKey:defaultsKeyDensityOfDrawing];
  optionPauseBetweenDrawings  = [defaults floatForKey:defaultsKeyPauseBetweenDrawings];
  optionDrawCracksOnly        = [defaults boolForKey: defaultsKeyDrawCracksOnly];
  optionPercentCurves         = [defaults floatForKey:defaultsKeyPercentageOfCurvedCracks];
  
  [self restartAnimation];
  return;
}


- (IBAction)cancelClick:(id)sender 
{
  (void)sender;
  //[[NSApplication sharedApplication] endSheet:optionSheet];
  // TODO: pop the options view and go back to the display
}


- (int)optionPercentCurves 
{
  return optionPercentCurves;
}


- (float)optionAmountOfSand 
{
  return optionAmountOfSand;
}


- (BOOL)optionDrawCracksOnly 
{
  return optionDrawCracksOnly;
}


- (int)viewWidth 
{
  return viewWidth;
}


- (int)viewHeight 
{
  return viewHeight;
}


- (int *)crackAngleGrid 
{
  return crackAngleGrid;
}


@end


// End of HeySubstrateView.m
// =============================================================================
