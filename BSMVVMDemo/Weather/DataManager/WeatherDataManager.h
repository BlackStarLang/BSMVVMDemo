//
//  WeatherDataManager.h
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/2.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherModel;

@interface WeatherDataManager : NSObject

-(void)getWeatherDataWithCityName:(NSString *)cityName weahtherBlock:(void(^)(WeatherModel *weatherModel,NSString *errorMsg))block;


@end
