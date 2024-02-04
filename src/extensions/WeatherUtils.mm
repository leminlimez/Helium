#import "WeatherUtils.h"

@implementation WeatherUtils

+ (NSString *)getWeatherIcon:(NSString *)text {
    NSString *weatherIcon = @"🌤️";
    NSArray *weatherIconList = @[@"☀️", @"☁️", @"⛅️",
                                 @"☃️", @"⛈️", @"🏜️", @"🏜️", @"🌫️", @"🌫️", @"🌪️", @"🌧️"];
    NSArray *weatherType = @[@"晴|sunny", @"阴|overcast", @"云|cloudy", @"雪|snow", @"雷|thunder", @"沙|sand", @"尘|dust", @"雾|foggy", @"霾|haze", @"风|wind", @"雨|rain"];
    
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

+ (NSDictionary *)fetchNowWeatherForLocation:(NSString *)location apiKey:(NSString *) apiKey dateLocale:(NSString *)dateLocale{
    NSString *res = [self getDataFrom:[NSString stringWithFormat:@"https://devapi.qweather.com/v7/weather/now?location=%@&key=%@&lang=%@", location, apiKey, [self convertDateLocaleToLang:dateLocale]]];
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *erro = nil;
    if (data!=nil) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
        return json;
    }
    return nil;
}

+ (NSDictionary *)fetchTodayWeatherForLocation:(NSString *)location apiKey:(NSString *) apiKey dateLocale:(NSString *)dateLocale{
    NSString *res = [self getDataFrom:[NSString stringWithFormat:@"https://devapi.qweather.com/v7/weather/3d?location=%@&key=%@&lang=%@", location, apiKey, [self convertDateLocaleToLang:dateLocale]]];
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *erro = nil;
    if (data!=nil) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
        return json;
    }
    return nil;
}

+ (NSData *)fetchLocationIDForName:(NSString *)name apiKey:(NSString *) apiKey dateLocale:(NSString *)dateLocale{
    NSString *res = [self getDataFrom:[NSString stringWithFormat:@"https://geoapi.qweather.com/v2/city/lookup?location=%@&key=%@&lang=%@", [self encodeURIComponent:name], apiKey, [self convertDateLocaleToLang:dateLocale]]];
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    if (data!=nil) {
        NSLog(@"weather location:%@", data);
        return data;
    }
    return nil;
}

+ (NSString*)formatNowResult:(NSDictionary *)data format:(NSString *)format {
    NSLog(@"weather now:%@", data);
    if(data && [data[@"code"] isEqualToString:@"200"]) {
        format = [format stringByReplacingOccurrencesOfString:@"{i}" withString:[WeatherUtils getWeatherIcon: data[@"now"][@"text"]]];
        format = [format stringByReplacingOccurrencesOfString:@"{n}" withString:data[@"now"][@"text"]];
        format = [format stringByReplacingOccurrencesOfString:@"{t}" withString:data[@"now"][@"temp"]];
        format = [format stringByReplacingOccurrencesOfString:@"{bt}" withString:data[@"now"][@"feelsLike"]];
        format = [format stringByReplacingOccurrencesOfString:@"{h}" withString:data[@"now"][@"humidity"]];
        format = [format stringByReplacingOccurrencesOfString:@"{w}" withString:data[@"now"][@"windDir"]];
        format = [format stringByReplacingOccurrencesOfString:@"{wp}" withString:data[@"now"][@"windScale"]];
        format = [format stringByReplacingOccurrencesOfString:@"{pc}" withString:data[@"now"][@"precip"]];
        format = [format stringByReplacingOccurrencesOfString:@"{ps}" withString:data[@"now"][@"pressure"]];
        format = [format stringByReplacingOccurrencesOfString:@"{v}" withString:data[@"now"][@"vis"]];
        format = [format stringByReplacingOccurrencesOfString:@"{c}" withString:data[@"now"][@"cloud"]];
    } else {
        format = NSLocalizedString(@"error", comment:@"");
    }
    return format;
}

+ (NSString*)formatTodayResult:(NSDictionary *)data format:(NSString *)format {
    NSLog(@"weather today:%@", data);
    if(data && [data[@"code"] isEqualToString:@"200"]) {
        format = [format stringByReplacingOccurrencesOfString:@"{di}" withString:[WeatherUtils getWeatherIcon: data[@"daily"][0][@"textDay"]]];
        format = [format stringByReplacingOccurrencesOfString:@"{dn}" withString:data[@"daily"][0][@"textDay"]];
        format = [format stringByReplacingOccurrencesOfString:@"{dt}" withString:data[@"daily"][0][@"tempMax"]];
        format = [format stringByReplacingOccurrencesOfString:@"{dw}" withString:data[@"daily"][0][@"windDirDay"]];
        format = [format stringByReplacingOccurrencesOfString:@"{dwp}" withString:data[@"daily"][0][@"windScaleDay"]];
        format = [format stringByReplacingOccurrencesOfString:@"{ni}" withString:[WeatherUtils getWeatherIcon: data[@"daily"][0][@"textNight"]]];
        format = [format stringByReplacingOccurrencesOfString:@"{nn}" withString:data[@"daily"][0][@"textNight"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nt}" withString:data[@"daily"][0][@"tempMin"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nw}" withString:data[@"daily"][0][@"windDirNight"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nwp}" withString:data[@"daily"][0][@"windScaleNight"]];
        format = [format stringByReplacingOccurrencesOfString:@"{tpc}" withString:data[@"daily"][0][@"precip"]];
        format = [format stringByReplacingOccurrencesOfString:@"{tuv}" withString:data[@"daily"][0][@"uvIndex"]];
        format = [format stringByReplacingOccurrencesOfString:@"{th}" withString:data[@"daily"][0][@"humidity"]];
        format = [format stringByReplacingOccurrencesOfString:@"{tps}" withString:data[@"daily"][0][@"pressure"]];
        format = [format stringByReplacingOccurrencesOfString:@"{tv}" withString:data[@"daily"][0][@"vis"]];
        format = [format stringByReplacingOccurrencesOfString:@"{tc}" withString:data[@"daily"][0][@"cloud"]];
    } else {
        format = NSLocalizedString(@"error", comment:@"");
    }
    return format;
}

+ (NSString *)getDataFrom:(NSString *)url{
    NSLog(@"url:%@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, [responseCode statusCode]);
        return nil;
    }

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]; 
}

+ (NSString *)convertDateLocaleToLang:(NSString *)locale{
    NSArray *items = @[@"zh_CN", @"en_US"];
    int item = [items indexOfObject:locale];
    switch(item) {
        case 0: return @"zh";
        case 1: return @"en";
        default: return @"en";
    }
}

+ (NSString *)encodeURIComponent:(NSString *)string
{
    NSString *s = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return s;
}
@end
