#import <Foundation/Foundation.h>

@interface LunarDate : NSObject

+ (NSCalendar *)chineseCalendar;
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date format:(NSString *)format;

@end