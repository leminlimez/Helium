//
//  StormNowTrackBaseClass.h
//  QWeather
//
//  Created by hefeng on 2021/5/14.
//  Copyright © 2021 Song. All rights reserved.
//


#import <QWeather/QWeather.h>


NS_ASSUME_NONNULL_BEGIN
@class StormNow,Track,WindRadius,Refer;

@interface StormNowTrackBaseClass : QWeatherBaseModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *fxLink;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong)NSArray<StormNow*> *now;
@property (nonatomic, strong)NSArray<Track*> *track;
@property (nonatomic , strong) Refer *refer;

@end
@interface StormNow : QWeatherBaseModel
@property (nonatomic, copy) NSString *pubTime;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pressure;
@property (nonatomic, copy) NSString *windSpeed;
@property (nonatomic, copy) NSString *moveSpeed;
@property (nonatomic, copy) NSString *moveDir;
@property (nonatomic, copy) NSString *move360;
@property (nonatomic, strong) WindRadius *windRadius30;
@property (nonatomic, strong) WindRadius *windRadius50;
@property (nonatomic, strong) WindRadius *windRadius64;

@end
@interface Track : QWeatherBaseModel
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pressure;
@property (nonatomic, copy) NSString *windSpeed;
@property (nonatomic, copy) NSString *moveSpeed;
@property (nonatomic, copy) NSString *moveDir;
@property (nonatomic, copy) NSString *move360;
@property (nonatomic, strong) WindRadius *windRadius30;
@property (nonatomic, strong) WindRadius *windRadius50;
@property (nonatomic, strong) WindRadius *windRadius64;
@end
@interface WindRadius : QWeatherBaseModel
@property (nonatomic, copy) NSString *neRadius;
@property (nonatomic, copy) NSString *seRadius;
@property (nonatomic, copy) NSString *swRadius;
@property (nonatomic, copy) NSString *nwRadius;
@end

NS_ASSUME_NONNULL_END
