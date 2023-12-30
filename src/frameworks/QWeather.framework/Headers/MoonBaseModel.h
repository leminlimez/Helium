//
//  MoonBaseModel.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>


NS_ASSUME_NONNULL_BEGIN
@class  MoonPhase,Refer;
@interface MoonBaseModel : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic , copy) NSString              * moonrise;
@property (nonatomic , copy) NSString              * moonset;
@property (nonatomic,strong) NSArray<MoonPhase *> *moonPhases;
@property (nonatomic , strong) Refer *refer;
@end

@interface MoonPhase : QWeatherBaseModel
@property (nonatomic,copy) NSString *fxTime;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *illumination;
@property (nonatomic,copy) NSString *icon;
@end
NS_ASSUME_NONNULL_END
