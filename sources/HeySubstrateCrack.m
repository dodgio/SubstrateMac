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


    HeySubstrateCrack.m
    SubstrateMac/SubstrateiPhone Projects

    "Crack" drawing abstraction class.

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateCrack.h"
#import "HeySubstrateView.h"


// -----------------------------------------------------------------------------
// MARK: Constants

static const float curvedCrackStep = 0.42f;     // Curve drawing step increment.
static const float M_PI_180_F = (float)M_PI / 180.0f;  // Cache this calc, used many times.
HeySubstrateRGB const HeySubstrateRGBPalette[] = 
{ // Palette of sand colors.
{0x06, 0x05, 0x01}, {0x0A, 0x11, 0x16}, {0x2C, 0x0B, 0x02}, {0x0F, 0x24, 0x0B}, 
{0x38, 0x10, 0x1F}, {0x0F, 0x27, 0x29}, {0x2A, 0x28, 0x0B}, {0x2C, 0x2F, 0x29}, 
{0x27, 0x32, 0x47}, {0x53, 0x2B, 0x0F}, {0x2F, 0x46, 0x2B}, {0x5A, 0x31, 0x3B}, 
{0x2F, 0x48, 0x4C}, {0x4E, 0x47, 0x0B}, {0x9F, 0x20, 0x04}, {0x4D, 0x4A, 0x2D}, 
{0x71, 0x46, 0x09}, {0x87, 0x32, 0x3A}, {0x4C, 0x51, 0x4A}, {0x46, 0x54, 0x6A}, 
{0x6D, 0x4D, 0x2C}, {0xDB, 0x21, 0x06}, {0x54, 0x67, 0x0D}, {0x6D, 0x51, 0x49}, 
{0x90, 0x4C, 0x09}, {0x50, 0x67, 0x2F}, {0x70, 0x52, 0x6A}, {0x51, 0x68, 0x4F}, 
{0x90, 0x4F, 0x2A}, {0x73, 0x69, 0x0A}, {0xB6, 0x48, 0x0A}, {0x50, 0x6A, 0x6D}, 
{0x8E, 0x52, 0x4A}, {0x71, 0x69, 0x2E}, {0x8F, 0x52, 0x6E}, {0xB3, 0x4F, 0x28}, 
{0x6F, 0x6C, 0x4E}, {0x91, 0x6E, 0x08}, {0xB5, 0x53, 0x47}, {0x6F, 0x72, 0x6C}, 
{0x91, 0x6D, 0x2D}, {0xAD, 0x53, 0x79}, {0x66, 0x74, 0x8C}, {0x8F, 0x70, 0x4E}, 
{0xB6, 0x70, 0x07}, {0x8F, 0x72, 0x6D}, {0xB3, 0x6E, 0x2C}, {0xDD, 0x5C, 0x1B}, 
{0x73, 0x89, 0x6E}, {0xB1, 0x71, 0x4C}, {0xAF, 0x73, 0x6D}, {0x72, 0x8D, 0x8F}, 
{0xA8, 0x72, 0x8E}, {0x93, 0x8B, 0x4B}, {0x90, 0x8A, 0x6F}, {0xD7, 0x73, 0x4B}, 
{0xAF, 0x8F, 0x22}, {0xAA, 0x88, 0x5F}, {0xAA, 0x88, 0x7D}, {0xB3, 0x90, 0x44}, 
{0x91, 0x95, 0x8D}, {0xCF, 0x8F, 0x05}, {0xC0, 0x88, 0x61}, {0x8A, 0x97, 0xAE}, 
{0xA6, 0x99, 0x62}, {0xC0, 0x87, 0x7C}, {0xA3, 0x99, 0x77}, {0x98, 0xAA, 0x4C}, 
{0xD3, 0x92, 0x2C}, {0xD3, 0x90, 0x4E}, {0xBB, 0x99, 0x60}, {0x96, 0xAA, 0x73}, 
{0xB2, 0x98, 0x8E}, {0xF4, 0x90, 0x06}, {0xBB, 0x99, 0x77}, {0xB3, 0x95, 0xAD}, 
{0x95, 0xAA, 0x93}, {0xF7, 0x8F, 0x2B}, {0xB7, 0xAB, 0x49}, {0xD4, 0x97, 0x6F}, 
{0xF6, 0x8D, 0x4F}, {0xAA, 0xAA, 0x88}, {0xD1, 0x96, 0x8E}, {0xB6, 0xAA, 0x71}, 
{0x94, 0xB0, 0xB1}, {0xAA, 0xAA, 0x9E}, {0xD6, 0xB0, 0x08}, {0xD1, 0x95, 0xAE}, 
{0xBB, 0xAA, 0x88}, {0xCC, 0xAA, 0x5F}, {0xF4, 0x94, 0x6D}, {0xBB, 0xAA, 0x9D}, 
{0xD5, 0xB2, 0x2C}, {0xCC, 0xAA, 0x77}, {0xA8, 0xBC, 0x84}, {0xCC, 0xAA, 0x88}, 
{0xF3, 0x97, 0x8B}, {0xD6, 0xB3, 0x44}, {0xA8, 0xBB, 0x99}, {0xE1, 0xAA, 0x60}, 
{0xCC, 0xAA, 0x9E}, {0xDD, 0xAA, 0x77}, {0xBB, 0xBB, 0x83}, {0xC9, 0xBB, 0x60}, 
{0xF2, 0x99, 0xB2}, {0xF8, 0xB7, 0x06}, {0xE2, 0xAA, 0x88}, {0xBB, 0xBB, 0x99}, 
{0xAD, 0xB8, 0xD0}, {0xB5, 0xBA, 0xB0}, {0xCC, 0xBB, 0x77}, {0xE2, 0xAA, 0x9F}, 
{0xF5, 0xB6, 0x2B}, {0xCC, 0xBB, 0x88}, {0xDD, 0xBB, 0x5F}, {0xB9, 0xCC, 0x67}, 
{0xCC, 0xBB, 0x99}, {0xDB, 0xD0, 0x08}, {0xF5, 0xB6, 0x4D}, {0xDD, 0xBB, 0x77}, 
{0xDA, 0xCC, 0x2D}, {0xDD, 0xBB, 0x88}, {0xD3, 0xBA, 0xAF}, {0xF5, 0xB6, 0x70}, 
{0xDD, 0xBB, 0x99}, {0xDA, 0xCC, 0x4E}, {0xEE, 0xCC, 0x1B}, {0xB8, 0xCC, 0xB4}, 
{0xCB, 0xCC, 0x83}, {0xDB, 0xB8, 0xCF}, {0xEE, 0xCC, 0x33}, {0xCA, 0xCC, 0x99}, 
{0xB4, 0xCD, 0xD1}, {0xDC, 0xCC, 0x6F}, {0xF6, 0xB9, 0x91}, {0xEE, 0xCC, 0x44}, 
{0xFD, 0xD1, 0x03}, {0xCC, 0xCC, 0xAA}, {0xFF, 0xCC, 0x22}, {0xEE, 0xCC, 0x55}, 
{0xDD, 0xCC, 0x88}, {0xF3, 0xBA, 0xB0}, {0xCC, 0xCC, 0xBB}, {0xFF, 0xCC, 0x33}, 
{0xEE, 0xCC, 0x66}, {0xDD, 0xCC, 0x99}, {0xCC, 0xCC, 0xCC}, {0xFF, 0xCC, 0x44}, 
{0xED, 0xDD, 0x1B}, {0xEE, 0xCC, 0x77}, {0xDD, 0xCC, 0xAA}, {0xCB, 0xDD, 0x82}, 
{0xCA, 0xCC, 0xE2}, {0xFF, 0xCC, 0x55}, {0xEE, 0xCC, 0x88}, {0xEC, 0xDD, 0x33}, 
{0xDD, 0xCC, 0xBB}, {0xCA, 0xDD, 0x99}, {0xDD, 0xEE, 0x0B}, {0xFF, 0xCC, 0x66}, 
{0xEE, 0xCC, 0x99}, {0xEC, 0xDD, 0x44}, {0xDD, 0xCC, 0xCC}, {0xFF, 0xDD, 0x1B}, 
{0xFF, 0xCC, 0x77}, {0xCB, 0xDD, 0xAA}, {0xEE, 0xCC, 0xAA}, {0xEC, 0xDD, 0x55}, 
{0xDD, 0xDD, 0x82}, {0xDD, 0xCC, 0xE0}, {0xCA, 0xDD, 0xBB}, {0xFF, 0xCC, 0x88}, 
{0xEB, 0xDD, 0x66}, {0xEE, 0xCC, 0xBB}, {0xFF, 0xDD, 0x33}, {0xCA, 0xDD, 0xCC}, 
{0xDD, 0xDD, 0x99}, {0xFF, 0xCC, 0x99}, {0xEE, 0xCC, 0xCC}, {0xFF, 0xDD, 0x44}, 
{0xC8, 0xDD, 0xDE}, {0xEE, 0xDD, 0x77}, {0xEC, 0xEE, 0x22}, {0xDC, 0xEE, 0x4E}, 
{0xDD, 0xDD, 0xAA}, {0xFF, 0xCC, 0xAA}, {0xFF, 0xDD, 0x55}, {0xEE, 0xCC, 0xE0}, 
{0xEE, 0xDD, 0x88}, {0xDD, 0xDD, 0xBB}, {0xFF, 0xCC, 0xBB}, {0xFF, 0xDD, 0x66}, 
{0xFF, 0xCA, 0xCC}, {0xDA, 0xEE, 0x71}, {0xFE, 0xEF, 0x0A}, {0xEE, 0xDD, 0x99}, 
{0xDD, 0xDD, 0xCC}, {0xFF, 0xDD, 0x77}, {0xFF, 0xCA, 0xE0}, {0xEE, 0xDD, 0xAA}, 
{0xD6, 0xDC, 0xF1}, {0xDD, 0xDD, 0xDD}, {0xFF, 0xDD, 0x88}, {0xEE, 0xEE, 0x5E}, 
{0xDB, 0xEE, 0x92}, {0xEE, 0xDD, 0xBB}, {0xFE, 0xF0, 0x2D}, {0xFF, 0xDD, 0x99}, 
{0xEE, 0xDD, 0xCC}, {0xEE, 0xEE, 0x77}, {0xFF, 0xDD, 0xAA}, {0xFE, 0xEF, 0x4D}, 
{0xEE, 0xDD, 0xDD}, {0xDC, 0xEE, 0xB6}, {0xEE, 0xEE, 0x88}, {0xFF, 0xDD, 0xBB}, 
{0xFF, 0xEE, 0x66}, {0xEE, 0xEE, 0x99}, {0xFF, 0xDD, 0xCC}, {0xDC, 0xEE, 0xD5}, 
{0xFF, 0xEE, 0x77}, {0xEE, 0xEE, 0xAA}, {0xFF, 0xDD, 0xDD}, {0xF8, 0xDD, 0xF2}, 
{0xFF, 0xEE, 0x88}, {0xD9, 0xEE, 0xF0}, {0xEE, 0xEE, 0xBB}, {0xFF, 0xEE, 0x99}, 
{0xED, 0xFF, 0x71}, {0xEE, 0xEE, 0xCC}, {0xFF, 0xEE, 0xAA}, {0xEE, 0xEE, 0xDD}, 
{0xFF, 0xEE, 0xBB}, {0xFF, 0xFF, 0x60}, {0xED, 0xFF, 0x94}, {0xEE, 0xEE, 0xEE}, 
{0xFF, 0xEE, 0xCC}, {0xEE, 0xEE, 0xFF}, {0xFF, 0xFF, 0x77}, {0xED, 0xFF, 0xAA}, 
{0xFF, 0xEE, 0xDD}, {0xFF, 0xFF, 0x88}, {0xED, 0xFF, 0xBB}, {0xFF, 0xEE, 0xEE}, 
{0xFF, 0xFF, 0x99}, {0xED, 0xFF, 0xCC}, {0xFF, 0xEE, 0xFF}, {0xFF, 0xFF, 0xAA}, 
{0xED, 0xFF, 0xDD}, {0xFF, 0xFF, 0xBB}, {0xED, 0xFF, 0xEE}, {0xEB, 0xFF, 0xFF}, 
{0xFF, 0xFF, 0xCC}, {0xFF, 0xFF, 0xDD}, {0xFF, 0xFF, 0xEE}, {0xFF, 0xFF, 0xFF}, 
};
// Number of colors in palette.
static const int maxPaletteEntries = sizeof(HeySubstrateRGBPalette) / sizeof(HeySubstrateRGB);  
static const int sandGrainCnt = 64;     // Number of grains of sand
static const int sandGrainVecLen = 4;   // Number of floats in vector (vectF_t)
static const int sandGrainVecCnt = 16;  // sandGrainCnt / sandGrainVecLen


