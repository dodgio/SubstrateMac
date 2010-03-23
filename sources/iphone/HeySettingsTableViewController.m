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


    HeySettingsTableViewController.m
    SubstrateiPhone Project

    All the settings.

    Copyright (c) Hey Daddio! 2009.
*/
// -----------------------------------------------------------------------------

#import "HeySettingsTableViewController.h"
#import "HeySubstrateAppDelegate.h"
#import "HeySubstrateView.h"


// -----------------------------------------------------------------------------
// MARK: Constants

static const CGFloat uitvcHeightDefault = 44.0f;
static const CGFloat uitvcHeightAboutInfo = 320.0f;
static const CGFloat uitvcHeightAboutVisit = 70.0f;

static const int aboutInfoTag = 343;
static const int aboutVisitTag = 344;
          
          
// -----------------------------------------------------------------------------
// MARK: -
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
// MARK: Actions

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


- (void)heydaddioAction:(UIButton *)sender
{
    (void)sender;
    [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"http://www.heydaddio.com/"] afterDelay:0.25f];
}


- (void)doneAction:(UIBarButtonItem *)sender
{
    (void)sender;
    HeySubstrateAppDelegate *appDelegate;
    appDelegate = (HeySubstrateAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setOptions:&opts];       // Save settings to app delegate.
    //NSLog(@"Settings: NoOfCracks=%f Speed=%f Sand=%f Density=%f Pause=%f %%Curves=%f CracksOnly=%d", opts.numberOfCracks, opts.speedOfCracking, opts.amountOfSand, opts.densityOfDrawing, opts.pauseBetweenDrawings, opts.percentCurves, opts.drawCracksOnly);
    [appDelegate showSubstrate];
}


