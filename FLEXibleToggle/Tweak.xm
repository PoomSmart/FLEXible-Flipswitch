#import "../../Common.h"
#import <objc/runtime.h>

static BOOL tweakEnabled;

static void toggle()
{
	if (!tweakEnabled)
		[[objc_getClass("FLEXManager") sharedManager] hideExplorer];
	else
		[[objc_getClass("FLEXManager") sharedManager] showExplorer];
}

%hook FLEXDylib

- (void)appLaunched:(id)arg1
{
	%orig;
	toggle();
}

%end

static void PreferencesChanged()
{
	tweakEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:tweakEnabledKey inDomain:tweakDomainString] boolValue];
	toggle();
}

%ctor
{
	if (dlopen("/Library/Application Support/FLEXible/com.shmoopillc.flexible.bundle/FLEX.dylib", RTLD_LAZY)) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, kFLEXibleNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
		tweakEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:tweakEnabledKey inDomain:tweakDomainString] boolValue];
		%init;
	}
}