// -----------------------------------------------------------------------------
// MARK: HeySubstractCrack

@implementation HeySubstrateCrack


// -----------------------------------------------------------------------------
// MARK: Init and Dealloc

// Designated initializer.
- (id)initWithSSView:(HeySubstrateView *)view 
{
    BOOL success = YES;
    
    if ((self = [super init])) 
    {
        vFSource = (HeyVectF_t *) malloc(sizeof(HeyVectF_t) * sandGrainCnt);
        success = vFSource ? YES : NO;
        if (success)
            vFDest   = (HeyVectF_t *) malloc(sizeof(HeyVectF_t) * sandGrainCnt);
        success = vFDest ? YES : NO;
        if (success) 
        {
            [view retain];
            saverView = view;
            [self findStartPointAndTravelAngle];
        } 
        else 
        {
            free(vFSource), vFSource = NULL;
            free(vFDest), vFDest = NULL;
            [self release];
            return nil;
        }
    }
    return self;
}


// Destroy.
- (void) dealloc 
{
    [baseSandColor release], baseSandColor = nil;
    free(vFSource), vFSource = NULL;
    free(vFDest), vFDest = NULL;
    [saverView release], saverView = nil;
    
    [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: Methods

// Begin a new crack.
- (void)findStartPointAndTravelAngle 
{
    [self setupSand];
    // Pick random points looking for a crack
    int randomX = 0;
    int randomY = 0;
    BOOL found = NO;
    int timeout = 0;
    int vWidth = [saverView viewWidth];
    int vHeight = [saverView viewHeight];
    int *cag = [saverView crackAngleGrid];
    while (!found && timeout++ < 10000) 
    {
        randomX = (int)(arc4random() % vWidth);
        randomY = (int)(arc4random() % vHeight);
        if (cag[randomY * vWidth + randomX] < cagEmpty) 
        {
            // <10,000 means pixel has a crack through it
            found = YES;
        }
    }
    
    // Start crack
    posX = randomX;
    posY = randomY;
    if (found)
        angleOfTravel = (float)(cag[randomY * vWidth + randomX]);
    else
        angleOfTravel = (float)(arc4random() % 360);
    
    if ((arc4random() % 100) < 50) 
    {
        // Half of new cracks as positive angle, half negative
        angleOfTravel -= 90 + (float)(((arc4random() % 41000) / 10000.0) - 2.0);  
        // original java: int(random(-2.0, 2.1)
    } 
    else 
    {
        angleOfTravel += 90 + (float)(((arc4random() % 41000) / 10000.0) - 2.0);  
    }
    cosAnglePi180 = cosf(angleOfTravel * (float)M_PI / 180.0f);
    sinAnglePi180 = sinf(angleOfTravel * (float)M_PI / 180.0f);
    posX += 0.61f * cosAnglePi180;
    posY += 0.61f * sinAnglePi180;
    
    float radius;
    float radian_inc;
    if (arc4random() % 100 < (unsigned int)[saverView optionPercentCurves]) 
    {
        curved = YES;
        degrees_drawn = 0;
        radius = (float)(10 + (arc4random() % ((vWidth + vHeight) / 2)));
        if (arc4random() % 100 < 50) 
        {
            radius *= -1;
        }
        // arc length  = radius * theta => theta = arc length / radius
        radian_inc = curvedCrackStep / radius;
        t_inc = radian_inc * 360.0f / 2.0f / (float)M_PI;
        ys = radius * sinf(radian_inc);
        xs = radius * (1.0f - cosf(radian_inc));
    } 
    else 
    {
        curved = NO;
        degrees_drawn = 0;
        //radius = 0;
        t_inc = 0;
        xs = 0;
        ys = 0;
    }  
}


// Move the cracking of the cracks forward.
- (void)move 
{
    int vWidth = [saverView viewWidth];
    int vHeight = [saverView viewHeight];
    int *cag = [saverView crackAngleGrid];
    
    // Continue cracking
    if (!curved) 
    {
        posX += 0.42f * cosAnglePi180;
        posY += 0.42f * sinAnglePi180;
    } 
    else 
    {
        //float oldx, oldy;
        //oldx = posX;
        //oldy = posY;
        posX += ys * cosAnglePi180;
        posY += ys * sinAnglePi180;
        posX += xs * (cosAnglePi180 - (float)M_PI / 2.0f);
        posY += xs * (sinAnglePi180 - (float)M_PI / 2.0f);
        angleOfTravel += t_inc;
        degrees_drawn += abs(t_inc);
        cosAnglePi180 = cosf(angleOfTravel * (float)M_PI / 180.0f);
        sinAnglePi180 = sinf(angleOfTravel * (float)M_PI / 180.0f);
    }
    
    // Add fuzz to line of crack and draw
    int drawX, drawY;
    float z = 0.33f;
    //drawX = (int)(posX + ((((int)random()) % (int)(z * 200.0f)) / 100.0f) - z); // java: random(-z,z)
    //drawY = (int)(posY + ((((int)random()) % (int)(z * 200.0f)) / 100.0f) - z);
    drawX = (int)(posX + ((arc4random() % (int)(z * 200.0f)) / 100.0f) - z); // java: random(-z,z)
    drawY = (int)(posY + ((arc4random() % (int)(z * 200.0f)) / 100.0f) - z);
    
    // Draw sand
    if (![saverView optionDrawCracksOnly]) 
    {
        [self regionColor];
    }
    
    // Draw black-ish crack
    [HeySubstrateCrackColor set];
#if TARGET_OS_IPHONE
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, CGRectMake(drawX, drawY, 1.0f, 1.0f)); 
#else
    [NSBezierPath fillRect:NSMakeRect(drawX, drawY, 1.0f, 1.0f)];
#endif
    
    // Bounds check, collision detection.
    if (drawX >= 0 && drawX < vWidth && drawY >= 0 && drawY < vHeight) 
    {
        // If empty space, or angle of collision < 5 degrees, continue cracking.
        if (cag[drawY * vWidth + drawX] > cagEmpty || abs(cag[drawY * vWidth + drawX] - angleOfTravel) < 5) 
        {
            cag[drawY * vWidth + drawX] = (int)angleOfTravel;
        } 
        else if (abs(cag[drawY * vWidth + drawX] - angleOfTravel) > 2) 
        {
            // crack encountered (not self), stop cracking this crack here,
            //  move to another point and also make another crack.
            [self findStartPointAndTravelAngle];
            [saverView makeACrack];
        }
    } 
    else 
    {
        // Out of bounds, stop cracking this crack here,
        //  move to another point and also make another crack.
        [self findStartPointAndTravelAngle];
        [saverView makeACrack];
    }
    return;
}


// Spread the sand color into the open space.
- (void)regionColor 
{
    float openRegionX = posX;
    float openRegionY = posY;
    int checkX, checkY;
    BOOL openspace = YES;
    int vWidth = [saverView viewWidth];
    int vHeight = [saverView viewHeight];
    int *cag = [saverView crackAngleGrid];
    
    // Find extents of open space, start checking one step away from crack.
    while (openspace) 
    {
        // Move perpendicular to crack
        openRegionX += 0.81f * sinf(angleOfTravel * M_PI_180_F);
        openRegionY -= 0.81f * cosf(angleOfTravel * M_PI_180_F);
        checkX = (int)openRegionX;
        checkY = (int)openRegionY;
        // Bounds check
        if (checkX >= 0 && checkX < vWidth && checkY >= 0 && checkY < vHeight) 
        {
            if (cag[checkY * vWidth + checkX] > cagEmpty) 
            {
                // Space is open, continue looking.
            } 
            else 
            {
                openspace = NO;
            }
        } 
        else 
        {
            openspace = NO;
        }
    }
    // Draw sand
    [self paintToX:openRegionX Y:openRegionY FromCrackX:posX CrackY:posY];
}


// Draw the sand.
- (void)paintToX:(float)xEnd Y:(float)yEnd FromCrackX:(float)crackPosX CrackY:(float)crackPosY 
{
    // modulate gain
    sandGain += (float)(arc4random() % 10) / 100.0f + [saverView optionAmountOfSand];
    float maxSandGain = 1.0f;
    if (sandGain < 0)
        sandGain = 0;
    if (sandGain > maxSandGain)
        sandGain = maxSandGain;
    
    // Calculate grains by distance
    // Lay down grains of sand (translucent pixels)
    // Vectorized version of
    //    sinCalc = sin(sin(i * w));
    float w = sandGain / (sandGrainCnt - 1);
    int i, j;
    for (i = 0; i < sandGrainVecCnt; i++) 
    {
        for (j = 0; j < sandGrainVecLen; j++) 
        {
            vFSource[i].f[j] = (i * sandGrainVecLen + j) * w;
        }
    }
    Heyvvsinf( (float *)vFDest,   (float *)vFSource, &sandGrainCnt);
    Heyvvsinf( (float *)vFSource, (float *)vFDest,   &sandGrainCnt);
    
    
    float sandAlpha;
    float sandX, sandY;
    int pixSandX, pixSandY;
    int prevPixSandX = 0, prevPixSandY = 0;
    
    for (i = 0; i < sandGrainVecCnt; i++) 
    {    
        for (j = 0; j < sandGrainVecLen; j++) 
        {
            sandX = crackPosX + (xEnd - crackPosX) * vFSource[i].f[j];
            sandY = crackPosY + (yEnd - crackPosY) * vFSource[i].f[j];
            pixSandX = (int)sandX;
            pixSandY = (int)sandY;
            // Drawing optimization: don't keep drawing the same pixels over and over again
            if ((pixSandX != prevPixSandX) || (pixSandY !=prevPixSandY)) 
            {
                prevPixSandX = pixSandX;
                prevPixSandY = pixSandY;
                // sandAlpha = 0.1 - (i * sandGrainVecLen + j) / (sandGrainCnt * 10.0); // too pale, punch up a bit
                sandAlpha = 0.15f - (i * sandGrainVecLen + j) / (sandGrainCnt * 10.0f);
                [[baseSandColor colorWithAlphaComponent:sandAlpha] set];
#if TARGET_OS_IPHONE
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGContextFillRect(ctx, CGRectMake(pixSandX, pixSandY, 1.0f, 1.0f)); 
#else
                [NSBezierPath fillRect:NSMakeRect(pixSandX + 0.5f, pixSandY + 0.5f, 1.0f, 1.0f)];
#endif
            }
        }
    }
}


- (void)setupSand 
{
    HeySubstrateRGB const *sandRGB = [self randomSubstrateRGB];
    if (baseSandColor) 
    {
        [baseSandColor release];
    }
    baseSandColor = [HEYCOLOR HeyColorWithRed:sandRGB->redValue/255.0f 
                                    green:sandRGB->greenValue/255.0f 
                                     blue:sandRGB->blueValue/255.0f 
                                    alpha:1.0f];
    [baseSandColor retain];
    sandGain = (float)(arc4random() % 10) / 100.0f + 0.01f;
}


- (HeySubstrateRGB const *)randomSubstrateRGB 
{
    return HeySubstrateRGBPalette + (arc4random() & (maxPaletteEntries - 1));
}


@end


// End of HeySubstrateCrack.m
// =============================================================================
