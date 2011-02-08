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
#import "HeySubstrateColorPalette.h"


// -----------------------------------------------------------------------------
// MARK: Constants

static const float curvedCrackStep = 0.42f;     // Curve drawing step increment.
static const float M_PI_180_F = (float)M_PI / 180.0f;  // Cache this calc, used many times.
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
    self = [super init];
    if (self)
    {
        vFSource = (HeyVectF_t *) malloc(sizeof(HeyVectF_t) * sandGrainCnt);
        success = vFSource ? YES : NO;
        if (success)
        {
            vFDest   = (HeyVectF_t *) malloc(sizeof(HeyVectF_t) * sandGrainCnt);
        }
        success = vFDest ? YES : NO;
        if (success) 
        {
            saverView = [view retain];
            [self findStartPointAndTravelAngle];
        } 
        else 
        {
            free(vFSource), vFSource = NULL;
            free(vFDest), vFDest = NULL;
            [super dealloc];
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
    
    // Find a good start point unless the user touched to specifically make one.
    CGPoint touched = [saverView nextCrackOrigin];
    if (CGPointEqualToPoint(touched, CGPointZero))
    {
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
    }
    else
    {
        found = NO;
        randomX = (int)(touched.x * [[UIScreen mainScreen] scale]);
        randomY = (int)(touched.y * [[UIScreen mainScreen] scale]);
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


- (void)setQLayerContext:(CGContextRef)ctx
{
    qLayerContext = ctx;
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
#if TARGET_OS_IPHONE
    CGContextSetFillColorWithColor(qLayerContext, [HeySubstrateCrackColor CGColor]);
    CGContextFillRect(qLayerContext, CGRectMake(drawX, drawY, 1.0f, 1.0f)); 
#else
    [HeySubstrateCrackColor set];
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

#if TARGET_OS_IPHONE
                CGContextSetFillColorWithColor(qLayerContext, [[baseSandColor colorWithAlphaComponent:sandAlpha] CGColor]);
                CGContextFillRect(qLayerContext, CGRectMake(pixSandX, pixSandY, 1.0f, 1.0f)); 
#else
                [[baseSandColor colorWithAlphaComponent:sandAlpha] set];
                [NSBezierPath fillRect:NSMakeRect(pixSandX + 0.5f, pixSandY + 0.5f, 1.0f, 1.0f)];
#endif
            }
        }
    }
}


/*
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
    
    float sandFromX = crackPosX + (xEnd - crackPosX) * sinf(sinf(0 * w));
    float sandFromY = crackPosY + (yEnd - crackPosY) * sinf(sinf(0 * w));
    float sandToX   = crackPosX + (xEnd - crackPosX) * sinf(sinf((sandGrainCnt - 1) * w));
    float sandToY   = crackPosY + (yEnd - crackPosY) * sinf(sinf((sandGrainCnt - 1) * w));
    int intSandFromX = (int)sandFromX;
    int intSandFromY = (int)sandFromY;
    int intSandToX   = (int)sandToX;
    int intSandToY   = (int)sandToY;
    float sandAlpha = 0.15f;
    
    
   //sandAlpha = 0.15f - (0 to sandGrainCnt-1) / (sandGrainCnt * 10.0f);

    
    CGContextSetStrokeColorWithColor(qLayerContext, [[baseSandColor colorWithAlphaComponent:sandAlpha] CGColor]);
    CGContextSetLineWidth(qLayerContext, 1.0f);
    CGContextBeginPath(qLayerContext);
    CGContextMoveToPoint(qLayerContext, (float)intSandFromX, (float)intSandFromY);
    CGContextAddLineToPoint(qLayerContext, (float)intSandToX, (float)intSandToY);
    CGContextStrokePath(qLayerContext);
#if TARGET_OS_IPHONE



#else
    [NSBezierPath fillRect:NSMakeRect(pixSandX + 0.5f, pixSandY + 0.5f, 1.0f, 1.0f)];
#endif


}
*/

- (void)setupSand 
{
    HeySubstrateColorPalette *palette = [saverView palette];
    if (baseSandColor)
    {
        [baseSandColor release];
    }
    baseSandColor = [palette randomColor];
    [baseSandColor retain];
    sandGain = (float)(arc4random() % 10) / 100.0f + 0.01f;
}




@end


// End of HeySubstrateCrack.m
// =============================================================================
