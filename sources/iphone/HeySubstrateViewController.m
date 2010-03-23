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


    HeySubstrateViewController.m
    SubstrateiPhone Project

    View controller.

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateViewController.h"
#import "HeySubstrateView.h"
#import "HeySubstrateAppDelegate.h"


// -----------------------------------------------------------------------------
// MARK: HeySubstrateViewController

@implementation HeySubstrateViewController


// -----------------------------------------------------------------------------
// MARK: Properties

@synthesize animationTimer;
- (void)setAnimationTimer:(NSTimer *)newTimer
{
    [animationTimer invalidate];
    animationTimer = newTimer;
}

@synthesize animationInterval;
- (void)setAnimationInterval:(NSTimeInterval)interval
{
    animationInterval = interval;
    if (animationTimer)
    {
        [self stopAnimation];
        [self startAnimation];
    }
}


// -----------------------------------------------------------------------------
// MARK: Init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        animationInterval = 1.0f / HeySubstrateAnimationFPS;
    }
    return self;
}


- (void)dealloc 
{
    if (bitContext)
    {
        CGContextRelease(bitContext), bitContext = NULL;
    }
    if (bitImage)
    {
        CGImageRelease(bitImage), bitImage = NULL;
        if (self.view)
        {
            HeySubstrateView *v = (HeySubstrateView *)self.view;
            [v setOffscreenBitmapImage:NULL];
        }
    }
    [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UIViewController Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self startAnimation];
}


- (void)didReceiveMemoryWarning 
{
    //[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


// -----------------------------------------------------------------------------
// MARK: Animation Methods

- (void)pauseAnimation
{
    self.animationTimer = nil;
}


- (void)unpauseAnimation
{
    if (bitContext)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
    }
}


- (void)startAnimation
{
    float width = [self.view bounds].size.width;
    float height = [self.view bounds].size.height;
    CGColorSpaceRef space;
    if (!bitContext)
    {
        space = CGColorSpaceCreateDeviceRGB();
        //bitContext = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, space, kCGImageAlphaLast);
        //bitContext = CGBitmapContextCreate(NULL, width, height, 8, 0, space, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
        bitContext = CGBitmapContextCreate(NULL, width, height, 8, 0, space, (kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast));
        CGColorSpaceRelease(space);
    }
    HeySubstrateView *v = (HeySubstrateView *)self.view;
    [v restartAnimation];
    [self unpauseAnimation];
}


- (void)stopAnimation
{
    self.animationTimer = nil;
    HeySubstrateView *v = (HeySubstrateView *)self.view;
    [v stopAnimation];
    CGContextRelease(bitContext), bitContext = NULL;
}


- (void)drawView
{
    HeySubstrateView *v = (HeySubstrateView *)self.view;
    UIGraphicsPushContext(bitContext);
    [v animateOneFrame];
    if (bitImage)
        CGImageRelease(bitImage);
    bitImage = CGBitmapContextCreateImage(bitContext);

    UIGraphicsPopContext();
    [v setOffscreenBitmapImage:bitImage];
    
    // Tell the system to process user events.
    CFTimeInterval HeySubstrateRunLoopUserInterval = 0.01;
    SInt32 runLoopStatus;
    while (1)
    {
        runLoopStatus = CFRunLoopRunInMode(kCFRunLoopDefaultMode, HeySubstrateRunLoopUserInterval, TRUE);
        if (runLoopStatus != kCFRunLoopRunHandledSource)
            break;
    }
    
    [v setNeedsDisplay];
}


@end


// End of HeySubstrateViewController.m
// =============================================================================
