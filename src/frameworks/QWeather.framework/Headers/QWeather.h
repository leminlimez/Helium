//
//  QWeather.h
//  QWeather
//
//  Created by 且随疾风前行 on 2018/5/28.
//  Copyright © 2018年 Song. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for QWeather.
FOUNDATION_EXPORT double QWeatherVersionNumber;

//! Project version string for QWeather.
FOUNDATION_EXPORT const unsigned char QWeatherVersionString[];

//  #import "QWeather.h"


/* 当前版本 2023-06-20 4.17 */

/**
 * 写在前面的（废）话
 *
 */
/**
 * sdk需要开启定位权限，请在工程plist.info文件中添加NSLocationWhenInUseUsageDescription
 */
/**
 * 使用时请仔细阅读相关文档 https://dev.qweather.com/docs/ios-sdk/
 *
 * 其他内容这里不做赘述，祝你写 BUG 愉快
 */

#import <QWeather/AllWeatherInquieirs.h>
#import <QWeather/DataBaseClasses.h>
