// ===========================================================================
/*
 Substrate
 
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
// SubstrateView.m

#import "SubstrateView.h"

// ---------------------------------------------------------------------------
#pragma mark file scope
int dimx, dimy;               // Dimensions of view
int *cgrid;                   // Array/Grid of cracks, one per pixel
subRGB goodcolor[] = {        // Palette of colors
  {0x20, 0x1F, 0x21}, {0x26, 0x2C, 0x2E}, {0x35, 0x26, 0x26}, {0x37, 0x2B, 0x27},
  {0x30, 0x2C, 0x2E}, {0x39, 0x2B, 0x2D}, {0x32, 0x32, 0x29}, {0x3F, 0x32, 0x29},
  {0x38, 0x32, 0x2E}, {0x2E, 0x33, 0x3D}, {0x33, 0x3A, 0x3D}, {0x47, 0x33, 0x29},
  {0x40, 0x39, 0x2C}, {0x40, 0x39, 0x2E}, {0x47, 0x40, 0x2C}, {0x47, 0x40, 0x2E},
  {0x4E, 0x40, 0x2C}, {0x4F, 0x40, 0x2E}, {0x4E, 0x47, 0x38}, {0x58, 0x40, 0x37},
  {0x65, 0x47, 0x2D}, {0x6D, 0x5D, 0x3D}, {0x74, 0x55, 0x30}, {0x75, 0x55, 0x32},
  {0x74, 0x5D, 0x32}, {0x74, 0x64, 0x33}, {0x7C, 0x6C, 0x36}, {0x52, 0x31, 0x52},
  {0x44, 0x48, 0x42}, {0x4C, 0x56, 0x47}, {0x65, 0x5D, 0x45}, {0x6D, 0x5D, 0x44},
  {0x6C, 0x5D, 0x4E}, {0x74, 0x6C, 0x43}, {0x7C, 0x6C, 0x42}, {0x7C, 0x6C, 0x4B},
  {0x6B, 0x73, 0x4B}, {0x73, 0x73, 0x4B}, {0x7B, 0x7B, 0x4A}, {0x6B, 0x6C, 0x55},
  {0x69, 0x6D, 0x5E}, {0x7B, 0x6C, 0x5D}, {0x6B, 0x73, 0x53}, {0x6A, 0x74, 0x5D},
  {0x72, 0x7B, 0x52}, {0x7B, 0x7B, 0x52}, {0x57, 0x74, 0x6E}, {0x68, 0x74, 0x66},
  {0x9C, 0x54, 0x2B}, {0x9D, 0x54, 0x32}, {0x9D, 0x5B, 0x35}, {0x93, 0x6B, 0x36},
  {0xAA, 0x73, 0x30}, {0xC4, 0x5A, 0x27}, {0xD9, 0x52, 0x23}, {0xD8, 0x5A, 0x20},
  {0xDB, 0x5A, 0x23}, {0xE5, 0x70, 0x37}, {0x83, 0x6C, 0x4B}, {0x8C, 0x6B, 0x4B},
  {0x82, 0x73, 0x5C}, {0x93, 0x73, 0x52}, {0x81, 0x7B, 0x63}, {0x81, 0x7B, 0x6D},
  {0x92, 0x7B, 0x63}, {0xD9, 0x89, 0x3B}, {0xE4, 0x98, 0x32}, {0xDF, 0xA1, 0x33},
  {0xE5, 0xA0, 0x37}, {0xF0, 0xAB, 0x3B}, {0x8A, 0x8A, 0x59}, {0xB2, 0x9A, 0x58},
  {0x89, 0x82, 0x6B}, {0x9A, 0x82, 0x62}, {0x88, 0x8B, 0x7C}, {0x90, 0x9A, 0x7A},
  {0xA2, 0x82, 0x62}, {0xA1, 0x8A, 0x69}, {0xA9, 0x99, 0x68}, {0x99, 0xA1, 0x60},
  {0x99, 0xA1, 0x68}, {0xCA, 0x81, 0x48}, {0xEB, 0x8D, 0x43}, {0xC2, 0x91, 0x60},
  {0xC2, 0x91, 0x68}, {0xD1, 0xA9, 0x77}, {0xC9, 0xB9, 0x7F}, {0xF0, 0xE2, 0x7B},
  {0x9F, 0x92, 0x8B}, {0xC0, 0xB9, 0x99}, {0xE6, 0xB8, 0x8F}, {0xC8, 0xC1, 0x87},
  {0xE0, 0xC8, 0x86}, {0xF2, 0xCC, 0x85}, {0xF5, 0xDA, 0x83}, {0xEC, 0xDE, 0x9D},
  {0xF5, 0xD2, 0x94}, {0xF5, 0xDA, 0x94}, {0xF4, 0xE7, 0x84}, {0xF4, 0xE1, 0x8A},
  {0xF4, 0xE1, 0x93}, {0xE7, 0xD8, 0xA7}, {0xF1, 0xD4, 0xA5}, {0xF1, 0xDC, 0xA5},
  {0xF4, 0xDB, 0xAD}, {0xF1, 0xDC, 0xAE}, {0xF4, 0xDB, 0xB5}, {0xF5, 0xDB, 0xBD},
  {0xF4, 0xE2, 0xAD}, {0xF5, 0xE9, 0xAD}, {0xF4, 0xE3, 0xBE}, {0xF5, 0xEA, 0xBE},
  {0xF7, 0xF0, 0xB6}, {0xD9, 0xD1, 0xC1}, {0xE0, 0xD0, 0xC0}, {0xE7, 0xD8, 0xC0},
  {0xF1, 0xDD, 0xC6}, {0xE8, 0xE1, 0xC0}, {0xF3, 0xED, 0xC7}, {0xF6, 0xEC, 0xCE},
  {0xF8, 0xF2, 0xC7}, {0xEF, 0xEF, 0xD0},
};
int maxpal = sizeof(goodcolor) / sizeof(subRGB);  // # of colors in palette
NSColor *crackColor;          // Color to draw cracks


// ---------------------------------------------------------------------------
@implementation SubstrateView

// ---------------------------------------------
#pragma mark SubstrateView
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
  self = [super initWithFrame:frame isPreview:isPreview];
  if (!self)
    return nil;
  
  [self setAnimationTimeInterval:1/60.0];
  dimx = frame.size.width;
  dimy = frame.size.height;
  //maxnum = 100;
  maxnum = 100;
  
  /*
      Parameters & ranges
      Good ranges: 
        90-300 seconds (make range maximums equiv. to 30-1000 seconds)
        maxnum = 11
        FPS = 60
        spdLoops = 3
        (grains = 64)
        that range = 1980 crack moves per second
                      total = 59,400 - 1,980,000 crack moves
   
        "crack move" = iteration
        make iteration range 50,000 - 2,000,000
        pause time range 0 - 60 seconds, default 10
        maxnum range 1 - 100, default 11
        spdLoops range .1 - 10, default 1
        FPS 60 only
        check box for sandpainters
        grains?
        
   
       
  */
  
  cgrid = (int*)malloc(sizeof(int) * dimx * dimy);
  cracks = [NSMutableArray arrayWithCapacity:maxnum];
  [cracks retain];
  
  // Crack is drawn with NSRectFill(), which doesn't handle alpha correctly
  //  (or at least in the expected way). Instead of black@0.85, use gray@1.0.
  //crackColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.85];
  crackColor = [NSColor colorWithDeviceRed:0.2 green:0.2 blue:0.2 alpha:1.0];
  [crackColor retain];

  return self;
}

