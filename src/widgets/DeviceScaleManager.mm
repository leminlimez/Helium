//
//  DeviceScaleManager.m
//  
//
//  Created by lemin on 10/11/23.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "DeviceScaleManager.h"

// Small Notch Definitions
#define SMALL_SIDE_WIDGET_SIZE 0.27435897
#define SMALL_CENTER_WIDGET_SIZE 0.34615385

NSString* getDeviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

/*
 Sizes:
 0 = No Notch
 1 = Small Notch
 2 = Big Notch
 3 = Dynamic Island
 */
NSInteger getDeviceSize()
{
    NSString *model = getDeviceName();
    
    // get the notch size
    if ([model rangeOfString: @"iPhone14"].location != NSNotFound) {
        // small notch
        return 1;
    }
    return 0;
}

double getSideWidgetSize()
{
    
    NSInteger deviceSize = getDeviceSize();
    
    if (deviceSize == 1) {
        // Small Notch
        return SMALL_SIDE_WIDGET_SIZE;
    }
    
    return 0.0;
}

double getCenterWidgetSize()
{
    
    NSInteger deviceSize = getDeviceSize();
    
    if (deviceSize == 1) {
        // Small Notch
        return SMALL_CENTER_WIDGET_SIZE;
    }
    
    return 0.0;
}

// get the max number of (sideNum, centerNum) widgets
extern "C" NSDictionary<NSString*, NSNumber*>* getMaxNumWidgets(void);
NSDictionary<NSString*, NSNumber*>* getMaxNumWidgets()
{
    NSInteger deviceSize = getDeviceSize();

    if (deviceSize == 1) {
        // Small Notch
        return @{
            @"sideNum": @(2),
            @"centerNum": @(3)
        };
    }
    
    // Unknown
    return @{
        @"sideNum": @(1),
        @"centerNum": @(1)
    };
}
