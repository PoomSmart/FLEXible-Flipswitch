#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>
#import "Common.h"
#import <objc/runtime.h>

@interface FLEXibleFSSwitch : NSObject <FSSwitchDataSource>
@end

@implementation FLEXibleFSSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:tweakEnabledKey inDomain:tweakDomainString];
	return [n boolValue] ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	BOOL enabled = newState == FSSwitchStateOn;
	[[NSUserDefaults standardUserDefaults] setObject:@(enabled) forKey:tweakEnabledKey inDomain:tweakDomainString];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), kFLEXibleNotification, nil, nil, YES);
}

@end