- (void) dealloc
{
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}


- (void)makeCrack
{
  if (num < maxnum ) {
    // make a new crack instance
    [cracks insertObject:[[Crack alloc] initWithSSView:self] atIndex:num++];
  }
}


- (void)startAnimation
{
  [super startAnimation];

  // Erase crack grid
  int x, y;
  for (y = 0; y < dimy; y++) {
    for (x = 0; x < dimx; x++) {
      cgrid[y * dimx + x] = 10001;     
        // Why 10001? Flag value, means empty space/pixel.
    }
  }
  
  // Make random crack seeds
  int i, k;
  srandom(time(0));
  for (k = 0; k < 16; k++) {
    i = random() % (dimx * dimy);
    cgrid[i] = random() % 360;
  }
    
  // Make just three cracks
  num = 0;
  for (k = 0; k < 3; k++) {
    [self makeCrack];
  }
  
  return;
}


- (void)stopAnimation
{
  [super stopAnimation];
}


- (void)drawRect:(NSRect)rect
{
  [super drawRect:rect];
}


- (void)animateOneFrame
{
  // Clear background
  if (bgCleared == NO) {
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:[self frame]];
    //NSRectFill([self frame]);
    bgCleared = YES;
  }
  
  // crack all cracks
  int n;
  int spdLoops;
  for (spdLoops = 3; spdLoops > 0; spdLoops--) {
    for (n = 0; n < num; n++) {
      [[cracks objectAtIndex:n] move];
    }
  }

  return;
}

