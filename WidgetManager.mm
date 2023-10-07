//
//  WidgetManager.m
//  
//
//  Created by lemin on 10/6/23.
//

#import <Foundation/Foundation.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <sys/wait.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>
#import "WidgetManager.h"
#import <IOKit/IOKitLib.h>

// Thanks to: https://github.com/lwlsw/NetworkSpeed13

#define KILOBITS 1000
#define MEGABITS 1000000
#define GIGABITS 1000000000
#define KILOBYTES (1 << 10)
#define MEGABYTES (1 << 20)
#define GIGABYTES (1 << 30)
#define SHOW_ALWAYS 1
#define INLINE_SEPARATOR "\t"

static double FONT_SIZE = 10.0;

#pragma mark - Formatting Methods
static unsigned char getSeparator(NSMutableAttributedString *currentAttributed)
{
    return [[currentAttributed string] isEqualToString:@""] ? *"" : *"\t";
}

#pragma mark - Widget-specific Variables
// MARK: 0 - Date Widget
static NSDateFormatter *formatter = nil;

// MARK: Net Speed Widget
static uint8_t DATAUNIT = 0;
static const char *UPLOAD_PREFIX = "▲";
static const char *DOWNLOAD_PREFIX = "▼";

typedef struct {
    uint64_t inputBytes;
    uint64_t outputBytes;
} UpDownBytes;

static uint64_t prevOutputBytes = 0, prevInputBytes = 0;
static NSAttributedString *attributedUploadPrefix = nil;
static NSAttributedString *attributedDownloadPrefix = nil;

#pragma mark - Date Widget
static NSString* formattedDate(NSString *dateFormat)
{
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    NSDate *currentDate = [NSDate date];
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:currentDate];
}

#pragma mark - Net Speed Widgets
static UpDownBytes getUpDownBytes()
{
    struct ifaddrs *ifa_list = 0, *ifa;
    UpDownBytes upDownBytes;
    upDownBytes.inputBytes = 0;
    upDownBytes.outputBytes = 0;
    
    if (getifaddrs(&ifa_list) == -1) return upDownBytes;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        /* Skip invalid interfaces */
        if (ifa->ifa_name == NULL || ifa->ifa_addr == NULL || ifa->ifa_data == NULL)
            continue;
        
        /* Skip interfaces that are not link level interfaces */
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;

        /* Skip interfaces that are not up or running */
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        /* Skip interfaces that are not ethernet or cellular */
        if (strncmp(ifa->ifa_name, "en", 2) && strncmp(ifa->ifa_name, "pdp_ip", 6))
            continue;
        
        struct if_data *if_data = (struct if_data *)ifa->ifa_data;
        
        upDownBytes.inputBytes += if_data->ifi_ibytes;
        upDownBytes.outputBytes += if_data->ifi_obytes;
    }
    
    freeifaddrs(ifa_list);
    return upDownBytes;
}

static NSString* formattedSpeed(uint64_t bytes)
{
    if (0 == DATAUNIT) {
        if (bytes < KILOBYTES) return @"0 KB/s";
        else if (bytes < MEGABYTES) return [NSString stringWithFormat:@"%.0f KB", (double)bytes / KILOBYTES];
        else if (bytes < GIGABYTES) return [NSString stringWithFormat:@"%.2f MB", (double)bytes / MEGABYTES];
        else return [NSString stringWithFormat:@"%.2f GB", (double)bytes / GIGABYTES];
    } else {
        if (bytes < KILOBITS) return @"0 Kb";
        else if (bytes < MEGABITS) return [NSString stringWithFormat:@"%.0f Kb", (double)bytes / KILOBITS];
        else if (bytes < GIGABITS) return [NSString stringWithFormat:@"%.2f Mb", (double)bytes / MEGABITS];
        else return [NSString stringWithFormat:@"%.2f Gb", (double)bytes / GIGABITS];
    }
}

