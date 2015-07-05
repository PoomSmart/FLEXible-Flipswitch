#import "../../Common.h"
#import <objc/runtime.h>

static BOOL tweakEnabled;

static void toggle()
{
	BOOL enabled = [[[NSUserDefaults standardUserDefaults] objectForKey:[enabledPrefixKey stringByAppendingString:NSBundle.mainBundle.bundleIdentifier] inDomain:nsDomainString] boolValue];
	if (enabled && tweakEnabled)
		[[objc_getClass("FLEXManager") sharedManager] showExplorer];
	else
		[[objc_getClass("FLEXManager") sharedManager] hideExplorer];
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
	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	NSUInteger count = args.count;
	if (count != 0) {
		NSString *executablePath = args[0];
		if (executablePath) {
			NSString *processName = [executablePath lastPathComponent];
			BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
			BOOL isApp = [executablePath rangeOfString:@"/Application"].location != NSNotFound;
			if (isSpringBoard || isApp) {
				if (dlopen("/Library/Application Support/FLEXible/com.shmoopillc.flexible.bundle/FLEX.dylib", RTLD_LAZY)) {
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, kFLEXibleNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
					tweakEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:tweakEnabledKey inDomain:tweakDomainString] boolValue];
					%init;
				}
			}
		}
	}
}