- (BOOL)isOpaque
{
  return YES;
  //return NO;
}

- (BOOL)hasConfigureSheet
{
  return YES;
}

- (NSWindow*)configureSheet
{
  if (!configSheet) {
    if (![NSBundle loadNibNamed:@"SubstrateOptions" owner:self]) {
      NSLog(@"Unable to load options configuration sheet.");
      NSBeep();
    }
  }
  return configSheet;
}

- (IBAction)cancelClick:(id)sender
{
  [[NSApplication sharedApplication] endSheet:configSheet];
}

@end
// ---------------------------------------------------------------------------


// ---------------------------------------------------------------------------
@implementation Crack

- (id)initWithSSView:(SubstrateView *)view
{
  self = [super init];
  if (!self)
    return nil;
  
  [self findStart];
  [view retain];
  ssView = view;
  sp = [[SandPainter alloc] init];

  return self;
}

- (void)findStart
{
  // Pick random points looking for a crack
  int px = 0;
  int py = 0;
  BOOL found = NO;
  int timeout = 0;
  while (!found && timeout++ < 1000) {
    px = random() % dimx;
    py = random() % dimy;
    if (cgrid[py * dimx + px] < 10000)  // ??? why 10000? -- see 10001 above
      found = YES;
  }

  int a;
  if (found)
    a = cgrid[py * dimx + px];
  else
    a = random() % 360;
  
  // Start crack
  if ((random() % 100) < 50)
    a -= 90 + (int)(((random() % 41000) / 10000.0) - 2.0);  // java: int(random(-2.0, 2.1)
  else
    a += 90 + (int)(((random() % 41000) / 10000.0) - 2.0);  // java: int(random(-2.0, 2.1)
  [self startCrackX:px Y:py T:a];
}

- (void)startCrackX:(int)intX Y:(int)intY T:(int)intT
{
  x = intX;
  y = intY;
  t = intT;
  x += 0.61 * cos(t * M_PI / 180);      // This 0.61 cos is a documented formula?
  y += 0.61 * sin(t * M_PI / 180);
}

