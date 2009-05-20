// =============================================================================
/*
  HeySettingsTableViewController.m
  SubstrateiPhone Project

  All the settings.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySettingsTableViewController.h"
#import "HeySubstrateAppDelegate.h"



@implementation HeySettingsTableViewController


- (id)init
{
  if ((self = [super initWithStyle:UITableViewStyleGrouped]))
  {
    self.title = @"Settings";
    HeySubstrateOptions *options = [(HeySubstrateAppDelegate *)[[UIApplication sharedApplication] delegate] options];
    opts.numberOfCracks       = options->numberOfCracks;
    opts.speedOfCracking      = options->speedOfCracking;
    opts.amountOfSand         = options->amountOfSand;
    opts.densityOfDrawing     = options->densityOfDrawing; 
    opts.pauseBetweenDrawings = options->pauseBetweenDrawings;
    opts.percentCurves        = options->percentCurves;
    opts.drawCracksOnly       = options->drawCracksOnly;
  }
  return self;
}

- (void)loadView
{
  [super loadView]; // ????
}

- (void)didReceiveMemoryWarning 
{
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc 
{
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UITableViewDelegate Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) 
  {
    case 0:
      return 4;
      break;
    case 1:
      return 1;
      break;
    case 2:
      return 2;
      break;
    case 3:
      return 1;
      break;
    default:
      return 0;
      break;
  }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) 
  {
    case 0:
      return @"Cracks";
      break;
    case 1:
      return @"Sand";
      break;
    case 2:
      return @"Drawings";
      break;
    case 3:
      return @"About";
      break;
    default:
      return @"";
      break;
  }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = [NSString stringWithFormat:@"%d:%d", [indexPath indexAtPosition:0], [indexPath indexAtPosition:1]];
  
  CGRect sliderRect = CGRectMake(170.0f, 0.0f, 125.0f, 50.0f);
  CGRect switchRect = CGRectMake(200.0f, 10.0f, 0.0f, 0.0f);
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil)
  {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch ([indexPath indexAtPosition:0]) 
    {
      case 0:                       // "Cracks" section.
        switch ([indexPath indexAtPosition:1]) 
        {
          case 0:                       // Number slider.
          {  
            UISlider *numberSlider = [[UISlider alloc] initWithFrame:sliderRect];
            numberSlider.minimumValue = 1.0f;
            numberSlider.maximumValue = 100.0f;
            numberSlider.value = opts.numberOfCracks;
            numberSlider.tag = 0;
            numberSlider.continuous = YES;
            [numberSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:numberSlider];
            cell.text = @"Number of Cracks:";
            [numberSlider release];
          }
          break;
          case 1:                       // Speed slider.
          {
            UISlider *speedSlider = [[UISlider alloc] initWithFrame:sliderRect];
            speedSlider.minimumValue = 1.0f;
            speedSlider.maximumValue = 10.0f;
            speedSlider.value = opts.speedOfCracking;
            speedSlider.tag = 1;
            speedSlider.continuous = YES;
            [speedSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:speedSlider];
            cell.text = @"Speed of Cracking:";
            [speedSlider release];
          }
          break;
          case 2:                       // Percent curved slider.
          {
            UISlider *curvedSlider = [[UISlider alloc] initWithFrame:sliderRect];
            curvedSlider.minimumValue = 0.0f;
            curvedSlider.maximumValue = 100.0f;
            curvedSlider.value = opts.percentCurves;
            curvedSlider.tag = 2;
            curvedSlider.continuous = YES;
            [curvedSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:curvedSlider];
            cell.text = @"Percentage of Curved Cracks:";
            [curvedSlider release];
          }
          break;
          case 3:                       // Cracks only switch.
          {
            UISwitch *onlySwitch = [[UISwitch alloc] initWithFrame:switchRect];
            onlySwitch.on = opts.drawCracksOnly;
            onlySwitch.tag = 3;
            [onlySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:onlySwitch];
            cell.text = @"Draw Cracks Only";
            [onlySwitch release];
          }
          break;
          default:
          break;
        }
        break;
      case 1:                       // "Sand" section.
        switch ([indexPath indexAtPosition:1]) 
        {
          case 0:                       // Amount slider.
          {
            UISlider *sandSlider = [[UISlider alloc] initWithFrame:sliderRect];
            sandSlider.minimumValue = -0.1f;
            sandSlider.maximumValue = 0.0f;
            sandSlider.value = opts.amountOfSand;
            sandSlider.tag = 4;
            sandSlider.continuous = YES;
            [sandSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:sandSlider];
            cell.text = @"Amount of Sand:";
            [sandSlider release];
          }
          break;
          default:
            break;
        }
        break;
      case 2:                       // "Drawings" section.
        switch ([indexPath indexAtPosition:1]) 
        {
          case 0:                       // Density slider.
          {
            UISlider *densitySlider = [[UISlider alloc] initWithFrame:sliderRect];
            densitySlider.minimumValue = 5000.0f;
            densitySlider.maximumValue = 1000000.0f;
            densitySlider.value = opts.densityOfDrawing;
            densitySlider.tag = 5;
            densitySlider.continuous = YES;
            [densitySlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:densitySlider];
            cell.text = @"Density of Drawing:";
            [densitySlider release];
          }
          break;
          case 1:                       // Pause between slider.
          {
            UISlider *pauseSlider = [[UISlider alloc] initWithFrame:sliderRect];
            pauseSlider.minimumValue = 0.0f;
            pauseSlider.maximumValue = 120.0f;
            pauseSlider.value = opts.pauseBetweenDrawings;
            pauseSlider.tag = 6;
            pauseSlider.continuous = YES;
            [pauseSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:pauseSlider];
            cell.text = @"Pause Between Drawings:";
            [pauseSlider release];
          }
          break;
          default:
            break;
        }
        break;
      case 3:                       // "About" section.
        switch ([indexPath indexAtPosition:1]) 
        {
          case 0:                       // About info.
          {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:sliderRect];
            tempLabel.text = @"This is the about info.";
            [cell addSubview:tempLabel];
            [tempLabel release];
          }
          break;
          default:
            break;
        }
        break;
      default:
        break;
    }
  }
  return cell;
}


- (void)sliderAction:(UISlider *)sender
{
  switch ([sender tag]) 
  {
    case 0:                             // Number slider.
      opts.numberOfCracks = [sender value];
      break;
    case 1:                             // Speed slider.
      opts.speedOfCracking = [sender value];
      break;
    case 2:                             // Percent curved slider.
      opts.percentCurves = [sender value];
      break;
    case 4:                             // Amount slider.
      opts.amountOfSand = [sender value];
      break;
    case 5:                             // Density slider.
      opts.densityOfDrawing = [sender value];
      break;
    case 6:                             // Pause between slider.
      opts.pauseBetweenDrawings = [sender value];  
      break;
    default:
      break;
  }
}

- (void)switchAction:(UISwitch *)sender
{
  switch ([sender tag]) 
  {
    case 3:                             // Cracks only switch.
      opts.drawCracksOnly = sender.on;
      break;
    default:
      break;
  }
}







/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



@end

// End of HeySettingsTableViewController.m
// =============================================================================
