//
//  SunBaseModel.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>

NS_ASSUME_NONNULL_BEGIN
@class  Refer;
@interface SunBaseModel : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic , copy) NSString              * sunrise;
@property (nonatomic , copy) NSString              * sunset;
@property (nonatomic , strong) Refer *refer;
@end

NS_ASSUME_NONNULL_END
