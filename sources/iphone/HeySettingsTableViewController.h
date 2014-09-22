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


    HeySettingsTableViewController.h
    SubstrateiPhone Project

    All the settings.

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"


// -----------------------------------------------------------------------------
// MARK: Enums

enum HeySubstrateSettingsEnum 
{
    HeySubstrateSettingsSectionCracks = 0,
    HeySubstrateSettingsSectionSand = 1,
    HeySubstrateSettingsSectionDrawings = 2,
    HeySubstrateSettingsSectionHelp = 3,
    HeySubstrateSettingsSectionAbout = 4,
    
    HeySubstrateSettingsRowCracksNumber = 0,
    HeySubstrateSettingsRowCracksSpeed = 1,
    HeySubstrateSettingsRowCracksCurved = 2,
    HeySubstrateSettingsRowCracksOnly = 3,
    HeySubstrateSettingsRowSandAmount = 0,
    HeySubstrateSettingsRowSandColors = 1,
    HeySubstrateSettingsRowSandColorsClear = 2,
    HeySubstrateSettingsRowDrawingsDensity = 0,
    HeySubstrateSettingsRowDrawingsPause = 1,
    HeySubstrateSettingsRowHelpInfo = 0,
    HeySubstrateSettingsRowAboutInfo = 0,
    HeySubstrateSettingsRowAboutVisit = 1
};


// -----------------------------------------------------------------------------
// MARK: HeySettingsTableViewController

@interface HeySettingsTableViewController : UITableViewController 
    <UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
  @private
    HeySubstrateOptions opts;
    UIImagePickerController *imagePicker;
    
    // For iPad
    //UIPopoverController *imagePickerPopover;
    id imagePickerPopover;
    BOOL hasImagePickerMessageBeenShown;
}


// UIScrollViewDelegate ???




@end

// End of HeySettingsTableViewController.h
// =============================================================================
