#import <notify.h>
#import <objc/runtime.h>

#import "HUDRootViewController.h"
#import "AnyBackdropView.h"
#import "Helium-Swift.h"

#import "../widgets/WidgetManager.h"
#import "../extensions/UsefulFunctions.h"
#import "../extensions/FontUtils.h"
#import "../extensions/EZTimer.h"
#import "../extensions/WeatherUtils.h"

#import "../helpers/private_headers/CAFilter.h"
#import "../helpers/private_headers/FBSOrientationUpdate.h"
#import "../helpers/private_headers/FBSOrientationObserver.h"
#import "../helpers/private_headers/LSApplicationProxy.h"
#import "../helpers/private_headers/LSApplicationWorkspace.h"
#import "../helpers/private_headers/SpringBoardServices.h"
#import "../helpers/private_headers/UIApplication+Private.h"

#define NOTIFY_UI_LOCKSTATE    "com.apple.springboard.lockstate"
#define NOTIFY_LS_APP_CHANGED  "com.apple.LaunchServices.ApplicationsChanged"

static void LaunchServicesApplicationStateChanged
(CFNotificationCenterRef center,
 void *observer,
 CFStringRef name,
 const void *object,
 CFDictionaryRef userInfo)
{
    /* Application installed or uninstalled */

    BOOL isAppInstalled = NO;
    
    for (LSApplicationProxy *app in [[objc_getClass("LSApplicationWorkspace") defaultWorkspace] allApplications])
    {
        if ([app.applicationIdentifier isEqualToString:@"com.leemin.helium"])
        {
            isAppInstalled = YES;
            break;
        }
    }

    if (!isAppInstalled)
    {
        UIApplication *app = [UIApplication sharedApplication];
        [app terminateWithSuccess];
    }
}

static void SpringBoardLockStatusChanged
(CFNotificationCenterRef center,
 void *observer,
 CFStringRef name,
 const void *object,
 CFDictionaryRef userInfo)
{
    HUDRootViewController *rootViewController = (__bridge HUDRootViewController *)observer;
    NSString *lockState = (__bridge NSString *)name;
    if ([lockState isEqualToString:@NOTIFY_UI_LOCKSTATE])
    {
        mach_port_t sbsPort = SBSSpringBoardServerPort();
        
        if (sbsPort == MACH_PORT_NULL)
            return;
        
        BOOL isLocked;
        BOOL isPasscodeSet;
        SBGetScreenLockStatus(sbsPort, &isLocked, &isPasscodeSet);

        if (!isLocked)
        {
            [rootViewController.view setHidden:NO];
            [rootViewController resumeLoopTimer];
        }
        else
        {
            [rootViewController pauseLoopTimer];
            [rootViewController.view setHidden:YES];
        }
    }
}

static void ReloadHUD
(CFNotificationCenterRef center,
 void *observer,
 CFStringRef name,
 const void *object,
 CFDictionaryRef userInfo)
{
    // NSLog(@"boom ReloadHUD");
    HUDRootViewController *rootViewController = (__bridge HUDRootViewController *)observer;
    // [rootViewController createWidgetSets];
    [rootViewController reloadUserDefaults];
    [rootViewController resetLoopTimer];
    [rootViewController updateViewConstraints];
}

#pragma mark - HUDRootViewController

@implementation HUDRootViewController {
    NSMutableDictionary *_userDefaults;
    NSMutableArray <NSLayoutConstraint *> *_constraints;
    FBSOrientationObserver *_orientationObserver;
    // view object arrays
    NSMutableArray <UIVisualEffectView *> *_blurViews;
    NSMutableArray <UILabel *> *_labelViews;
    
    NSMutableArray <AnyBackdropView *> *_backdropViews;
    NSMutableArray <UILabel *> *_maskLabelViews;

    UIView *_contentView;
    
    UIInterfaceOrientation _orientation;
}

