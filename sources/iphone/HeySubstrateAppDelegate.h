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
@class HeySettingsNavigationController;
@class HeySettingsTableViewController;


@interface HeySubstrateAppDelegate : NSObject <UIApplicationDelegate> 
{
  UIWindow *window;
  HeySubstrateViewController *viewController;
  HeySettingsNavigationController *settingsNavController;
  HeySettingsTableViewController *settingsController;
  HeySubstrateOptions appOptions;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HeySubstrateViewController *viewController;
@property (nonatomic, retain) IBOutlet HeySettingsNavigationController *settingsNavController;
@property (nonatomic, retain) IBOutlet HeySettingsTableViewController *settingsController;
// pseudo property
- (HeySubstrateOptions *)options;
- (void)setOptions:(HeySubstrateOptions *)options;


- (void)showSettings;


@end


// End of HeySubstrateAppDelegate.h
// =============================================================================
