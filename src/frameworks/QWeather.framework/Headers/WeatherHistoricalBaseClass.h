//
//Created by QWeather on 18/07/27.
//历史数据

#import <QWeather/QWeather.h>

@class HistoricalWeatherDaily,HistoricalWeatherHourly,HistoricalAirHourly,Refer;
@interface WeatherHistoricalBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic, copy) NSString *fxLink;
@property (nonatomic , strong) HistoricalWeatherDaily              * weatherDaily;
@property (nonatomic , strong) NSArray<HistoricalWeatherHourly *>              * weatherHourly;
@property (nonatomic , strong) NSArray<HistoricalAirHourly *>              * airHourly;
@property (nonatomic , strong) Refer *refer;
@end
@interface HistoricalWeatherDaily :QWeatherBaseModel
@property (nonatomic , copy) NSString              * sunset;
@property (nonatomic , copy) NSString              * tempMax;
@property (nonatomic , copy) NSString              * moonrise;
@property (nonatomic , copy) NSString              * tempMin;
@property (nonatomic , copy) NSString              * moonPhase;
@property (nonatomic , copy) NSString              * sunrise;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * pressure;
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * moonset;
@end

@interface HistoricalWeatherHourly :QWeatherBaseModel
@property (nonatomic , copy) NSString              * windScale;
@property (nonatomic , copy) NSString              * windDir;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * pressure;
@property (nonatomic , copy) NSString              * windSpeed;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * temp;
@property (nonatomic , copy) NSString              * wind360;
@end

@interface HistoricalAirHourly :QWeatherBaseModel
@property (nonatomic , copy) NSString              * pubTime;
@property (nonatomic , copy) NSString              * aqi;
@property (nonatomic , copy) NSString              * primary;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * pm10;
@property (nonatomic , copy) NSString              * pm2p5;
@property (nonatomic , copy) NSString              * no2;
@property (nonatomic , copy) NSString              * so2;
@property (nonatomic , copy) NSString              * co;
@property (nonatomic , copy) NSString              * o3;
@end

