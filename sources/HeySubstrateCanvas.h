// =============================================================================
/*
  HeySubstrateCanvas.h
  SubstrateMac/SubstrateiPhone Projects

  Canvas drawing abstraction class.

  Copyright (c) Hey Daddio! 2009. All rights reserved.
*/
// -----------------------------------------------------------------------------

#import "HeySubstrate.h"


@interface HeySubstrateCanvas : NSObject 
{
 @private
  HeySubstrateOptions opts;
  HEYVIEW *ssView;
  CGSize size;

  NSMutableArray *crackArray; // Array of Cracks
  int currNumCracks;          // Current number of Cracks in crackArray
  int maxNumCracks;           // Maximum number of Cracks allowed in crackArray
  BOOL bgCleared;             // Flag, has view background been cleared?
  int iterationsDone;         // Counter for crack-drawing iterations
  BOOL drawingPaused;         // Are we currently paused between drawings?
  int framesToPause;          // How many animation frames to pause
  int framesPaused;           // Counter for pause between drawings
  
  int viewWidth;              // Dimensions of view
  int viewHeight;             // Dimensions of view
  int *crackAngleGrid;        // Array/Grid of cracks, one per pixel
  
}




@end


// End of HeySubstrateCanvas.h
// =============================================================================