- (void)registerNotifications
{
    int token;
    notify_register_dispatch(NOTIFY_RELOAD_HUD, &token, dispatch_get_main_queue(), ^(int token) {
        [self reloadUserDefaults];
        [self resetLoopTimer];
        [self updateViewConstraints];
    });

    CFNotificationCenterRef darwinCenter = CFNotificationCenterGetDarwinNotifyCenter();
    
    CFNotificationCenterAddObserver(
        darwinCenter,
        (__bridge const void *)self,
        LaunchServicesApplicationStateChanged,
        CFSTR(NOTIFY_LS_APP_CHANGED),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );
    
    CFNotificationCenterAddObserver(
        darwinCenter,
        (__bridge const void *)self,
        SpringBoardLockStatusChanged,
        CFSTR(NOTIFY_UI_LOCKSTATE),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );

    CFNotificationCenterAddObserver(
        darwinCenter,
        (__bridge const void *)self,
        ReloadHUD,
        CFSTR(NOTIFY_RELOAD_HUD),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );
}


#pragma mark - User Default Stuff

- (void)loadUserDefaults:(BOOL)forceReload
{
    if (forceReload || !_userDefaults)
        _userDefaults = [[NSDictionary dictionaryWithContentsOfFile:USER_DEFAULTS_PATH] mutableCopy] ?: [NSMutableDictionary dictionary];
}

- (void) reloadUserDefaults
{
    [self loadUserDefaults: YES];
    
    if ([self debugBorder]) {
        _contentView.layer.borderWidth = 1.0;
    } else {
        _contentView.layer.borderWidth = 0.0;
    }

    NSArray *widgetProps = [self widgetProperties];
    for (int i = 0; i < [widgetProps count]; i++) {
        UIVisualEffectView *blurView = [_blurViews objectAtIndex:i];
        UILabel *labelView = [_labelViews objectAtIndex:i];
        AnyBackdropView *backdropView = [_backdropViews objectAtIndex: i];
        UILabel *maskLabelView = [_maskLabelViews objectAtIndex:i];

        NSDictionary *properties = [widgetProps objectAtIndex:i];
        NSInteger orientationMode = getIntFromDictKey(properties, @"orientationMode", 0);
        NSDictionary *blurDetails = [properties valueForKey:@"blurDetails"] ? [properties valueForKey:@"blurDetails"] : @{@"hasBlur" : @(NO)};
        UIBlurEffect *blurEffect = [
            UIBlurEffect effectWithStyle: getBoolFromDictKey(blurDetails, @"styleDark", true) ? UIBlurEffectStyleSystemMaterialDark : UIBlurEffectStyleSystemMaterialLight
        ];
        BOOL hasBlur = getBoolFromDictKey(blurDetails, @"hasBlur");
        NSInteger blurCornerRadius = getIntFromDictKey(blurDetails, @"cornerRadius", 4);
        double blurAlpha = getDoubleFromDictKey(blurDetails, @"alpha", 1.0);
        NSInteger textAlign = getIntFromDictKey(properties, @"textAlignment", 1);
        NSDictionary *colorDetails = [properties valueForKey:@"colorDetails"] ? [properties valueForKey:@"colorDetails"] : @{@"usesCustomColor" : @(NO)};
        BOOL usesCustomColor = getBoolFromDictKey(colorDetails, @"usesCustomColor");
        UIColor *textColor = [UIColor whiteColor];
        if (usesCustomColor && [colorDetails valueForKey:@"color"]) {
            NSData *customColorData = [colorDetails valueForKey:@"color"];
            textColor = [NSKeyedUnarchiver unarchiveObjectWithData:customColorData];
        }
        NSString *fontName = getStringFromDictKey(properties, @"fontName", @"System Font");
        UIFont *textFont = [FontUtils loadFontWithName:fontName size: getDoubleFromDictKey(properties, @"fontSize", 10) bold: getBoolFromDictKey(properties, @"textBold") italic: getBoolFromDictKey(properties, @"textItalic")];
        double textAlpha = getDoubleFromDictKey(properties, @"textAlpha", 1.0);
        BOOL dynamicColor = getBoolFromDictKey(properties, @"dynamicColor", true);
        
        labelView.textAlignment = textAlign;
        labelView.font = textFont;
        maskLabelView.textAlignment = textAlign;
        maskLabelView.font = textFont;
        maskLabelView.textColor = [UIColor whiteColor];

        if (dynamicColor) {
            [blurView setEffect:nil];
            [blurView setHidden:YES];
            [labelView setHidden:YES];
            [backdropView setHidden:NO];
            [maskLabelView setHidden:NO];
            maskLabelView.alpha = textAlpha;
        } else {
            labelView.textColor = textColor;
            labelView.alpha = textAlpha;
            [labelView setHidden:NO];
            [backdropView setHidden:YES];
            [maskLabelView setHidden:YES];
            if (hasBlur) {
                [blurView setEffect:blurEffect];
                [blurView setHidden:NO];
                blurView.layer.cornerRadius = blurCornerRadius;
                blurView.alpha = blurAlpha;
            } else {
                [blurView setEffect:nil];
                [blurView setHidden:YES];
            }
        }

        if ((orientationMode == 1 && [self isLandscapeOrientation])
            || (orientationMode == 2 && ![self isLandscapeOrientation])) {
            [blurView setHidden:YES];
            [labelView setHidden:YES];
            [backdropView setHidden:YES];
            [maskLabelView setHidden:YES];
        }

        if ([self debugBorder]) {
            labelView.layer.borderWidth = 1.0;
            // backdropView.layer.borderWidth = 1.0;
            maskLabelView.layer.borderWidth = 1.0;
        } else {
            labelView.layer.borderWidth = 0.0;
            // backdropView.layer.borderWidth = 0.0;
            maskLabelView.layer.borderWidth = 0.0;
        }
    }
}

