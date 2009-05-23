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
#import "HeySubstrateView.h"


// -----------------------------------------------------------------------------
// MARK: HeySettingsTableViewController

@implementation HeySettingsTableViewController


// -----------------------------------------------------------------------------
// MARK: Init and Dealloc

- (id)init
{
  if ((self = [super initWithStyle:UITableViewStyleGrouped]))
  {
    self.title = @"Settings";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    [((HeySubstrateAppDelegate *)[UIApplication sharedApplication].delegate) getOptions:&opts];
  }
  return self;
}


- (void)dealloc 
{
  [super dealloc];
}


// -----------------------------------------------------------------------------
// MARK: UITableViewController Methods

//- (void)loadView
//{
//  [super loadView]; // ????
//}


//- (void)didReceiveMemoryWarning 
//{
//  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
//}


// -----------------------------------------------------------------------------
// MARK: UITableViewDelegate Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 4;
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
            cell.text = @"Number:";
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
            cell.text = @"Speed:";
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
            cell.text = @"% Curved:";
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
            cell.text = @"Amount:";
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
            cell.text = @"Density:";
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
            cell.text = @"Pause Between:";
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


- (void)doneAction:(UIBarButtonItem *)sender
{
  HeySubstrateAppDelegate *appDelegate;
  appDelegate = (HeySubstrateAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate setOptions:&opts];       // Save settings to app delegate.
  [appDelegate showSubstrate];
}


@end


// End of HeySettingsTableViewController.m
// =============================================================================
