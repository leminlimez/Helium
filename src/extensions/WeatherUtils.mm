#import "WeatherUtils.h"

static NSString *apiKey = @"";

@implementation WeatherUtils

+ (NSString *)getWeatherIcon:(NSString *)text {
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

+ (void)setIDKey:(NSString *)publicID apiKey:(NSString *) apiKey {
    // NSLog(@"userid %@,%@", publicID, apiKey);
}

+ (NSDictionary *)fetchCurrentWeatherForLocation:(NSString *)location {
    NSString *res = [self getDataFrom:[NSString stringWithFormat:@"https://restapi.amap.com/v3/weather/weatherInfo?city=%@&key=%@&extensions=base", location, apiKey]];
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *erro = nil;
    if (data!=nil) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
        return json;
    }
    return nil;
}

+ (NSDictionary *)fetchTodayWeatherForLocation:(NSString *)location {
    NSString *res = [self getDataFrom:[NSString stringWithFormat:@"https://restapi.amap.com/v3/weather/weatherInfo?city=%@&key=%@&extensions=all", location, apiKey]];
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *erro = nil;
    if (data!=nil) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
        return json;
    }
    return nil;
}

+ (NSString *)formatCurrentResult:(NSDictionary *)data format:(NSString *)format {
    if(data) {
        format = [format stringByReplacingOccurrencesOfString:@"{icon}" withString:[WeatherUtils getWeatherIcon: data[@"lives"][0][@"weather"]]];
        format = [format stringByReplacingOccurrencesOfString:@"{text}" withString:data[@"lives"][0][@"weather"]];
        format = [format stringByReplacingOccurrencesOfString:@"{temp}" withString:data[@"lives"][0][@"temperature"]];
        format = [format stringByReplacingOccurrencesOfString:@"{humidity}" withString:data[@"lives"][0][@"humidity"]];
        format = [format stringByReplacingOccurrencesOfString:@"{wind}" withString:data[@"lives"][0][@"winddirection"]];
        format = [format stringByReplacingOccurrencesOfString:@"{windpower}" withString:data[@"lives"][0][@"windpower"]];
    } else {
        format = NSLocalizedString(@"error", comment:@"");
    }
    return format;
}

+ (NSString *)formatTodayResult:(NSDictionary *)data format:(NSString *)format {
    if(data) {
        format = [format stringByReplacingOccurrencesOfString:@"{dayicon}" withString:[WeatherUtils getWeatherIcon: data[@"forecasts"][0][@"casts"][0][@"dayweather"]]];
        format = [format stringByReplacingOccurrencesOfString:@"{daytext}" withString:data[@"forecasts"][0][@"casts"][0][@"dayweather"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nighticon}" withString:[WeatherUtils getWeatherIcon: data[@"forecasts"][0][@"casts"][0][@"nightweather"]]];
        format = [format stringByReplacingOccurrencesOfString:@"{nighttext}" withString:data[@"forecasts"][0][@"casts"][0][@"nightweather"]];
        format = [format stringByReplacingOccurrencesOfString:@"{daytemp}" withString:data[@"forecasts"][0][@"casts"][0][@"daytemp"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nighttemp}" withString:data[@"forecasts"][0][@"casts"][0][@"nighttemp"]];
        format = [format stringByReplacingOccurrencesOfString:@"{daywind}" withString:data[@"forecasts"][0][@"casts"][0][@"daywind"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nightwind}" withString:data[@"forecasts"][0][@"casts"][0][@"nightwind"]];
        format = [format stringByReplacingOccurrencesOfString:@"{daypower}" withString:data[@"forecasts"][0][@"casts"][0][@"daypower"]];
        format = [format stringByReplacingOccurrencesOfString:@"{nightpower}" withString:data[@"forecasts"][0][@"casts"][0][@"nightpower"]];
    } else {
        format = NSLocalizedString(@"error", comment:@"");
    }
    return format;
}

+ (NSString *)getDataFrom:(NSString *)url{
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
@end
