//
//  SunAngleBaseModel.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//

#import <QWeather/QWeather.h>

NS_ASSUME_NONNULL_BEGIN
@class Refer;

@interface SunAngleBaseModel : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * solarElevationAngle;
@property (nonatomic , copy) NSString              * solarAzimuthAngle;
@property (nonatomic , copy) NSString              * solarHour;
@property (nonatomic , copy) NSString              * hourAngle;
@property (nonatomic , strong) Refer *refer;
@end

NS_ASSUME_NONNULL_END