- (BOOL) debugBorder
{
    [self loadUserDefaults:NO];
    NSNumber *mode = [_userDefaults objectForKey: @"debugBorder"];
    return mode ? [mode boolValue] : NO;
}

- (NSString*) apiKey
{
    [self loadUserDefaults:NO];
    NSString *apiKey = [_userDefaults objectForKey: @"apiKey"];
    return apiKey ? apiKey : @"";
}

- (NSString*) dateLocale
{
    [self loadUserDefaults:NO];
    NSString *locale = [_userDefaults objectForKey: @"dateLocale"];
    return locale ? locale : @"en_US";
}

- (NSArray*) widgetProperties
{
    [self loadUserDefaults: NO];
    NSArray *properties = [_userDefaults objectForKey: @"widgetProperties"];
    return properties;
}

- (BOOL)isLandscapeOrientation
{
    BOOL isLandscape;
    if (_orientation == UIInterfaceOrientationUnknown) {
        isLandscape = CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds);
    } else {
        isLandscape = UIInterfaceOrientationIsLandscape(_orientation);
    }
    return isLandscape;
}

#pragma mark - Initialization and Deallocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        // load fonts from app
        [FontUtils loadFontsFromFolder:[NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath],  @"/fonts"]];
        // load fonts from documents
        [FontUtils loadFontsFromFolder:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        _constraints = [NSMutableArray array];
        _blurViews = [NSMutableArray array];
        _labelViews = [NSMutableArray array];
        _backdropViews = [NSMutableArray array];
        _maskLabelViews = [NSMutableArray array];
        _orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
        __weak HUDRootViewController *weakSelf = self;
        [_orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
            HUDRootViewController *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateOrientation:(UIInterfaceOrientation)orientationUpdate.orientation animateWithDuration:orientationUpdate.duration];
            });
        }];
        [self registerNotifications];
    }
    return self;
}

- (void)dealloc
{
    [_orientationObserver invalidate];
}

#pragma mark - HUD UI Main Functions

- (void) viewDidLoad
{
    [super viewDidLoad];    
    // MARK: Main Content View
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.layer.borderColor = [UIColor redColor].CGColor;
    [_contentView setUserInteractionEnabled:YES];
    [self.view addSubview:_contentView];

    [self createWidgetSetsView];
    notify_post(NOTIFY_RELOAD_HUD);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    notify_post(NOTIFY_LAUNCHED_HUD);
}

#pragma mark - Timer and View Updating

