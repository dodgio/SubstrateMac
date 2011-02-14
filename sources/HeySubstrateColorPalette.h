
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


    HeySubstrateColorPalette.h
    SubstrateMac/SubstrateiPhone Projects

    Handle color palette for sand drawing.

    Copyright (c) Hey Daddio! 2011.
*/
// -----------------------------------------------------------------------------


#import "HeySubstrate.h"


@interface HeySubstrateColorPalette : NSObject 
{
  @protected
    NSMutableArray *heyColors_;
}
// MARK: Properties
@property (nonatomic, retain) NSArray *heyColors;

// MARK: Lifecycle
- (id)init;
- (void)dealloc;


// MARK: Instance Methods
- (HEYCOLOR *)randomColor;
- (void)sampleImage:(CGImageRef)anImageRef;



@end


// End of HeySubstrateColorPalette.h
// =============================================================================