// -----------------------------------------------------------------------------
// MARK: -
// MARK: UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    (void)tableView;
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    (void)tableView;
    switch (section) 
    {
      case HeySubstrateSettingsSectionCracks:
          return @"Cracks";
          break;
      case HeySubstrateSettingsSectionSand:
          return @"Sand";
          break;
      case HeySubstrateSettingsSectionDrawings:
          return @"Drawings";
          break;
      case HeySubstrateSettingsSectionAbout:
          return @"About";
          break;
      default:
          return @"";
          break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    (void)tableView;
    switch (section) 
    {
      case HeySubstrateSettingsSectionCracks:
          return 4;
          break;
      case HeySubstrateSettingsSectionSand:
          return 1;
          break;
      case HeySubstrateSettingsSectionDrawings:
          return 2;
          break;
      case HeySubstrateSettingsSectionAbout:
          return 2;
          break;
      default:
          return 0;
          break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d:%d", [indexPath indexAtPosition:0], [indexPath indexAtPosition:1]];
    
    CGRect sliderRect;
    CGRect switchRect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        sliderRect = CGRectMake(180.0f, 0.0f, 525.0f, 50.0f);
        switchRect = CGRectMake(180.0f, 10.0f, 0.0f, 0.0f);
    }
    else    // UIUserInterfaceIdiomPhone
    {
        sliderRect = CGRectMake(120.0f, 0.0f, 175.0f, 50.0f);
        switchRect = CGRectMake(200.0f, 10.0f, 0.0f, 0.0f);
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch ([indexPath indexAtPosition:0]) 
        {
            case HeySubstrateSettingsSectionCracks:
            {
                switch ([indexPath indexAtPosition:1]) 
                {
                    case HeySubstrateSettingsRowCracksNumber:
                    {  
                        UISlider *numberSlider = [[UISlider alloc] initWithFrame:sliderRect];
                        numberSlider.minimumValue = 1.0f;
                        //numberSlider.maximumValue = 100.0f;
                        numberSlider.maximumValue = 25.0f;   // 7.0f
                        numberSlider.value = opts.numberOfCracks;
                        numberSlider.tag = 0;
                        numberSlider.continuous = YES;
                        [numberSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:numberSlider];
                        [cell.textLabel setText:@"Number:"];
                        [numberSlider release];
                        break;
                    }
                    case HeySubstrateSettingsRowCracksSpeed:
                    {
                        UISlider *speedSlider = [[UISlider alloc] initWithFrame:sliderRect];
                        speedSlider.minimumValue = 1.0f;
                        //speedSlider.maximumValue = 10.0f;
                        speedSlider.maximumValue = 10.0f;    // 10.0f
                        speedSlider.value = opts.speedOfCracking;
                        speedSlider.tag = 1;
                        speedSlider.continuous = YES;
                        [speedSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:speedSlider];
                        [cell.textLabel setText:@"Speed:"];
                        [speedSlider release];
                        break;
                    }
                    case HeySubstrateSettingsRowCracksCurved:
                    {
                        UISlider *curvedSlider = [[UISlider alloc] initWithFrame:sliderRect];
                        curvedSlider.minimumValue = 0.0f;
                        curvedSlider.maximumValue = 100.0f;
                        curvedSlider.value = opts.percentCurves;
                        curvedSlider.tag = 2;
                        curvedSlider.continuous = YES;
                        [curvedSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:curvedSlider];
                        [cell.textLabel setText:@"Curved:"];
                        [curvedSlider release];
                        break;
                    }
                    case HeySubstrateSettingsRowCracksOnly:
                    {
                        UISwitch *onlySwitch = [[UISwitch alloc] initWithFrame:switchRect];
                        onlySwitch.on = opts.drawCracksOnly;
                        onlySwitch.tag = 3;
                        [onlySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:onlySwitch];
                        [cell.textLabel setText:@"Cracks Only:"];
                        [onlySwitch release];
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                break;
            }
            case HeySubstrateSettingsSectionSand:
            {
                switch ([indexPath indexAtPosition:1]) 
                {
                    case HeySubstrateSettingsRowSandAmount:
                    {
                        UISlider *sandSlider = [[UISlider alloc] initWithFrame:sliderRect];
                        sandSlider.minimumValue = -0.1f;
                        sandSlider.maximumValue = 0.0f;
                        sandSlider.value = opts.amountOfSand;
                        sandSlider.tag = 4;
                        sandSlider.continuous = YES;
                        [sandSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:sandSlider];
                        [cell.textLabel setText:@"Amount:"];
                        [sandSlider release];
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                break;
            }
            case HeySubstrateSettingsSectionDrawings:
            {
                switch ([indexPath indexAtPosition:1]) 
                {
                    case HeySubstrateSettingsRowDrawingsDensity:
                    {
                        UISlider *densitySlider = [[UISlider alloc] initWithFrame:sliderRect];
                        //densitySlider.minimumValue = 5000.0f;
                        //densitySlider.maximumValue = 1000000.0f;
                        densitySlider.minimumValue = 5000.0f;
                        densitySlider.maximumValue = 300000.0f;
                        densitySlider.value = opts.densityOfDrawing;
                        densitySlider.tag = 5;
                        densitySlider.continuous = YES;
                        [densitySlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:densitySlider];
                        [cell.textLabel setText:@"Density:"];
                        [densitySlider release];
                        break;
                    }
                    case HeySubstrateSettingsRowDrawingsPause:
                    {
                        UISlider *pauseSlider = [[UISlider alloc] initWithFrame:sliderRect];
                        pauseSlider.minimumValue = 0.0f;
                        //pauseSlider.maximumValue = 120.0f;
                        pauseSlider.maximumValue = 30.0f;
                        pauseSlider.value = opts.pauseBetweenDrawings;
                        pauseSlider.tag = 6;
                        pauseSlider.continuous = YES;
                        [pauseSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:pauseSlider];
                        [cell.textLabel setText:@"Pause:"];
                        [pauseSlider release];
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                break;
            }
            case HeySubstrateSettingsSectionAbout:
            {
                switch ([indexPath indexAtPosition:1]) 
                {
                    case HeySubstrateSettingsRowAboutInfo:
                    {
                        UIImage *image = [UIImage imageNamed:@"Credits.png"];
                        CGRect imgFrame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
                        UIImageView *iv = [[[UIImageView alloc] initWithFrame:imgFrame] autorelease];  // This frame's origin is temporary, see tableView:willDisplayCell:forRowAtIndex:
                        iv.tag = aboutInfoTag;
                        iv.image = image;
                        [cell addSubview:iv];   // Note: NOT [cell.contentView addSubview:iv]
                        cell.backgroundColor = [UIColor whiteColor];
                        break;
                    }
                    case HeySubstrateSettingsRowAboutVisit:
                    {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        // Height of cell has not been changed from default yet. Must manually adjust.
                        CGRect rWork = cell.bounds;
                        rWork.size.height = uitvcHeightAboutVisit;
                        [button setFrame:CGRectInset(rWork, 20.0f, 10.0f)];
                        UIImage *bNormal = [UIImage imageNamed:@"whiteButton.png"];
                        UIImage *stretchNormal = [bNormal stretchableImageWithLeftCapWidth:12 topCapHeight:12];
                        [button setBackgroundImage:stretchNormal forState:UIControlStateNormal];
                        UIImage *highlighted = [UIImage imageNamed:@"blueButton.png"];
                        UIImage *stretchHighlighted = [highlighted stretchableImageWithLeftCapWidth:12 topCapHeight:12];
                        [button setBackgroundImage:stretchHighlighted forState:UIControlStateHighlighted];
                        [button setTitle:@"Visit Hey Daddio Website" forState:UIControlStateNormal];
                        button.tag = aboutVisitTag;
                        [button addTarget:self action:@selector(heydaddioAction:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:button];
                        cell.backgroundColor = [UIColor whiteColor];
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                break;
            }
            default:
            {
                break;
            }
        }
    }
    return cell;
}


// -----------------------------------------------------------------------------
// MARK: -
// MARK: UITableViewDelegate Protocol Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    (void)tableView;
    CGFloat height = uitvcHeightDefault;
    
    switch ([indexPath indexAtPosition:0]) 
    {
        case HeySubstrateSettingsSectionAbout:
        {
            switch ([indexPath indexAtPosition:1])
            {
                case HeySubstrateSettingsRowAboutInfo:
                {
                    height = uitvcHeightAboutInfo;
                    break;
                }
                case HeySubstrateSettingsRowAboutVisit:
                {
                    height = uitvcHeightAboutVisit;
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        default:
        {
            break;
        }
    }
    return height;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    (void)tableView;
    
    switch ([indexPath indexAtPosition:0])
    {
        case HeySubstrateSettingsSectionAbout:
        {
            switch ([indexPath indexAtPosition:1])
            {
                case HeySubstrateSettingsRowAboutInfo:
                {
                    // Determine correct frame for imageview.
                    UIImageView *iv = (UIImageView *)[cell viewWithTag:aboutInfoTag];
                    CGRect oldFrame = iv.frame;
                    CGRect cellFrame = cell.bounds;
                    CGFloat newImageOriginX = floorf((cellFrame.size.width / 2.0f) - (oldFrame.size.width / 2.0f));
                    CGFloat newImageOriginY = oldFrame.origin.y + 10.0f;
                    CGRect newFrame = CGRectMake(newImageOriginX, newImageOriginY, oldFrame.size.width, oldFrame.size.height);
                    [iv setFrame:newFrame];
                    break;
                }
                case HeySubstrateSettingsRowAboutVisit:
                {
                    UIButton *button = (UIButton *)[cell viewWithTag:aboutVisitTag];
                    CGRect rWork = cell.bounds;
                    CGFloat xInset = rWork.size.width / 10.0f;
                    rWork.size.height = uitvcHeightAboutVisit;
                    [button setFrame:CGRectInset(rWork, xInset, 10.0f)];
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        default:
        {
            break;
        }
    }
}


@end


// End of HeySettingsTableViewController.m
// =============================================================================
