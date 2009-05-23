// =============================================================================
/*
  HeySubstrateAppDelegate.m
  SubstrateiPhone Project

  UIApplication Delegate

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateAppDelegate.h"
#import "HeySubstrateView.h"
#import "HeySubstrateViewController.h"
#import "HeySettingsTableViewController.h"


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
  [settingsNC release];
  [settingsTVC release];
  [substrateVC release];
  [window release];
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UIApplicationDelegate Methods

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
  [window addSubview:substrateVC.view];
  [window makeKeyAndVisible];
}


// -----------------------------------------------------------------------------
// MARK: View Switching

- (void)showSettings
{
  // Stop the substrate animation.
  [substrateVC stopAnimation];
  [substrateVC.view removeFromSuperview];
  
  // Get current settings (the substrate view has them).
  HeySubstrateOptions o;
  [((HeySubstrateView *)substrateVC.view) getOptions:&o];
  [self setOptions:&o];

  // Lazy-load the settings classes.
  if (settingsNC == nil)
    self.settingsNC = [[UINavigationController alloc] init];
  if (settingsTVC == nil)
    self.settingsTVC = [[HeySettingsTableViewController alloc] init];
  
  // Put the settings table view in the navigation controller.
  [settingsNC pushViewController:settingsTVC animated:NO];

  // Make the settings visible.
  [window addSubview:settingsNC.view];
  [window makeKeyAndVisible];
  //[window layoutSubviews];
}

- (void)showSubstrate
{
  // Pass the settings to the view (and disk).
  [(HeySubstrateView *)substrateVC.view setOptions:&appOptions];
  
  // Perform the actual switching of view on the next event loop (or so).
//  [self performSelector:@selector(reallyShowSubstrateNow:) withObject:self afterDelay:0.0];
  [self performSelector:@selector(reallyShowSubstrateNow:) withObject:self afterDelay:0.001];
}


- (void)reallyShowSubstrateNow:(id)obj
{
  (void)obj;
  // Remove and release the settings classes.
  [self.settingsNC.view removeFromSuperview];
  self.settingsNC = nil;
  self.settingsTVC = nil;
  
  // Make the pretty view visible again.
  [window addSubview:substrateVC.view];
  [window makeKeyAndVisible];
  [window layoutSubviews];
  [substrateVC startAnimation];
}


@end


// End of HeySubstrateAppDelegate.m
// =============================================================================
