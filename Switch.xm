#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>
#import "Common.h"

@interface FLEXibleFSSwitch : NSObject <FSSwitchDataSource>
@end

@implementation FLEXibleFSSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return [[[NSDictionary dictionaryWithContentsOfFile:M_PLIST_PATH] objectForKey:tweakEnabledKey] boolValue] ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	BOOL enabled = newState == FSSwitchStateOn;
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	[d addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:M_PLIST_PATH]];
	[d setObject:@(enabled) forKey:tweakEnabledKey];
	[d writeToFile:M_PLIST_PATH atomically:YES];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), kFLEXibleNotification, nil, nil, YES);
}

@end