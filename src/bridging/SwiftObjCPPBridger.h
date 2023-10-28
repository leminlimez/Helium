//
//  SwiftObjCPPBridger.h
//  
//
//  Created by lemin on 10/13/23.
//

#include <Foundation/Foundation.h>


#pragma mark - HUD Functions

BOOL IsHUDEnabledBridger();
void SetHUDEnabledBridger(BOOL isEnabled);
void waitForNotificationBridger(void (^onFinish)(), BOOL isEnabled);


#pragma mark - Device Scale Manager

NSDictionary<NSString*, NSNumber*>* getMaxNumWidgetsBridger();

NSInteger getDeviceSizeBridger();
double getSideWidgetSizeBridger();
double getCenterWidgetSizeBridger();