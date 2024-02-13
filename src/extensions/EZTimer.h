//
//  EZTimer.h
//  EZKit
//
//  Created by macbook pro on 2018/3/20.
//  Copyright © 2018年 sheep. All rights reserved.
//

#import <Foundation/Foundation.h>

///线程选择
typedef NS_ENUM(NSUInteger, EZTimerQueueType) {
    EZTimerQueueTypeGlobal,
    EZTimerQueueTypeConcurrent,
    EZtimerQueueTypeSerial,
};

///timer执行方式选择，默认立刻执行一次，此时block会立刻执行，next表示下一个interval执行。
typedef NS_ENUM(NSUInteger, EZTimerResumeType) {
    EZTimerResumeTypeNow,
    EZTimerQueueTypeNext,
};

typedef void (^EZTimerBlock)(NSString *timerName);

@interface EZTimer : NSObject
/**
 * 单例模式
 */
+(instancetype)shareInstance;

/**
 * 简单方式创建并执行timer，其他未给出的参数均为默认参数
 * timerName timer的名称，创建好的timer以name为key存储于timers字典中
 * interval timer时间间隔
 * resumeType 是否立刻开始执行，默认立刻开始执行，此时block会立刻执行，next下一个interval执行
 * action   timer回调
 */
-(void)repeatTimer:(NSString*)timerName timerInterval:(double)interval resumeType:(EZTimerResumeType)resumeType action:(EZTimerBlock)action;

/**
 * 简单方式创建并执行timer
 * timerName timer的名称，创建好的timer以name为key存储于timers字典中，必须
 * interval timer时间间隔 0 默认60s
 * leeway timer的精度，默认0.1s
 * resumeType 是否立刻开始执行，默认立刻开始执行，此时block会立刻执行，next下一个interval执行
 * queue 创建timer所在的线程，默认global
 * queueName 线程命名，当global时name不起作用。
 * repeats 是否重复运行
 * action  timer回调
 */
-(void)timer:(NSString*)timerName timerInterval:(double)interval leeway:(double)leeway resumeType:(EZTimerResumeType)resumeType queue:(EZTimerQueueType)queue queueName:(NSString *)queueName repeats:(BOOL)repeats action:(EZTimerBlock)action;

/**
 * 注销此timer
 * timerName timer名称
 */
-(void)cancel:(NSString *)timerName;
/**
 * 暂停此timer
 * 暂停及恢复的操作不建议使用，这两个操作需配对使用，
 * 不然会出现崩溃，原因是source未提供检测状态的接口
 * timerName timer名称
 */
-(void)pause:(NSString *)timerName;
/**
 * 恢复此timer
 * 暂停及恢复的操作不建议使用，这两个操作需配对使用，
 * 不然会出现崩溃，原因是source未提供检测状态的接口
 * timerName timer名称
 */
-(void)resume:(NSString *)timerName;

@end
