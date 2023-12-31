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
    NSString *res = [self getDataFrom:[NSString stringWithFormat:@"https://devapi.qweather.com/v7/weather/now?location=%@&key=%@", location, apiKey]];
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *erro = nil;
    if (data!=nil) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
        if ([json[@"code"] isEqualToString: @"200"]) {
            return json;
        }
    }
    return nil;
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
