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


// -----------------------------------------------------------------------------
// MARK: HeySubstrateAppDelegate

@implementation HeySubstrateAppDelegate


// -----------------------------------------------------------------------------
// MARK: Properties

@synthesize window;
@synthesize viewController;


// -----------------------------------------------------------------------------
// MARK: Init and dealloc

- (void)dealloc 
{
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


@end


// End of HeySubstrateAppDelegate.m
// =============================================================================
