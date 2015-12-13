#import "../Common.h"
#import <objc/runtime.h>

static BOOL tweakEnabled;

static void toggle()
{
	BOOL enabled = [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] objectForKey:[enabledPrefixKey stringByAppendingString:NSBundle.mainBundle.bundleIdentifier]] boolValue];
	if (enabled && tweakEnabled)
		[[objc_getClass("FLEXManager") sharedManager] showExplorer];
	else
		[[objc_getClass("FLEXManager") sharedManager] hideExplorer];
}

%hook DKFLEXLoader

- (void)appLaunched:(id)arg1
{
	%orig;
	toggle();
}

%end

static void PreferencesChanged()
{
	tweakEnabled = [[[NSDictionary dictionaryWithContentsOfFile:M_PLIST_PATH] objectForKey:tweakEnabledKey] boolValue];
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
			BOOL isExtension = [executablePath rangeOfString:@"appex"].location != NSNotFound;
			if ((isSpringBoard || isApp) && !isExtension) {
				if (dlopen("/Library/Application Support/FLEXible/com.shmoopillc.flexible.bundle/FLEX.dylib", RTLD_LAZY)) {
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, kFLEXibleNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
					tweakEnabled = [[[NSDictionary dictionaryWithContentsOfFile:M_PLIST_PATH] objectForKey:tweakEnabledKey] boolValue];
					%init;
				}
			}
		}
	}
}