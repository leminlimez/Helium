#import <Foundation/Foundation.h>
#import <Foundation/NSBundle.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface WeatherUtils : NSObject
+ (NSString *)getWeatherIcon:(NSString *)text;
+ (void)setIDKey:(NSString *)Id apiKey:(NSString *) key;
+ (NSDictionary *)fetchCurrentWeatherForLocation:(NSString *)location;
+ (NSDictionary *)fetchTodayWeatherForLocation:(NSString *)location;
+ (NSString *)formatCurrentResult:(NSDictionary *)data format:(NSString *)format;
+ (NSString *)formatTodayResult:(NSDictionary *)data format:(NSString *)format;
+ (NSString *)getDataFrom:(NSString *)url;
@end