//
//  MainApplication.mm
//
//
//  Created by lemin on 10/4/23.
//

#import <notify.h>
#import <UIKit/UIKit.h>
#import "XXTAssistiveTouch-Swift.h"

OBJC_EXTERN BOOL IsHUDEnabled(void);
OBJC_EXTERN void SetHUDEnabled(BOOL isEnabled);


#pragma mark - MainApplication

@interface MainApplication : UIApplication
@end

@implementation MainApplication

- (instancetype)init
{
    self = [super init];
    if (self)
    {
#if DEBUG
        /* Force HIDTransformer to print logs */
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogTouch" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogGesture" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogEventDispatch" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogGestureEnvironment" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogGestureExclusion" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogSystemGestureUpdate" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogGesturePerformance" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"LogHIDTransformer" inDomain:@"com.apple.UIKit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
#endif
    }
    return self;
}

@end

#pragma mark - RootViewController

@interface MainButton : UIButton
@end

@implementation MainButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted)
    {
        [UIView animateWithDuration:0.27 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.transform = CGAffineTransformMakeScale(0.92, 0.92);
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.27 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

@end

@interface RootViewController : UIViewController <TSSettingsControllerDelegate>
@end

@implementation RootViewController {
    NSMutableDictionary *_userDefaults;
    MainButton *_mainButton;
    UILabel *_authorLabel;
}

- (void) loadView
{
    CGRect bounds = UIScreen.mainScreen.bounds;
    self.view = [[UIView alloc] initWithFrame:bounds];
    
    // rgba(0, 4, 128, 1.0)
    // MARK: Background
    self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:4.0f/255.0f blue:128.0f/255.0f alpha:1.0f];
    
    // MARK: Init Safe Area
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    // MARK: Main Button
    _mainButton = [MainButton buttonWithType:UIButtonTypeSystem];
    [_mainButton setTintColor:[UIColor whiteColor]];
    [_mainButton addTarget:self action:@selector(tapMainButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonConfiguration *config = [UIButtonConfiguration tintedButtonConfiguration];
    [config setTitleTextAttributesTransformer:^NSDictionary <NSAttributedStringKey, id> * _Nonnull(NSDictionary <NSAttributedStringKey, id> * _Nonnull textAttributes) {
        NSMutableDictionary *newAttributes = [textAttributes mutableCopy];
        [newAttributes setObject:[UIFont boldSystemFontOfSize:32.0] forKey:NSFontAttributeName];
        return newAttributes;
    }];
    [config setCornerStyle:UIButtonConfigurationCornerStyleLarge];
    [_mainButton setConfiguration:config];
    
    [self.view addSubview:_mainButton];

    [_mainButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [_mainButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_mainButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
    
    // MARK: Author Label
    _authorLabel = [[UILabel alloc] init];
    [_authorLabel setNumberOfLines:0];
    [_authorLabel setTextAlignment:NSTextAlignmentCenter];
    [_authorLabel setTextColor:[UIColor whiteColor]];
    [_authorLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_authorLabel sizeToFit];
    [self.view addSubview:_authorLabel];
    
    [_authorLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [_authorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_authorLabel.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-40.0f],
    ]];
    
    [self reloadMainButtonState];
}

#define USER_DEFAULTS_PATH @"/var/mobile/Library/Preferences/com.leemin.helium.plist"

- (void)loadUserDefaults:(BOOL)forceReload
{
    if (forceReload || !_userDefaults)
        _userDefaults = [[NSDictionary dictionaryWithContentsOfFile:USER_DEFAULTS_PATH] mutableCopy] ?: [NSMutableDictionary dictionary];
}

- (void)saveUserDefaults
{
    [_userDefaults writeToFile:USER_DEFAULTS_PATH atomically:YES];
    notify_post(NOTIFY_RELOAD_HUD);
}

- (NSInteger)selectedMode
{
    [self loadUserDefaults:NO];
    NSNumber *mode = [_userDefaults objectForKey:@"selectedMode"];
    return mode ? [mode integerValue] : 1;
}

- (void)setSelectedMode:(NSInteger)selectedMode
{
    [self loadUserDefaults:NO];
    [_userDefaults setObject:@(selectedMode) forKey:@"selectedMode"];
    [self saveUserDefaults];
}

- (BOOL)usesLargeFont
{
    [self loadUserDefaults:NO];
    NSNumber *mode = [_userDefaults objectForKey:@"usesLargeFont"];
    return mode ? [mode boolValue] : NO;
}

- (void)setUsesLargeFont:(BOOL)usesLargeFont
{
    [self loadUserDefaults:NO];
    [_userDefaults setObject:@(usesLargeFont) forKey:@"usesLargeFont"];
    [self saveUserDefaults];
}

- (BOOL)usesRotation
{
    [self loadUserDefaults:NO];
    NSNumber *mode = [_userDefaults objectForKey:@"usesRotation"];
    return mode ? [mode boolValue] : NO;
}

- (void)setUsesRotation:(BOOL)usesRotation
{
    [self loadUserDefaults:NO];
    [_userDefaults setObject:@(usesRotation) forKey:@"usesRotation"];
    [self saveUserDefaults];
}

- (void)reloadMainButtonState
{
    [UIView transitionWithView:self.view duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [_mainButton setTitle:(IsHUDEnabled() ? NSLocalizedString(@"Exit HUD", nil) : NSLocalizedString(@"Open HUD", nil)) forState:UIControlStateNormal];
        [_authorLabel setText:(IsHUDEnabled() ? NSLocalizedString(@"You can quit this app now.\nThe HUD will persist on your screen.", nil) : NSLocalizedString(@"Made with ♥ by lemin\nBig thanks to @i_82 and @jmpews", nil))];
    } completion:nil];
}

- (BOOL)settingHighlightedWithKey:(NSString * _Nonnull)key
{
    [self loadUserDefaults:NO];
    NSNumber *mode = [_userDefaults objectForKey:key];
    return mode ? [mode boolValue] : NO;
}

- (void)settingDidSelectWithKey:(NSString * _Nonnull)key
{
    BOOL highlighted = [self settingHighlightedWithKey:key];
    [_userDefaults setObject:@(!highlighted) forKey:key];
    [self saveUserDefaults];
}

- (void)tapMainButton:(UIButton *)sender
{
    os_log_debug(OS_LOG_DEFAULT, "- [RootViewController tapMainButton:%{public}@]", sender);

    BOOL isNowEnabled = IsHUDEnabled();
    SetHUDEnabled(!isNowEnabled);
    isNowEnabled = !isNowEnabled;

    if (isNowEnabled)
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        int token;
        notify_register_dispatch(NOTIFY_LAUNCHED_HUD, &token, dispatch_get_main_queue(), ^(int token) {
            notify_cancel(token);
            dispatch_semaphore_signal(semaphore);
        });

        [self.view setUserInteractionEnabled:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            int timedOut = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)));
            dispatch_async(dispatch_get_main_queue(), ^{
                if (timedOut)
                    os_log_error(OS_LOG_DEFAULT, "Timed out waiting for HUD to launch");
                
                [self reloadMainButtonState];
                [self.view setUserInteractionEnabled:YES];
            });
        });
    }
    else
    {
        [self.view setUserInteractionEnabled:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadMainButtonState];
            [self.view setUserInteractionEnabled:YES];
        });
    }
}

@end

#pragma mark - MainApplicationDelegate

@interface MainApplicationDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation MainApplicationDelegate {
    RootViewController *_rootViewController;
}

- (instancetype)init {
    if (self = [super init]) {
        os_log_debug(OS_LOG_DEFAULT, "- [MainApplicationDelegate init]");
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary <UIApplicationLaunchOptionsKey, id> *)launchOptions {
    os_log_debug(OS_LOG_DEFAULT, "- [MainApplicationDelegate application:%{public}@ didFinishLaunchingWithOptions:%{public}@]", application, launchOptions);
    
    _rootViewController = [[RootViewController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:_rootViewController];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
