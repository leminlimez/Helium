//
//Created by QWeather on 18/07/27.
//常规天气数据集合

#import <QWeather/QWeather.h>

@class Daily,Now,Hourly,Refer;
@interface WeatherBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic , strong) Now              * now;
@property (nonatomic , strong) NSArray<Daily *>              * daily;
@property (nonatomic , strong) NSArray<Hourly *>              * hourly;
@property (nonatomic , strong) Refer *refer;
@end
@interface Now :QWeatherBaseModel
@property (nonatomic , copy) NSString              * obsTime;
@property (nonatomic , copy) NSString              * temp;
@property (nonatomic , copy) NSString              * feelsLike;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * wind360;
@property (nonatomic , copy) NSString              * windDir;
@property (nonatomic , copy) NSString              * windScale;
@property (nonatomic , copy) NSString              * windSpeed;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * pressure;
@property (nonatomic , copy) NSString              * vis;
@property (nonatomic , copy) NSString              * cloud;
@property (nonatomic , copy) NSString              * dew;
@end
@interface Daily :QWeatherBaseModel
@property (nonatomic , copy) NSString              * fxDate;
@property (nonatomic , copy) NSString              * sunrise;
@property (nonatomic , copy) NSString              * sunset;
@property (nonatomic , copy) NSString              * moonrise;
@property (nonatomic , copy) NSString              * moonset;
@property (nonatomic , copy) NSString              * moonPhase;
@property (nonatomic , copy) NSString              * tempMax;
@property (nonatomic , copy) NSString              * tempMin;
@property (nonatomic , copy) NSString              * iconDay;
@property (nonatomic , copy) NSString              * textDay;
@property (nonatomic , copy) NSString              * iconNight;
@property (nonatomic , copy) NSString              * textNight;
@property (nonatomic , copy) NSString              * wind360Day;
@property (nonatomic , copy) NSString              * windDirDay;
@property (nonatomic , copy) NSString              * windScaleDay;
@property (nonatomic , copy) NSString              * windSpeedDay;
@property (nonatomic , copy) NSString              * wind360Night;
@property (nonatomic , copy) NSString              * WindDirNight;
@property (nonatomic , copy) NSString              * windScaleNight;
@property (nonatomic , copy) NSString              * windSpeedNight;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * pressure;
@property (nonatomic , copy) NSString              * vis;
@property (nonatomic , copy) NSString              * cloud;
@property (nonatomic , copy) NSString              * uvIndex;
@property (nonatomic , copy) NSString              * moonPhaseIcon;
@end
@interface Hourly :QWeatherBaseModel
@property (nonatomic , copy) NSString              * fxTime;
@property (nonatomic , copy) NSString              * temp;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * wind360;
@property (nonatomic , copy) NSString              * windDir;
@property (nonatomic , copy) NSString              * windScale;
@property (nonatomic , copy) NSString              * windSpeed;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * pop;
@property (nonatomic , copy) NSString              * pressure;
@property (nonatomic , copy) NSString              * cloud;
@property (nonatomic , copy) NSString              * dew;
@end
@interface Refer :QWeatherBaseModel
@property (nonatomic,strong) NSArray<NSString *> *sources;
@property (nonatomic,strong) NSArray<NSString *> *license;
@end
