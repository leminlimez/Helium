#import <UIKit/UIKit.h>
#import "../helpers/private_headers/UIApplicationRotationFollowingControllerNoTouches.h"

NS_ASSUME_NONNULL_BEGIN

@interface HUDRootViewController: UIApplicationRotationFollowingControllerNoTouches
+ (BOOL)passthroughMode;
- (void)resetLoopTimer;
- (void)pauseLoopTimer;
- (void)resumeLoopTimer;
- (void)reloadUserDefaults;
// - (void)createWidgetSets;
@end

NS_ASSUME_NONNULL_END