#import "../PS.h"

@interface FLEXExplorerViewController : UIViewController
- (NSArray *)allWindows;
- (void)closeButtonTapped:(id)arg1;
@end

@interface FLEXManager : NSObject
+ (FLEXManager *)sharedManager;
- (FLEXExplorerViewController *)explorerViewController;
- (void)showExplorer;
- (void)hideExplorer;
@end

@interface DKFLEXLoader : NSObject
- (id)init;
- (void)appLaunched:(id)arg1;
@end

static NSString *nsDomainString = @"com.shmoopillc.flexible";
static NSString *tweakDomainString = @"com.flipswitch.shmoopillc.FLEXibleFS";
static NSString *enabledPrefixKey = @"FLEXibleEnabled-";
static NSString *tweakEnabledKey = @"FLEXibleEnabled";
static NSString *PLIST_PATH = @"/var/mobile/Library/Preferences/com.shmoopillc.flexible.plist";
static NSString *M_PLIST_PATH = @"/var/mobile/Library/Preferences/com.flipswitch.shmoopillc.FLEXibleFS.plist";
static CFStringRef kFLEXibleNotification = CFSTR("com.flipswitch.shmoopillc.FLEXibleFS/prefs");
//static NSString *switchIdentifier = @"com.shmoopillc.FLEXibleFS";