static NSAttributedString* formattedAttributedSpeedString(BOOL isUp)
{
    @autoreleasepool {
        if (!attributedUploadPrefix)
            attributedUploadPrefix = [[NSAttributedString alloc] initWithString:[[NSString stringWithUTF8String:UPLOAD_PREFIX] stringByAppendingString:@" "] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FONT_SIZE]}];
        if (!attributedDownloadPrefix)
            attributedDownloadPrefix = [[NSAttributedString alloc] initWithString:[[NSString stringWithUTF8String:DOWNLOAD_PREFIX] stringByAppendingString:@" "] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FONT_SIZE]}];
        
        NSMutableAttributedString* mutableString = [[NSMutableAttributedString alloc] init];
        
        UpDownBytes upDownBytes = getUpDownBytes();
        
        uint64_t diff;
        
        if (isUp) {
            if (upDownBytes.outputBytes > prevOutputBytes)
                diff = upDownBytes.outputBytes - prevOutputBytes;
            else
                diff = 0;
            prevOutputBytes = upDownBytes.outputBytes;
            [mutableString appendAttributedString:attributedUploadPrefix];
        } else {
            if (upDownBytes.inputBytes > prevInputBytes)
                diff = upDownBytes.inputBytes - prevInputBytes;
            else
                diff = 0;
            prevInputBytes = upDownBytes.inputBytes;
            [mutableString appendAttributedString:attributedDownloadPrefix];
        }
        
        if (DATAUNIT == 1)
            diff *= 8;
        
        [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:formattedSpeed(diff) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
        
        return [mutableString copy];
    }
}

#pragma mark - Battery Temp Widget
NSDictionary* getBatteryInfo()
{
    CFDictionaryRef matching = IOServiceMatching("IOPMPowerSource");
    io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
    CFMutableDictionaryRef prop = NULL;
    IORegistryEntryCreateCFProperties(service, &prop, NULL, 0);
    NSDictionary* dict = (__bridge_transfer NSDictionary*)prop;
    IOObjectRelease(service);
    return dict;
}

static NSString* formattedTemp()
{
    NSDictionary *batteryInfo = getBatteryInfo();
    if (batteryInfo) {
        // AdapterDetails.Watts.Description.Temperature
        double temp = [batteryInfo[@"Temperature"] doubleValue] / 100.0;
        if (temp) {
            return [NSString stringWithFormat: @"%.2fºC", temp];
        }
    }
    return @"??ºC";
}


#pragma mark - Main Widget Functions
/*
 Widget Identifiers:
 0 = Date
 1 = Network Up
 2 = Network Down
 3 = Device Temp
 4 = Weather
 */
NSAttributedString* formattedAttributedString(NSInteger identifier)
{
    if (identifier == 1)
        return formattedAttributedSpeedString(YES);
    else if (identifier == 2)
        return formattedAttributedSpeedString(NO);
    @autoreleasepool {
        NSMutableAttributedString* mutableString = [[NSMutableAttributedString alloc] init];
        
        if (identifier == 0) {
            [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:formattedDate(@"E MMM dd") attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
        } else {
            [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:@"???" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
        }
        
        return [mutableString copy];
    }
}

/*
 Widget Identifiers:
 0 = None
 1 = Date
 2 = Network Up/Down
 3 = Device Temp
 4 = Weather
 5 = Music Visualizer
 */
NSAttributedString* formattedAttributedString(NSArray *identifiers)
{
    @autoreleasepool {
        NSMutableAttributedString* mutableString = [[NSMutableAttributedString alloc] init];
        
        if (identifiers) {
            for (id idInfo in identifiers) {
                NSDictionary *parsedInfo = idInfo;
                NSInteger parsedID = [parsedInfo valueForKey:@"widgetID"] ? [[parsedInfo valueForKey:@"widgetID"] integerValue] : 0;
                switch (parsedID) {
                    case 1:
                        // Date
                        [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%c%@", getSeparator(mutableString), formattedDate([parsedInfo valueForKey:@"dateFormat"] ? [parsedInfo valueForKey:@"dateFormat"] : @"E MMM dd")] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
                        break;
                    case 2:
                        // Network Speed
                        [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%c", getSeparator(mutableString)] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
                        [mutableString appendAttributedString: formattedAttributedSpeedString([parsedInfo valueForKey:@"isUp"] ? [[parsedInfo valueForKey:@"isUp"] boolValue] : NO)];
                        break;
                    case 3:
                        // Device Temp
                        [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%c%@", getSeparator(mutableString), formattedTemp()] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
                        break;
                    default:
                        // do not add anything
                        [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
                        break;
                }
            }
        } else {
            [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}]];
        }
        
        return [mutableString copy];
    }
}
