//
//  StormForecastBaseClass.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>


NS_ASSUME_NONNULL_BEGIN
@class StormForecast,Refer;

@interface StormForecastBaseClass : QWeatherBaseModel
@property (nonatomic , strong) Refer *refer;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *fxLink;
@property (nonatomic, strong)NSArray<StormForecast*> *forecast;
@end
@interface StormForecast : QWeatherBaseModel
@property (nonatomic, copy) NSString *fxTime;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pressure;
@property (nonatomic, copy) NSString *windSpeed;
@property (nonatomic, copy) NSString *moveSpeed;
@property (nonatomic, copy) NSString *moveDir;
@property (nonatomic, copy) NSString *move360;
@end
NS_ASSUME_NONNULL_END
