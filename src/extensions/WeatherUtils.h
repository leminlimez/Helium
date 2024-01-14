#import <Foundation/Foundation.h>
#import <Foundation/NSBundle.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface WeatherUtils : NSObject
+ (NSString *)getWeatherIcon:(NSString *)text;
+ (NSDictionary *)fetchCurrentWeatherForLocation:(NSString *)location apiKey:(NSString *) apiKey;
+ (NSDictionary *)fetchTodayWeatherForLocation:(NSString *)location apiKey:(NSString *) apiKey;
+ (NSString *)formatCurrentResult:(NSDictionary *)data format:(NSString *)format;
+ (NSString *)formatTodayResult:(NSDictionary *)data format:(NSString *)format;
+ (NSString *)getDataFrom:(NSString *)url;
@end