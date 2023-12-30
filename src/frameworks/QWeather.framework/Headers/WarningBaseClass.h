//
//Created by QWeather on 18/07/28.
//天气灾害预警


#import <QWeather/QWeather.h>

@class Warning,Refer;
@interface WarningBaseClass : QWeatherBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * fxLink;
@property (nonatomic, strong) NSArray<Warning *> *warning;
@property (nonatomic , strong) Refer *refer;

@end
@interface Warning : QWeatherBaseModel
@property (nonatomic, copy) NSString *warningId;
@property (nonatomic, copy) NSString *pubTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *related;
@property (nonatomic, copy) NSString *urgency;
@property (nonatomic, copy) NSString *certainty;
@property (nonatomic, copy) NSString *severity;
@property (nonatomic, copy) NSString *severityColor;
@end
