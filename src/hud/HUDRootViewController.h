#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUDRootViewController: UIViewController
- (void)resetLoopTimer;
- (void)pauseLoopTimer;
- (void)resumeLoopTimer;
- (void)reloadUserDefaults;
@end

NS_ASSUME_NONNULL_END