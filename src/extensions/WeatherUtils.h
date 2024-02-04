#import <Foundation/Foundation.h>
#import <Foundation/NSBundle.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface WeatherUtils : NSObject
+ (NSString *)getWeatherIcon:(NSString *)text;
+ (NSDictionary *)fetchNowWeatherForLocation:(NSString *)location apiKey:(NSString *) apiKey dateLocale:(NSString *)dateLocale;
+ (NSDictionary *)fetchTodayWeatherForLocation:(NSString *)location apiKey:(NSString *) apiKey dateLocale:(NSString *)dateLocale;
+ (NSData *)fetchLocationIDForName:(NSString *)name apiKey:(NSString *) apiKey dateLocale:(NSString *)dateLocale;
+ (NSString *)formatNowResult:(NSDictionary *)data format:(NSString *)format;
+ (NSString *)formatTodayResult:(NSDictionary *)data format:(NSString *)format;
+ (NSString *)getDataFrom:(NSString *)url;
+ (NSString *)convertDateLocaleToLang:(NSString *)locale;
@end