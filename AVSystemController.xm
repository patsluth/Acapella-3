//
//  AVSystemController.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

#import "AVSystemController+SW.h"
#import "UIApplication+SW.h"

#import "Sluthware/Sluthware.h"






%hook AVSystemController

%new
+ (void)acapellaChangeVolume:(long)direction
{
	TRY
	
	AVSystemController *avSystemController = [%c(AVSystemController) sharedAVSystemController];
	
	if (avSystemController){ //0.0625 = 1 / 16 (number of squares in iOS HUD)
		[[UIApplication sharedApplication] setSystemVolumeHUDEnabled:NO forAudioCategory:AUDIO_VIDEO_CATEGORY];
		[avSystemController changeVolumeBy:0.0625 * direction forCategory:AUDIO_VIDEO_CATEGORY];
	}
	
	CATCH_LOG
	TRY_END
}

%end




