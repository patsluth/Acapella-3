//
//  SWAcapella.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//





%ctor
{
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/Frameworks/Sluthware.framework"];
//    if (!bundle.isLoaded) {
        NSError *error = nil;
        [bundle loadAndReturnError:&error];
        if (error) {
            NSLog(@"Error loading Sluthware.framework %@", error);
        } else {
            NSLog(@"Loaded Sluthware.framework");
        }
//    }
    
//    void *sluthware_library = dlopen("/Library/Frameworks/Sluthware.framework/Sluthware", RTLD_NOW);
//    if (sluthware_library == NULL) {
//        NSLog(@"Sluthware.framework PAT NO ctor");
//     } else {
//         NSLog(@"Sluthware.framework PAT YES ctor");
//     }
}




