#import <Foundation/Foundation.h>
#import <Foundation/NSBundle.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface WeatherUtils : NSObject
+ (NSString *)getWeatherIcon:(NSString *)text;
+ (void)setIDKey:(NSString *)Id apiKey:(NSString *) key;
+ (NSDictionary *)fetchCurrentWeatherForLocation:(NSString *)location;
+ (NSString *)getDataFrom:(NSString *)url;
@end