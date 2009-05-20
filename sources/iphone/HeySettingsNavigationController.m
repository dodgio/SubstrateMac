// =============================================================================
/*
  HeySettingsNavigationController.m
  SubstrateiPhone Project

  Top level view controller for settings.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySettingsNavigationController.h"
#import "HeySettingsTableViewController.h"


@implementation HeySettingsNavigationController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Build programmatically, no nib.
- (void)loadView 
{
  setCon = [[HeySettingsTableViewController alloc] init];
  [self pushViewController:setCon animated:YES];
}



- (void)viewDidLoad 
{
  [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc 
{
  [setCon release];
  [super dealloc];
}


@end


// End of HeySettingsNavigationController.m
// =============================================================================
