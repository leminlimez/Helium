//
//  SwiftObjCPPBridger.m
//  
//
//  Created by lemin on 10/13/23.
//

#import "SwiftObjCPPBridger.h"


#pragma mark - HUD Functions

extern BOOL IsHUDEnabled(void);
extern void SetHUDEnabled(BOOL isEnabled);
extern void waitForNotification(void (^onFinish)(), BOOL isEnabled);

BOOL IsHUDEnabledBridger()
{
    return (int)IsHUDEnabled();
}

void SetHUDEnabledBridger(BOOL isEnabled)
{
    SetHUDEnabled(isEnabled);
}

void waitForNotificationBridger(void (^onFinish)(), BOOL isEnabled)
{
    waitForNotification(onFinish, isEnabled);
}


#pragma mark - Device Scale Functions

extern NSDictionary<NSString*, NSNumber*>* getMaxNumWidgets(void);

NSDictionary<NSString*, NSNumber*>* getMaxNumWidgetsBridger()
{
    return getMaxNumWidgets();
}

extern NSInteger getDeviceSize(void);
extern double getSideWidgetSize(void);
extern double getCenterWidgetSize(void);

NSInteger getDeviceSizeBridger()
{
    return getDeviceSize();
}

double getSideWidgetSizeBridger()
{
    return getSideWidgetSize();
}

double getCenterWidgetSizeBridger()
{
    return getCenterWidgetSize();
}