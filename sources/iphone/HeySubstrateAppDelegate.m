// =============================================================================
/*
  HeySubstrateAppDelegate.m
  SubstrateiPhone Project

  UIApplication Delegate

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrateAppDelegate.h"
#import "HeySubstrateViewController.h"
#import "HeySettingsNavigationController.h"
#import "HeySettingsTableViewController.h"


// -----------------------------------------------------------------------------
// MARK: HeySubstrateAppDelegate

@implementation HeySubstrateAppDelegate


// -----------------------------------------------------------------------------
// MARK: Properties

@synthesize window;
@synthesize viewController;
@synthesize settingsNavController;
@synthesize settingsController;


// pseudo property
- (HeySubstrateOptions *)options
{
  return &appOptions;
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
  [settingsController release];
  [settingsNavController release];
  [viewController release];
  [window release];
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UIApplicationDelegate Methods

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
}


// -----------------------------------------------------------------------------
// MARK: View switching

- (void)showSettings
{
  [viewController stopAnimation];
  [viewController.view removeFromSuperview];
  if (settingsNavController == nil)
    self.settingsNavController = [[HeySettingsNavigationController alloc] init];
  [window addSubview:settingsNavController.view];
  [window makeKeyAndVisible];
}



@end


// End of HeySubstrateAppDelegate.m
// =============================================================================
