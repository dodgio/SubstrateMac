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


    HeySubstrateAppDelegate.m
    SubstrateiPhone Project

    UIApplication Delegate

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateAppDelegate.h"
#import "HeySubstrateView.h"
#import "HeySubstrateViewController.h"
#import "HeySettingsTableViewController.h"


// -----------------------------------------------------------------------------
// MARK: Constants

static const NSTimeInterval HeySubstrateViewTransitionTime = 0.5f;


// -----------------------------------------------------------------------------
// MARK: Private Category

@interface HeySubstrateAppDelegate ()

- (void)reallyShowSubstrateNow:(id)obj;

@end


// -----------------------------------------------------------------------------
// MARK: HeySubstrateAppDelegate

@implementation HeySubstrateAppDelegate


// -----------------------------------------------------------------------------
// MARK: Properties

@synthesize window;
@synthesize substrateVC;
@synthesize settingsNC;
@synthesize settingsTVC;


// Pseudo property.
- (void)getOptions:(HeySubstrateOptions *)options
{
    options->numberOfCracks         = appOptions.numberOfCracks;
    options->speedOfCracking        = appOptions.speedOfCracking;
    options->amountOfSand           = appOptions.amountOfSand;
    options->densityOfDrawing       = appOptions.densityOfDrawing;
    options->pauseBetweenDrawings   = appOptions.pauseBetweenDrawings;
    options->percentCurves          = appOptions.percentCurves;
    options->drawCracksOnly         = appOptions.drawCracksOnly;
}


- (void)setOptions:(HeySubstrateOptions *)options
{
    appOptions.numberOfCracks       = options->numberOfCracks;
    appOptions.speedOfCracking      = options->speedOfCracking;
    appOptions.amountOfSand         = options->amountOfSand;
    appOptions.densityOfDrawing     = options->densityOfDrawing; 
    appOptions.pauseBetweenDrawings = options->pauseBetweenDrawings;
    appOptions.percentCurves        = options->percentCurves;
    appOptions.drawCracksOnly       = options->drawCracksOnly;
}


// -----------------------------------------------------------------------------
// MARK: Init and dealloc

- (void)dealloc 
{
    [settingsNC release], settingsNC = nil;
    [settingsTVC release], settingsTVC = nil;
    [substrateVC release], substrateVC = nil;
    [window release], window = nil;
    
    [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UIApplicationDelegate Methods

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    (void)application;
    [window addSubview:substrateVC.view];
    [window makeKeyAndVisible];
}


// -----------------------------------------------------------------------------
// MARK: View Switching

// Put up the settings view.
- (void)showSettings
{
    // Get current settings (the substrate view has them).
    HeySubstrateOptions o;
    [((HeySubstrateView *)substrateVC.view) getOptions:&o];
    [self setOptions:&o];
    
    // Lazy-load the settings classes.
    if (settingsNC == nil)
    {
        self.settingsNC = [[UINavigationController alloc] init];
        self.settingsTVC = [[HeySettingsTableViewController alloc] init];
        [settingsNC pushViewController:settingsTVC animated:YES];
    }
    
    // Stop the substrate animation.
    [substrateVC stopAnimation];
    
    // Make the settings visible.
    [window addSubview:settingsNC.view];
    [window makeKeyAndVisible];
    
    // Use explicit animation.
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:HeySubstrateViewTransitionTime];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[window layer] addAnimation:animation forKey:kCATransition];
}


// Prepare to put up the substrate display.
- (void)showSubstrate
{
    // Pass the settings to the view (and disk).
    [(HeySubstrateView *)substrateVC.view setOptions:&appOptions];
    
    // Perform the actual switching of view on the next event loop (or so).
    [self performSelector:@selector(reallyShowSubstrateNow:) withObject:self afterDelay:0.001];
}


// Really put up the substrate display.
- (void)reallyShowSubstrateNow:(id)obj
{
    (void)obj;
    [self.settingsNC.view removeFromSuperview];
    self.settingsNC = nil;
    self.settingsTVC = nil;
    
    // Make the pretty view visible again.
    [window addSubview:substrateVC.view];
    [window makeKeyAndVisible];
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:HeySubstrateViewTransitionTime];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[window layer] addAnimation:animation forKey:kCATransition];
    
    // Start the display animation again.
    [substrateVC startAnimation];
}


@end


// End of HeySubstrateAppDelegate.m
// =============================================================================
