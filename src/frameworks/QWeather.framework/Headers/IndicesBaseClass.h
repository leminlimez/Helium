//
//Created by QWeather on 18/07/27.
//生活指数

#import <QWeather/QWeather.h>

@class IndicesDaily,IndicesNow,Refer;
@interface IndicesBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic , strong) NSArray<IndicesDaily *>              * daily;
@property (nonatomic , strong) IndicesNow              * now;
@property (nonatomic , strong) Refer *refer;
@end
@interface IndicesDaily :QWeatherBaseModel
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * date;
@end

@interface IndicesNow :QWeatherBaseModel
@property (nonatomic , copy) NSString              * txt;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * name;
@end
