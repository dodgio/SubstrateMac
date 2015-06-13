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

@synthesize displayLink;
- (void)setDisplayLink:(CADisplayLink *)newDisplayLink
{
    [displayLink invalidate];
    displayLink = newDisplayLink;
}

// -----------------------------------------------------------------------------
// MARK: Init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {

    }
    return self;
}


- (void)dealloc 
{
    if (displayLink)
    {
        [displayLink invalidate];
        displayLink = nil;
    }
    [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UIViewController Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Test if OK to use gestures.
    UIGestureRecognizer *test = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipeUp:)];
    if ([test respondsToSelector:@selector(locationInView:)])
    {
        UISwipeGestureRecognizer *upDblSwipes = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipeUp:)] autorelease];
        [upDblSwipes setNumberOfTouchesRequired:2];
        [upDblSwipes setDirection:UISwipeGestureRecognizerDirectionUp];
        UISwipeGestureRecognizer *downDblSwipes = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipeDown:)] autorelease];
        [downDblSwipes setNumberOfTouchesRequired:2];
        [downDblSwipes setDirection:UISwipeGestureRecognizerDirectionDown];
        UISwipeGestureRecognizer *leftDblSwipes = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipeLeft:)] autorelease];
        [leftDblSwipes setNumberOfTouchesRequired:2];
        [leftDblSwipes setDirection:UISwipeGestureRecognizerDirectionLeft];
        UISwipeGestureRecognizer *rightDblSwipes = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipeRight:)] autorelease];
        [rightDblSwipes setNumberOfTouchesRequired:2];
        [rightDblSwipes setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [[self view] addGestureRecognizer:upDblSwipes];
        [[self view] addGestureRecognizer:downDblSwipes];
        [[self view] addGestureRecognizer:leftDblSwipes];
        [[self view] addGestureRecognizer:rightDblSwipes];
        
        //    [gestures setCancelsTouchesInView:YES];
        //    [gestures setDelaysTouchesBegan:YES];
        //    [gestures setDelaysTouchesEnded:YES];
    }
    [test release];
    
    [self startAnimation];
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


// -----------------------------------------------------------------------------
// MARK: -
// MARK: Actions

- (void)handleDoubleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer
{
    (void)gestureRecognizer;
    //NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)handleDoubleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer
{
    (void)gestureRecognizer;
    [(HeySubstrateView *)[self view] saveFrameToLibrary];
    [(HeySubstrateView *)[self view] setMessage:NSLocalizedString(@"Photo Saved", @"Photo Saved")];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:[self view] selector:@selector(clearMessage) userInfo:nil repeats:NO];
}


- (void)handleDoubleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    (void)gestureRecognizer;
    [self pauseAnimation];
}


- (void)handleDoubleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    (void)gestureRecognizer;
    [self unpauseAnimation];
}


// -----------------------------------------------------------------------------
// MARK: Animation Methods

- (void)pauseAnimation
{
    self.displayLink = nil;
    [(HeySubstrateView *)[self view] setMessage:NSLocalizedString(@"Paused", @"Paused")];
}


- (void)unpauseAnimation
{
    [(HeySubstrateView *)[self view] setMessage:nil];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
#if TARGET_OS_IPHONE
    [self.displayLink setFrameInterval:4];
#endif
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)startAnimation
{
    HeySubstrateView *v = (HeySubstrateView *)self.view;
    [v restartAnimation];
    [self unpauseAnimation];
}


- (void)stopAnimation
{
    self.displayLink = nil;
    HeySubstrateView *v = (HeySubstrateView *)self.view;
    [v stopAnimation];
}


- (void)drawView
{
    [self.view setNeedsDisplay];
}


@end


// End of HeySubstrateViewController.m
// =============================================================================
