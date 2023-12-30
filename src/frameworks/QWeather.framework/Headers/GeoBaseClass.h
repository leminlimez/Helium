//
//Created by QWeather on 18/07/28.
//城市查询

#import <QWeather/QWeather.h>

@class Refer,Location;
@interface GeoBaseClass : QWeatherBaseModel
@property (nonatomic, strong) NSArray<Location *> *location;
@property (nonatomic, copy) NSString *code;
@property (nonatomic , strong) Refer *refer;
@end

@interface Location :QWeatherBaseModel
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * cid;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * lon;
@property (nonatomic , copy) NSString              * adm2;
@property (nonatomic , copy) NSString              * adm1;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * tz;
@property (nonatomic , copy) NSString              * utcOffset;
@property (nonatomic , copy) NSString              * isDst;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * rank;
@property (nonatomic , copy) NSString              * fxLink;

@end
