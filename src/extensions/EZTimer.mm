//
//  EZTimer.mm
//  EZKit
//
//  Created by macbook pro on 2018/3/20.
//  Copyright © 2018年 sheep. All rights reserved.
//

#import "EZTimer.h"

#define EZTimerQueueName(x) [NSString stringWithFormat:@"NSTimer_%@_queue",x]

#define EZTimerDfaultLeeway 0.1

#define EZTimerDfaultTimeInterval 60

#define EZTIMERSTATUSKEY_RESUME @"EZTIMERSTATUSKEY_RESUME"
#define EZTIMERSTATUSKEY_PAUSE  @"EZTIMERSTATUSKEY_PAUSE"

// #ifdef DEBUG
//     #define EZLog(...) NSLog(__VA_ARGS__)
// #else
    #define EZLog(...)
// #endif

@interface EZTimer()

@property(nonatomic,strong)NSMutableDictionary *timers;

@property(nonatomic,strong)NSMutableDictionary *timersFlags;

@end

@implementation EZTimer

+(instancetype)shareInstance{
    static EZTimer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EZTimer alloc] init];
    });
    
    return instance;
}


-(void)repeatTimer:(NSString*)timerName timerInterval:(double)interval resumeType:(EZTimerResumeType)resumeType action:(EZTimerBlock)action{
    [self timer:timerName timerInterval:interval leeway:EZTimerDfaultLeeway resumeType:resumeType queue:EZTimerQueueTypeGlobal queueName:nil repeats:YES action:action];
}


-(void)timer:(NSString*)timerName timerInterval:(double)interval leeway:(double)leeway resumeType:(EZTimerResumeType)resumeType queue:(EZTimerQueueType)queue queueName:(NSString *)queueName repeats:(BOOL)repeats action:(EZTimerBlock)action{
    
    dispatch_queue_t que = nil;
    if (!timerName) { return; }
    if (!queueName) {
        queueName = EZTimerQueueName(timerName);
    }
    switch (queue) {

        case EZTimerQueueTypeConcurrent:{
            que = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
            break;
        }
        case EZtimerQueueTypeSerial:{
            que = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
            break;
        }
        default:
            que = dispatch_get_global_queue(0, 0);
            break;
    }
    dispatch_source_t timer = [self.timers objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, que);
        [self.timers setObject:timer forKey:timerName];
        //timer 状态标识
        NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithObjectsAndKeys:@0,EZTIMERSTATUSKEY_RESUME,@0,EZTIMERSTATUSKEY_PAUSE, nil];
        [self.timersFlags setObject:dic forKey:timerName];
    }
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (interval==0?EZTimerDfaultTimeInterval:interval) * NSEC_PER_SEC, (leeway == 0 ? EZTimerDfaultLeeway:leeway) * NSEC_PER_SEC);

    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        EZLog(@"tiemr action");
        action(timerName);
        if (!repeats) {
            //dispatch_source_cancel(timer);
            [weakSelf cancel:timerName];
            EZLog(@"tiemr action once");
        }
    });
    if (resumeType == EZTimerResumeTypeNow) {
        //dispatch_resume(timer);
        [self resume:timerName];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), que, ^{
            //dispatch_resume(timer);
            [weakSelf resume:timerName];
        });
    }
}


//当 timer 处于 suspend状态时不能被 释放.
-(void)cancel:(NSString *)timerName{
    
    dispatch_source_t timer = [self.timers objectForKey:timerName];
    //NSAssert(timer, @"%s\n定时器列表中不存在此名称的timer -- %@",__func__,timerName);
    if (!timer) {
        EZLog(@"tiemr cancel retrun - because timer had been cancel");
        return;
    }
    NSMutableDictionary *timerDic = [self.timersFlags objectForKey:timerName];
    if (timerDic && [timerDic[EZTIMERSTATUSKEY_PAUSE] boolValue]) {
        EZLog(@"timer had paused，resume first then cancel it");
        dispatch_resume(timer);
        dispatch_source_cancel(timer);
    }
    [self.timers removeObjectForKey:timerName];
    [self.timersFlags removeObjectForKey:timerName];
    
    EZLog(@"tiemr cancel - cancel");
    
}

-(void)pause:(NSString *)timerName{

    dispatch_source_t timer = [self.timers objectForKey:timerName];
    //NSAssert(timer, @"%s\n定时器列表中不存在此名称的timer -- %@",__func__,timerName);
    if (!timer) {
        return;
    }
    NSMutableDictionary *timerDic = [self.timersFlags objectForKey:timerName];
    if (timerDic && [timerDic[EZTIMERSTATUSKEY_PAUSE] boolValue]) {
        EZLog(@"tiemr pause return- because timer had paused");
        return ;
    }
    dispatch_suspend(timer);
    timerDic[EZTIMERSTATUSKEY_PAUSE] = @1;
    timerDic[EZTIMERSTATUSKEY_RESUME] = @0;
    EZLog(@"tiemr pause - paused" );
    
}

-(void)resume:(NSString *)timerName{
    dispatch_source_t timer = [self.timers objectForKey:timerName];
    //NSAssert(timer, @"%s\n定时器列表中不存在此名称的timer -- %@",__func__,timerName);
    if (!timer) {
        return;
    }
    NSMutableDictionary *timerDic = [self.timersFlags objectForKey:timerName];
    if (timerDic && [timerDic[EZTIMERSTATUSKEY_RESUME] boolValue]) {
        EZLog(@"timer resuem return - because timer had resume");
        return;
    }
    dispatch_resume(timer);
    timerDic[EZTIMERSTATUSKEY_RESUME] = @1;
    timerDic[EZTIMERSTATUSKEY_PAUSE] = @0;
    EZLog(@"tiemr resume - resumed");

}

-(NSMutableDictionary *)timers{
    if (!_timers) {
        _timers = [NSMutableDictionary dictionary];
    }
    return _timers;
}

-(NSMutableDictionary *)timersFlags{
    if (!_timersFlags) {
        _timersFlags = [NSMutableDictionary dictionary];
    }
    return _timersFlags;
}

@end