- (void)resetLoopTimer
{
    NSArray *widgetProps = [self widgetProperties];
    for (int i = 0; i < [widgetProps count]; i++) {
        UIVisualEffectView *blurView = [_blurViews objectAtIndex:i];
        UILabel *labelView = [_labelViews objectAtIndex:i];
        AnyBackdropView *backdropView = [_backdropViews objectAtIndex: i];
        UILabel *maskLabelView = [_maskLabelViews objectAtIndex:i];

        NSDictionary *properties = [widgetProps objectAtIndex:i];
        if (!labelView || !maskLabelView || !properties)
            break;
        NSArray *identifiers = [properties objectForKey: @"widgetIDs"] ? [properties objectForKey: @"widgetIDs"] : @[];
        double fontSize = [properties objectForKey: @"fontSize"] ? [[properties objectForKey: @"fontSize"] doubleValue] : 10.0;
        double updateInterval = getDoubleFromDictKey(properties, @"updateInterval", 1.0);
        BOOL isEnabled = getBoolFromDictKey(properties, @"isEnabled");
        if (isEnabled) {
            [[EZTimer shareInstance] timer:[NSString stringWithFormat:@"labelview%d", i] timerInterval:updateInterval leeway:0.1 resumeType:EZTimerResumeTypeNow queue:EZTimerQueueTypeConcurrent queueName:@"update" repeats:YES action:^(NSString *timerName) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self updateLabel: labelView updateMaskLabel: maskLabelView backdropView: backdropView identifiers: identifiers fontSize: fontSize];
                    // NSLog(@"boom time:%@ count:%lu", timerName, [[[[EZTimer shareInstance] timers] allKeys] count]);
                });
            }];
        } else {
            [blurView setEffect:nil];
            [blurView setHidden:YES];
            [labelView setHidden:YES];
            [backdropView setHidden:YES];
            [maskLabelView setHidden:YES];
            [[EZTimer shareInstance] cancel:[NSString stringWithFormat:@"labelview%d", i]];
        }
    }
}

- (void) updateLabel:(UILabel *) label updateMaskLabel:(UILabel *) maskLabel backdropView:(AnyBackdropView *) backdropView identifiers:(NSArray *) identifiers fontSize:(double) fontSize
{
#if DEBUG
    os_log_debug(OS_LOG_DEFAULT, "updateLabel");
#endif
    NSAttributedString *attributedText = formattedAttributedString(identifiers, fontSize, label.textColor, [self apiKey], [self dateLocale]);
    if (attributedText) {
        // NSLog(@"boom attr:%@", attributedText);
        [label setAttributedText: attributedText];
        [maskLabel setAttributedText: attributedText];
        [maskLabel setFrame:backdropView.bounds];
    }
}

- (void)pauseLoopTimer
{
    NSArray *widgetProps = [self widgetProperties];
    for (int i = 0; i < [widgetProps count]; i++) {
        NSDictionary *properties = [widgetProps objectAtIndex:i];
        if (!getBoolFromDictKey(properties, @"isEnabled"))
            continue;
        [[EZTimer shareInstance] pause:[NSString stringWithFormat:@"labelview%d", i]];
    }
}

- (void)resumeLoopTimer
{
    NSArray *widgetProps = [self widgetProperties];
    for (int i = 0; i < [widgetProps count]; i++) {
        NSDictionary *properties = [widgetProps objectAtIndex:i];
        if (!getBoolFromDictKey(properties, @"isEnabled"))
            continue;
        [[EZTimer shareInstance] resume:[NSString stringWithFormat:@"labelview%d", i]];
    }
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (int i = 0; i < [_maskLabelViews count]; i++) {
        UILabel *maskLabel = [_maskLabelViews objectAtIndex: i];
        AnyBackdropView *backdropView = [_backdropViews objectAtIndex: i];
        if (maskLabel && backdropView) {
            [maskLabel setFrame: backdropView.bounds];
        }
    }
}

