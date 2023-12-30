//
//  StormListBaseClass.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>


NS_ASSUME_NONNULL_BEGIN
@class Storm,Refer;

@interface StormListBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic, strong) NSArray<Storm *> *stormList;
@property (nonatomic , strong) Refer *refer;
@end
@interface Storm : QWeatherBaseModel
@property (nonatomic, copy) NSString *stormId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *basin;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, assign) BOOL isActive;
@end
NS_ASSUME_NONNULL_END
