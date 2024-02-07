//
//  SwiftObjCPPBridger.h
//  
//
//  Created by lemin on 10/13/23.
//

#import <Foundation/Foundation.h>

#pragma mark - HUD Functions

BOOL IsHUDEnabledBridger();
void SetHUDEnabledBridger(BOOL isEnabled);
void waitForNotificationBridger(void (^onFinish)(), BOOL isEnabled);