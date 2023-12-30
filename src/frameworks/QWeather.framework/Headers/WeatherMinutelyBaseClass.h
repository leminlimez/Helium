//
//Created by QWeather on 18/07/27.
//分钟级降雨（邻近预报）

#import <QWeather/QWeather.h>

@class Minutely,Refer;
@interface WeatherMinutelyBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic , copy) NSString              * summary;
@property (nonatomic , strong) NSArray<Minutely *>              * minutely;
@property (nonatomic , strong) Refer *refer;
@end
@interface Minutely :QWeatherBaseModel
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * fxTime;
@property (nonatomic , copy) NSString              * type;

@end