- (void)move
{
  // Continue cracking
  x += 0.42 * cos(t * M_PI / 180);      // How about the 0.42 cos?
  y += 0.42 * sin(t * M_PI / 180);
  
  // Bounds check & add fuzz
  int cx, cy;
  float z = 0.33;
  cx = (int)(x + ((random() % (int)(z * 200)) / 100.0) - z); // java: random(-z,z)
  cy = (int)(y + ((random() % (int)(z * 200)) / 100.0) - z);
  
  // Draw sand painter
  [self regionColor];

  // Draw black-ish crack
  [crackColor set];
  // Draw crack using NSRectFill() to get accurate, sharp pixels.
  //[NSBezierPath strokeRect:NSMakeRect(cx + 0.5, cy + 0.5, 1.0, 1.0)];
  NSRectFill(NSMakeRect(cx, cy, 1.0, 1.0)); 
  
  // Bounds check, collision detection.
  if (cx >= 0 && cx < dimx && cy >= 0 && cy < dimy) {
    // If empty space, or angle of collision < 5 degrees, continue cracking.
    if (cgrid[cy * dimx + cx] > 10000 || abs(cgrid[cy * dimx + cx] - t) < 5) {
      cgrid[cy * dimx + cx] = (int)t;
    }
    else if (abs(cgrid[cy * dimx + cx] - t) > 2) {
      // crack encountered (not self), stop cracking this crack here,
      //  move to another point and also make another crack.
      [self findStart];
      [ssView makeCrack];
    }
  }
  else {
    // Out of bounds, stop cracking this crack here,
    //  move to another point and also make another crack.
    [self findStart];
    [ssView makeCrack];
  }
  return;
}

- (void)regionColor
{
  float rx = x;
  float ry = y;
  int cx, cy;
  BOOL openspace = YES;
  
  // Find extents of open space, start checking one step away from crack.
  while (openspace) {
    // Move perpendicular to crack
    rx += 0.81 * sin(t * M_PI / 180);
    ry -= 0.81 * cos(t * M_PI / 180);
    cx = (int)rx;
    cy = (int)ry;
    // Bounds check
    if (cx >= 0 && cx < dimx && cy >= 0 && cy < dimy) {
      if (cgrid[cy * dimx + cx] > 10000) {
        // Space is open, continue looking.
      }
      else {
        openspace = NO;
      }
    }
    else {
      openspace = NO;
    }
  }
  // Draw sand painter
  [sp renderRX:rx RY:ry X:x Y:y];
}

@end
// ---------------------------------------------------------------------------


// ---------------------------------------------------------------------------
@implementation SandPainter

- (subRGB *)somecolor
{
  return goodcolor + (random() & (maxpal - 1));
}

- (id)init
{
  self = [super init];
  if (!self)
    return nil;
  
  c = [self somecolor];
  baseSandColor = [NSColor colorWithDeviceRed:c->rVal/255.0 green:c->gVal/255.0 blue:c->bVal/255.0 alpha:1.0];
  [baseSandColor retain];
  g = (random() % 10) / 100.0 + 0.01;
    
  return self;
}


- (void)renderRX:(float)x RY:(float)y X:(float)ox Y:(float)oy
{
  // modulate gain
  g += (random() % 10) / 100.0 - 0.05;
  float maxg = 1.0;
  if (g < 0)
    g = 0;
  if (g > maxg)
    g = maxg;
  
  // Calculate grains by distance
  // int grains = int( sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)) )
  int grains = 64;
  
  // Lay down grains of sand (transparent pixels)
  float w = g / (grains - 1);
  int i;
  float a;
  float sandX, sandY;
  int pixSandX, pixSandY;
  int prevPixSandX = 0, prevPixSandY = 0;

  for (i = 0; i < grains; i++) {    
    sandX = ox + (x - ox) * sin(sin(i * w));
    sandY = oy + (y - oy) * sin(sin(i * w));
    pixSandX = (int)sandX;
    pixSandY = (int)sandY;
    // Don't keep drawing the same pixels over and over again
    if ((pixSandX != prevPixSandX) || (pixSandY !=prevPixSandY)) {
      prevPixSandX = pixSandX;
      prevPixSandY = pixSandY;
      a = 0.1 - i / (grains * 10.0);
      [[baseSandColor colorWithAlphaComponent:a] set];
      // NSRectFill(NSMakeRect(pixSandX, pixSandY, 1.0, 1.0));
      [NSBezierPath strokeRect:NSMakeRect(pixSandX + 0.5, pixSandY + 0.5, 1.0, 1.0)];
    }
  }
}

@end
// ---------------------------------------------------------------------------


// End of SubstrateView.m
// ===========================================================================
