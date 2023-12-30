//
//  QWeatherBaseModel.h
//  QWeather
//
//  Created by he on 2018/7/30.
//  Copyright © 2018年 Song. All rights reserved.
//

#import <Foundation/Foundation.h>
//200    请求成功
//270    请求成功，但你查询的地区没有数据，例如查询某一个城市的预警信息，当该城市没有预警的情况下，会返回270代码。
//271    请求成功，但你查询的这个地区不存在，或者地区名称错误。
//400    请求错误，可能包含错误的请求参数或缺少必选的请求参数。
//401    错误的KEY，或签名算法错误，导致无法认证成功。
//402    超过访问次数或余额不足以支持继续访问服务，你可以充值、升级访问量或等待访问量重置。
//403    无访问权限，你没有购买你所访问的这部分服务。
//429    超过限定的QPM（每分钟访问次数），请参考QPM说明
//470    你的KEY不适用于当前获取数据的方式，例如使用SDK的KEY去访问Web API。
//471    错误的绑定，例如绑定的package name、bundle id或域名IP地址不一致的时候。
//500    无响应或超时，接口服务异常请联系我们
@interface QWeatherBaseModel : NSObject<NSCoding, NSCopying>

@end
