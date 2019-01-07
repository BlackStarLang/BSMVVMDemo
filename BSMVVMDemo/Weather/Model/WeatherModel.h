//
//  WeatherModel.h
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherItemModel;

@interface WeatherModel : NSObject

@property (nonatomic,copy) NSString *city;          //城市名称

@property (nonatomic,copy) NSArray<WeatherItemModel*> *forecast;        //天气预测列表

@end


@interface WeatherItemModel : NSObject

@property (nonatomic,copy) NSString *date;          //日期
@property (nonatomic,copy) NSString *fengli;        //风力
@property (nonatomic,copy) NSString *fengxiang;     //风向
@property (nonatomic,copy) NSString *high;          //最高气温
@property (nonatomic,copy) NSString *low;           //最低气温
@property (nonatomic,copy) NSString *type;          //天气描述 ：雨雪雾霾等

@end
