//
//  OceanCurrentsBaseClass.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>


NS_ASSUME_NONNULL_BEGIN
@class CurrentsTable,CurrentsHourly,Refer;

@interface OceanCurrentsBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic, strong) NSArray<CurrentsTable *> *currentsTable;
@property (nonatomic, strong) NSArray<CurrentsHourly *> *currentsHourly;
@property (nonatomic , strong) Refer *refer;
@end
@interface CurrentsTable : QWeatherBaseModel
@property (nonatomic, copy) NSString *dir360;
@property (nonatomic, copy) NSString *fxTime;
@property (nonatomic, copy) NSString *speedMax;
@end

@interface CurrentsHourly : QWeatherBaseModel
@property (nonatomic, copy) NSString *dir360;
@property (nonatomic, copy) NSString *fxTime;
@property (nonatomic, copy) NSString *speed;
@end

NS_ASSUME_NONNULL_END