- (void)createWidgetSetsView
{
    // MARK: Create the Widgets
    // MIGHT NEED OPTIMIZATION
    for (NSDictionary *properties in [self widgetProperties]) {
        // create the blur
        NSDictionary *blurDetails = [properties valueForKey:@"blurDetails"] ? [properties valueForKey:@"blurDetails"] : @{@"hasBlur" : @(NO)};
        UIBlurEffect *blurEffect = [
            UIBlurEffect effectWithStyle: getBoolFromDictKey(blurDetails, @"styleDark", true) ? UIBlurEffectStyleSystemMaterialDark : UIBlurEffectStyleSystemMaterialLight
        ];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.layer.masksToBounds = YES;
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:blurView];
        [_blurViews addObject:blurView];
        // create the label
        UILabel *labelView = [[UILabel alloc] initWithFrame: CGRectZero];
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByClipping;
        labelView.translatesAutoresizingMaskIntoConstraints = NO;
        labelView.layer.borderColor = [UIColor redColor].CGColor;
        [labelView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [_contentView addSubview:labelView];
        [_labelViews addObject:labelView];

        // MARK: Adaptive Color Backdrop
        // create backdrop view
        AnyBackdropView *backdropView = [[AnyBackdropView alloc] init];
        backdropView.translatesAutoresizingMaskIntoConstraints = NO;
        backdropView.layer.borderColor = [UIColor redColor].CGColor;
        [_contentView addSubview:backdropView];
        [_backdropViews addObject:backdropView];

        // create the mask label
        UILabel *maskLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        maskLabel.numberOfLines = 0;
        maskLabel.lineBreakMode = NSLineBreakByClipping;
        maskLabel.translatesAutoresizingMaskIntoConstraints = NO;
        maskLabel.layer.borderColor = [UIColor redColor].CGColor;
        // code from Lessica/TrollSpeed
        CAFilter *blurFilter = [CAFilter filterWithName:kCAFilterGaussianBlur];
        [blurFilter setValue:@(50.0) forKey:@"inputRadius"];  // radius 50pt
        [blurFilter setValue:@YES forKey:@"inputNormalizeEdges"];  // do not use inputHardEdges

        CAFilter *brightnessFilter = [CAFilter filterWithName:kCAFilterColorBrightness];
        [brightnessFilter setValue:@(-0.285) forKey:@"inputAmount"];  // -28.5%

        CAFilter *contrastFilter = [CAFilter filterWithName:kCAFilterColorContrast];
        [contrastFilter setValue:@(1000.0) forKey:@"inputAmount"];   // 1000x

        CAFilter *saturateFilter = [CAFilter filterWithName:kCAFilterColorSaturate];
        [saturateFilter setValue:@(0.0) forKey:@"inputAmount"];

        CAFilter *colorInvertFilter = [CAFilter filterWithName:kCAFilterColorInvert];

        [backdropView.layer setFilters:@[
            blurFilter, brightnessFilter, contrastFilter,
            saturateFilter, colorInvertFilter,
        ]];
        [maskLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        
        [backdropView setMaskView:maskLabel];
        [_maskLabelViews addObject:maskLabel];
    }
}

- (void)updateViewConstraints
{
    [NSLayoutConstraint deactivateConstraints:_constraints];
    [_constraints removeAllObjects];

    BOOL isPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    UILayoutGuide *layoutGuide = self.view.safeAreaLayoutGuide;
    
    // code from Lessica/TrollSpeed
    if ([self isLandscapeOrientation])
    {
        CGFloat notchHeight;
        CGFloat paddingNearNotch;
        CGFloat paddingFarFromNotch;

        notchHeight = CGRectGetMinY(layoutGuide.layoutFrame);
        paddingNearNotch = (notchHeight > 30) ? notchHeight - 16 : 4;
        paddingFarFromNotch = (notchHeight > 30) ? -24 : -4;

        [_constraints addObjectsFromArray:@[
            [_contentView.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor constant:(_orientation == UIInterfaceOrientationLandscapeLeft ? -paddingFarFromNotch : paddingNearNotch)],
            [_contentView.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor constant:(_orientation == UIInterfaceOrientationLandscapeLeft ? -paddingNearNotch : paddingFarFromNotch)],
        ]];

        CGFloat minimumLandscapeTopConstant = 0;
        CGFloat minimumLandscapeBottomConstant = 0;

        minimumLandscapeTopConstant = (isPad ? 30 : 10);
        minimumLandscapeBottomConstant = (isPad ? -34 : -14);

        /* Fixed Constraints */
        [_constraints addObjectsFromArray:@[
            [_contentView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:minimumLandscapeTopConstant],
            [_contentView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor constant:minimumLandscapeBottomConstant],
        ]];

        /* Flexible Constraint */
        NSLayoutConstraint *_topConstraint = [_contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:minimumLandscapeTopConstant];
        _topConstraint.priority = UILayoutPriorityDefaultLow;

        [_constraints addObject:_topConstraint];
    }
    else
    {
        [_constraints addObjectsFromArray:@[
            [_contentView.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor],
            [_contentView.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor],
        ]];

        CGFloat minimumTopConstraintConstant = 0;
        CGFloat minimumBottomConstraintConstant = 0;

        if (CGRectGetMinY(layoutGuide.layoutFrame) >= 51) {
            minimumTopConstraintConstant = -8;
            minimumBottomConstraintConstant = -4;
        } else if (CGRectGetMinY(layoutGuide.layoutFrame) > 30) {
            minimumTopConstraintConstant = -12;
            minimumBottomConstraintConstant = -4;
        } else {
            minimumTopConstraintConstant = (isPad ? 30 : 20);
            minimumBottomConstraintConstant = -20;
        }

        /* Fixed Constraints */
        [_constraints addObjectsFromArray:@[
            [_contentView.topAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.topAnchor constant:minimumTopConstraintConstant],
            [_contentView.bottomAnchor constraintLessThanOrEqualToAnchor:layoutGuide.bottomAnchor constant:minimumBottomConstraintConstant],
        ]];

        /* Flexible Constraint */
        NSLayoutConstraint *_topConstraint = [_contentView.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor constant:minimumTopConstraintConstant];
        _topConstraint.priority = UILayoutPriorityDefaultLow;

        [_constraints addObject:_topConstraint];
    }

    // MARK: Set Label Constraints
    NSArray *widgetProps = [self widgetProperties];
    // DEFINITELY NEEDS OPTIMIZATION
    for (int i = 0; i < [widgetProps count]; i++) {
        UIVisualEffectView *blurView = [_blurViews objectAtIndex:i];
        UILabel *labelView = [_labelViews objectAtIndex:i];
        AnyBackdropView *backdropView = [_backdropViews objectAtIndex: i];
        // UILabel *maskLabelView = [_maskLabelViews objectAtIndex:i];
        NSDictionary *properties = [widgetProps objectAtIndex:i];
        if (!blurView || !labelView || !properties)
            break;
        if (!getBoolFromDictKey(properties, @"isEnabled"))
            continue;
        double offsetX = getDoubleFromDictKey(properties, @"offsetX", 10);
        double offsetY = getDoubleFromDictKey(properties, @"offsetY");
        NSInteger anchorSide = getIntFromDictKey(properties, @"anchor");
        NSInteger anchorYSide = getIntFromDictKey(properties, @"anchorY");
        // set the vertical anchor
        if (anchorYSide == 1) {
            [_constraints addObject:[labelView.centerYAnchor constraintEqualToAnchor:_contentView.centerYAnchor constant: offsetY]];
        } else if (anchorYSide == 0) {
            [_constraints addObject:[labelView.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant: offsetY]];
        } else {
            [_constraints addObject:[labelView.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor constant: offsetY]];
        }
        // set the horizontal anchor
        if (anchorSide == 1) {
            [_constraints addObject:[labelView.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor constant: offsetX]];
        } else if (anchorSide == 0) {
            [_constraints addObject:[labelView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor constant: offsetX]];
        } else {
            [_constraints addObject:[labelView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor constant: -offsetX]];
        }

        // set the width
        if (!getBoolFromDictKey(properties, @"autoResizes")) {
            [_constraints addObject:[labelView.widthAnchor constraintEqualToConstant:getDoubleFromDictKey(properties, @"scale", 50.0)]];
            [_constraints addObject:[labelView.heightAnchor constraintEqualToConstant:getDoubleFromDictKey(properties, @"scaleY", 12.0)]];
        }
        
        [_constraints addObjectsFromArray:@[
            [backdropView.topAnchor constraintEqualToAnchor:blurView.topAnchor],
            [backdropView.leadingAnchor constraintEqualToAnchor:blurView.leadingAnchor],
            [backdropView.trailingAnchor constraintEqualToAnchor:blurView.trailingAnchor],
            [backdropView.bottomAnchor constraintEqualToAnchor:blurView.bottomAnchor],
        ]];
        
        [_constraints addObjectsFromArray:@[
            [blurView.topAnchor constraintEqualToAnchor:labelView.topAnchor constant:-2],
            [blurView.leadingAnchor constraintEqualToAnchor:labelView.leadingAnchor constant:-4],
            [blurView.trailingAnchor constraintEqualToAnchor:labelView.trailingAnchor constant:4],
            [blurView.bottomAnchor constraintEqualToAnchor:labelView.bottomAnchor constant:2],
        ]];
    }
    
    [NSLayoutConstraint activateConstraints:_constraints];
    [super updateViewConstraints];
}

static inline CGFloat orientationAngle(UIInterfaceOrientation orientation)
{
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            return M_PI;
        case UIInterfaceOrientationLandscapeLeft:
            return -M_PI_2;
        case UIInterfaceOrientationLandscapeRight:
            return M_PI_2;
        default:
            return 0;
    }
}

