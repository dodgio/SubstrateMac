// =============================================================================
/*
  HeySubstrateAppDelegate.h
  SubstrateiPhone Project

  UIApplication Delegate

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"

@class HeySubstrateViewController;


@interface HeySubstrateAppDelegate : NSObject <UIApplicationDelegate> 
{
  UIWindow *window;
  HeySubstrateViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HeySubstrateViewController *viewController;

@end


// End of HeySubstrateAppDelegate.h
// =============================================================================
