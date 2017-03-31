//
//  SWAcapellaPrefs.m
//  Acapella3
//
//  Created by Pat Sluth on 2015-12-27.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWAcapellaPrefs.h"

#import "Sluthware/SWPrefs.h"





@interface SWAcapellaPrefs()
{
}

#pragma mark -

@property (strong, nonatomic) SWPrefs *prefs;

@property (strong, nonatomic, readwrite) NSString *keyPrefix;

// In same order as the preference pane layout :P
@property (nonatomic, readwrite) BOOL enabled;

#pragma mark Gestures

@property (strong, nonatomic, readwrite) NSString *gestures_tapleft;
@property (strong, nonatomic, readwrite) NSString *gestures_tapcentre;
@property (strong, nonatomic, readwrite) NSString *gestures_tapright;
@property (strong, nonatomic, readwrite) NSString *gestures_swipeleft;
@property (strong, nonatomic, readwrite) NSString *gestures_swiperight;
@property (strong, nonatomic, readwrite) NSString *gestures_pressleft;
@property (strong, nonatomic, readwrite) NSString *gestures_presscentre;
@property (strong, nonatomic, readwrite) NSString *gestures_pressright;

#pragma mark UI(Progress Slider)

@property (nonatomic, readwrite) BOOL progressslider;

#pragma mark UI(Transport)

@property (nonatomic, readwrite) BOOL transport_heart;
@property (nonatomic, readwrite) BOOL transport_upnext;
@property (nonatomic, readwrite) BOOL transport_previoustrack;
@property (nonatomic, readwrite) BOOL transport_nexttrack;
@property (nonatomic, readwrite) BOOL transport_intervalrewind;
@property (nonatomic, readwrite) BOOL transport_intervalforward;
@property (nonatomic, readwrite) BOOL transport_playpause;
@property (nonatomic, readwrite) BOOL transport_share;
@property (nonatomic, readwrite) BOOL transport_shuffle;
@property (nonatomic, readwrite) BOOL transport_repeat;
@property (nonatomic, readwrite) BOOL transport_contextual;
@property (nonatomic, readwrite) BOOL transport_playbackrate; // podcast
@property (nonatomic, readwrite) BOOL transport_sleeptimer; // podcast

#pragma mark UI(Volume Slider)

@property (nonatomic, readwrite) BOOL volumeslider;

#pragma mark -

@end





@implementation SWAcapellaPrefs

#pragma mark - Init

- (id)initWithKeyPrefix:(NSString *)keyPrefix
{
	NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/AcapellaPrefs3.bundle"];
	NSString *preferencePath = @"/var/mobile/Library/Preferences/com.patsluth.acapella3.plist";
	NSString *defaultsPath = [bundle pathForResource:@"prefsDefaults" ofType:@".plist"];
	
    if (self == [super init]) {
        
        self.prefs = [[%c(SWPrefs) alloc] initWithPreferenceFilePath:preferencePath
                                                        defaultsPath:defaultsPath
                                                         application:@"com.patsluth.acapella3"];
        
        self.keyPrefix = keyPrefix;
		[self refreshPrefs];
        
    }
	
    return self;
}

/**
 *  Initialize to defaults
 */
- (void)initialize
{
#pragma mark -
    
    self.enabled = NO;
    
#pragma mark Gestures
    
    self.gestures_tapleft = @"";
    self.gestures_tapcentre = @"";
    self.gestures_tapright = @"";
    self.gestures_swipeleft = @"";
    self.gestures_swiperight = @"";
    self.gestures_pressleft = @"";
    self.gestures_presscentre = @"";
    self.gestures_pressright = @"";
    
#pragma mark UI(Progress Slider)
    
    self.progressslider = YES;
    
#pragma mark UI(Transport)
    
    self.transport_heart = YES;
    self.transport_upnext = YES;
    self.transport_previoustrack = YES;
    self.transport_nexttrack = YES;
    self.transport_intervalrewind = YES;
    self.transport_intervalforward = YES;
    self.transport_playpause = YES;
    self.transport_share = YES;
    self.transport_shuffle = YES;
    self.transport_repeat = YES;
    self.transport_contextual = YES;
    
#pragma mark UI(Volume Slider)
    
    self.volumeslider = YES;
    
#pragma mark -
    
}

#pragma mark - SWPrefs

