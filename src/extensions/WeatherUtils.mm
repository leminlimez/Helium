#import "WeatherUtils.h"

@implementation WeatherUtils

- (NSString *)getWeatherIcon:(NSString *)text {
    NSString *weatherIcon = @"🌤️";
    NSArray *weatherIconList = @[@"☀️", @"☁️", @"⛅️",
                                 @"☃️", @"⛈️", @"🏜️", @"🏜️", @"🌫️", @"🌫️", @"🌪️", @"🌧️"];
    NSArray *weatherType = @[@"晴", @"阴", @"云", @"雪", @"雷", @"沙", @"尘", @"雾", @"霾", @"风", @"雨"];
    
    NSRegularExpression *regex;
    for (int i = 0; i < weatherType.count; i++) {
        NSString *pattern = [NSString stringWithFormat:@".*%@.*", weatherType[i]];
        regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        if ([regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])] > 0) {
            weatherIcon = weatherIconList[i];
            break;
        }
    }
    
    return weatherIcon;
}

@end