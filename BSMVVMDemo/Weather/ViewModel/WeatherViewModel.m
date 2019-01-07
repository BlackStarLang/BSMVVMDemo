//
//  WeatherViewModel.m
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import "WeatherViewModel.h"
#import "WeatherTableViewCell.h"
#import "WeatherModel.h"
#import "WeatherHeaderView.h"

@implementation WeatherViewModel

-(void)weatherViewModelDisplayCell:(WeatherTableViewCell *)cell weatherModel:(WeatherItemModel *)weatherModel{
    
    cell.dateLabel.text = weatherModel.date;
    
    NSString *flStr = [weatherModel.fengli stringByReplacingOccurrencesOfString:@"<![CDATA[" withString:@""];
    flStr = [flStr stringByReplacingOccurrencesOfString:@"]]>" withString:@""];
    
    NSString *fengli = [NSString stringWithFormat:@"%@  %@",weatherModel.fengxiang,flStr];
    cell.fengLabel.text = fengli;

    NSString *temprature = [NSString stringWithFormat:@"气温：%@ - %@",weatherModel.low,weatherModel.high];
    cell.temLabel.text = temprature;
    
    cell.typeLabel.text = weatherModel.type;
}


-(void)weatherViewModelDisplayHeaderView:(WeatherHeaderView *)headerView weatherModel:(WeatherItemModel*)weatherModel{
    
    headerView.dateLabel.text = weatherModel.date;
    
    NSString *flStr = [weatherModel.fengli stringByReplacingOccurrencesOfString:@"<![CDATA[" withString:@""];
    flStr = [flStr stringByReplacingOccurrencesOfString:@"]]>" withString:@""];
    
    NSString *fengli = [NSString stringWithFormat:@"%@  %@",weatherModel.fengxiang,flStr];
    headerView.fengLabel.text = fengli;
    
    NSString *temprature = [NSString stringWithFormat:@"%@ - %@",weatherModel.low,weatherModel.high];
    headerView.temLabel.text = temprature;
    
    headerView.typeLabel.text = weatherModel.type;
    [headerView.refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
}


@end
