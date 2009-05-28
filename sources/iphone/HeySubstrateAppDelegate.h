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


    HeySubstrateAppDelegate.h
    SubstrateiPhone Project

    UIApplication Delegate

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"

@class HeySubstrateViewController;
@class HeySettingsTableViewController;


// -----------------------------------------------------------------------------
// MARK: HeySubstrateAppDelegate

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
