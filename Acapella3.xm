//
//  SWAcapella.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

#include <dlfcn.h>





%ctor
{
	NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/Frameworks/Sluthware.framework"];
	NSError *error = nil;
	[bundle loadAndReturnError:&error];
	
	if (error && !bundle.isLoaded) {
		NSLog(@"Error loading Sluthware.framework %@", error);
	} else {
		NSLog(@"Loaded Sluthware.framework");
	}
	
//	if (!bundle.isLoaded) {
//		
//		void *sluthware_library = dlopen("/Library/Frameworks/Sluthware.framework/Sluthware", RTLD_NOW);
//		
//		if (sluthware_library == NULL) {
//			NSLog(@"Error loading Sluthware.framework %@", error);
//		} else {
//			NSLog(@"Loaded Sluthware.framework");
//		}
//	}
}




