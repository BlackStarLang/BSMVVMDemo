//
//  WeatherDataManager.m
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/2.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import "WeatherDataManager.h"
#import <BSAFNetwroking.h>
#import "WeatherModel.h"

@implementation WeatherDataManager

-(void)getWeatherDataWithCityName:(NSString *)cityName weahtherBlock:(void (^)(WeatherModel *, NSString *))block{
    
    NSString *url = [NSString stringWithFormat:@"https://www.apiopen.top/weatherApi?city=%@",cityName];
    
    SQApiRequestManager *manager = [SQApiRequestManager requestWithUrl:url parameter:nil requestMethod:REQUEST_GET];
    
    [manager startRequestWithSuccess:^(SQApiResponse *response) {
        
        NSLog(@"天气信息：%@",response.responseObject);
        WeatherModel *model = [[WeatherModel alloc]init];
        
        block(model,nil);
        
    } failure:^(SQApiResponseError *error) {
        block(nil,@"获取天气失败");
    }];
}

@end