static inline CGRect orientationBounds(UIInterfaceOrientation orientation, CGRect bounds)
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return CGRectMake(0, 0, bounds.size.height, bounds.size.width);
        default:
            return bounds;
    }
}

- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration
{
    __weak typeof(self) weakSelf = self;
    NSArray *widgetProps = [weakSelf widgetProperties];
    for (int i = 0; i < [widgetProps count]; i++) {
        UIVisualEffectView *blurView = [_blurViews objectAtIndex:i];
        UILabel *labelView = [_labelViews objectAtIndex:i];
        AnyBackdropView *backdropView = [_backdropViews objectAtIndex: i];
        UILabel *maskLabelView = [_maskLabelViews objectAtIndex:i];

        NSDictionary *properties = [widgetProps objectAtIndex:i];
        NSInteger orientationMode = getIntFromDictKey(properties, @"orientationMode", 0);
        BOOL isEnabled = getBoolFromDictKey(properties, @"isEnabled");
        BOOL dynamicColor = getBoolFromDictKey(properties, @"dynamicColor", true);
        if (isEnabled) {
            switch (orientationMode) {
                // Portrait
                case 1: {
                    if (UIInterfaceOrientationIsLandscape(orientation)) {
                        [blurView setHidden:YES];
                        [labelView setHidden:YES];
                        [backdropView setHidden:YES];
                        [maskLabelView setHidden:YES];
                    } else {
                        if (dynamicColor) {
                            [backdropView setHidden:NO];
                            [maskLabelView setHidden:NO];
                        } else {
                            [blurView setHidden:NO];
                            [labelView setHidden:NO];
                        }
                    }
                }break;
                // Landscape
                case 2: {
                    if (UIInterfaceOrientationIsLandscape(orientation)) {
                        if (dynamicColor) {
                            [backdropView setHidden:NO];
                            [maskLabelView setHidden:NO];
                        } else {
                            [blurView setHidden:NO];
                            [labelView setHidden:NO];
                        }
                    } else {
                        [blurView setHidden:YES];
                        [labelView setHidden:YES];
                        [backdropView setHidden:YES];
                        [maskLabelView setHidden:YES];
                    }
                }break;
            }
        }
    }

    if (orientation == _orientation) {
        return;
    }

    _orientation = orientation;

    CGRect bounds = orientationBounds(orientation, [UIScreen mainScreen].bounds);
    [self.view setNeedsUpdateConstraints];
    [self.view setHidden:YES];
    [self.view setBounds:bounds];

    [UIView animateWithDuration:duration animations:^{
        [weakSelf.view setTransform:CGAffineTransformMakeRotation(orientationAngle(orientation))];
    } completion:^(BOOL finished) {
        [weakSelf.view setHidden:NO];
    }];
}

@end
