//
//  SwiftObjCPPBridger.h
//  
//
//  Created by lemin on 10/13/23.
//

#include <Foundation/Foundation.h>

BOOL IsHUDEnabledBridger();
void SetHUDEnabledBridger(BOOL isEnabled);
void waitForNotificationBridger(void (^onFinish)(), BOOL isEnabled);