- (void)refreshPrefs
{
	[self.prefs refreshPrefs];
	
    #pragma mark - Initialize Keys
    
    NSString *enabledKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"enabled"];
    
    #pragma mark Gestures
    
    NSString *gestures_tapleftKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_tapleft"];
    NSString *gestures_tapcentreKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_tapcentre"];
    NSString *gestures_taprightKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_tapright"];
    NSString *gestures_swipeleftKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_swipeleft"];
    NSString *gestures_swiperightKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_swiperight"];
    NSString *gestures_pressleftKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_pressleft"];
    NSString *gestures_presscentreKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_presscentre"];
    NSString *gestures_pressrightKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"gestures_pressright"];
    
    #pragma mark UI(Progress Slider)
    
    NSString *progresssliderKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"progressslider"];
    
    #pragma mark UI(Transport)
    
    NSString *transport_heartKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_heart"];
    NSString *transport_upnextKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_upnext"];
    NSString *transport_previoustrackKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_previoustrack"];
    NSString *transport_nexttrackKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_nexttrack"];
    NSString *transport_intervalrewindKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_intervalrewind"];
    NSString *transport_intervalforwardKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_intervalforward"];
    NSString *transport_playpauseKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_playpause"];
    NSString *transport_shareKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_share"];
    NSString *transport_shuffleKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_shuffle"];
    NSString *transport_repeatKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_repeat"];
    NSString *transport_contextualKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_contextual"];
    NSString *transport_playbackrateKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_playbackrate"];
    NSString *transport_sleeptimerKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"transport_sleeptimer"];
    
    #pragma mark UI(Volume Slider)
    
    NSString *volumesliderKey = [NSString stringWithFormat:@"acapella3_%@_%@", self.keyPrefix, @"volumeslider"];
    
    
    
    
    
    #pragma mark - Load Values For Keys
    
    self.enabled = [[self.prefs.preferences valueForKey:enabledKey] boolValue];
    
    #pragma mark Gestures
    
    self.gestures_tapleft = [self.prefs.preferences valueForKey:gestures_tapleftKey];
    self.gestures_tapcentre = [self.prefs.preferences valueForKey:gestures_tapcentreKey];
    self.gestures_tapright = [self.prefs.preferences valueForKey:gestures_taprightKey];
    self.gestures_swipeleft = [self.prefs.preferences valueForKey:gestures_swipeleftKey];
    self.gestures_swiperight = [self.prefs.preferences valueForKey:gestures_swiperightKey];
    self.gestures_pressleft = [self.prefs.preferences valueForKey:gestures_pressleftKey];
    self.gestures_presscentre = [self.prefs.preferences valueForKey:gestures_presscentreKey];
    self.gestures_pressright = [self.prefs.preferences valueForKey:gestures_pressrightKey];
    
    #pragma mark UI(Progress Slider)
    
    self.progressslider = [[self.prefs.preferences valueForKey:progresssliderKey] boolValue];
    
    #pragma mark UI(Transport)
    
    self.transport_heart = [[self.prefs.preferences valueForKey:transport_heartKey] boolValue];
    self.transport_upnext = [[self.prefs.preferences valueForKey:transport_upnextKey] boolValue];
    self.transport_previoustrack = [[self.prefs.preferences valueForKey:transport_previoustrackKey] boolValue];
    self.transport_nexttrack = [[self.prefs.preferences valueForKey:transport_nexttrackKey] boolValue];
    self.transport_intervalrewind = [[self.prefs.preferences valueForKey:transport_intervalrewindKey] boolValue];
    self.transport_intervalforward = [[self.prefs.preferences valueForKey:transport_intervalforwardKey] boolValue];
    self.transport_playpause = [[self.prefs.preferences valueForKey:transport_playpauseKey] boolValue];
    self.transport_share = [[self.prefs.preferences valueForKey:transport_shareKey] boolValue];
    self.transport_shuffle = [[self.prefs.preferences valueForKey:transport_shuffleKey] boolValue];
    self.transport_repeat = [[self.prefs.preferences valueForKey:transport_repeatKey] boolValue];
    self.transport_contextual = [[self.prefs.preferences valueForKey:transport_contextualKey] boolValue];
    self.transport_playbackrate = [[self.prefs.preferences valueForKey:transport_playbackrateKey] boolValue];
    self.transport_sleeptimer = [[self.prefs.preferences valueForKey:transport_sleeptimerKey] boolValue];
    
    #pragma mark UI(Volume Slider)
    
    self.volumeslider = [[self.prefs.preferences valueForKey:volumesliderKey] boolValue];
    
    #pragma mark -
    
}

@end




