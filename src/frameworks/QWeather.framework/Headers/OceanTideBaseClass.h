//
//  OceanTideBaseClass.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>


NS_ASSUME_NONNULL_BEGIN
@class TideTable,TideHourly,Refer;

@interface OceanTideBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic, strong) NSArray<TideTable *> *tideTable;
@property (nonatomic, strong) NSArray<TideHourly *> *tideHourly;
@property (nonatomic , strong) Refer *refer;
@end
@interface TideTable : QWeatherBaseModel
@property (nonatomic, copy) NSString *fxTime;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *type;
@end

@interface TideHourly : QWeatherBaseModel
@property (nonatomic, copy) NSString *fxTime;
@property (nonatomic, copy) NSString *height;
@end


NS_ASSUME_NONNULL_END
