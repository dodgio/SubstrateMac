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
@class HeySettingsTableViewController;


@interface HeySubstrateAppDelegate : NSObject <UIApplicationDelegate> 
{
 @private
  UIWindow *window;
  HeySubstrateViewController *substrateVC;
  UINavigationController *settingsNC;
  HeySettingsTableViewController *settingsTVC;
  HeySubstrateOptions appOptions;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HeySubstrateViewController *substrateVC;
@property (nonatomic, retain) IBOutlet UINavigationController *settingsNC;
@property (nonatomic, retain) IBOutlet HeySettingsTableViewController *settingsTVC;

// Pseudo property.
- (void)getOptions:(HeySubstrateOptions *)options;
- (void)setOptions:(HeySubstrateOptions *)options;

// Choose view to show.
- (void)showSettings;
- (void)showSubstrate;

@end


// End of HeySubstrateAppDelegate.h
// =============================================================================
