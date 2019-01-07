//
//  WeatherViewModel.h
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherTableViewCell;
@class WeatherItemModel;
@class WeatherHeaderView;

@interface WeatherViewModel : NSObject

/**
 展示cell

 @param cell 需要展示的cell
 @param weatherModel 天气模型
 */
-(void)weatherViewModelDisplayCell:(WeatherTableViewCell*)cell weatherModel:(WeatherItemModel*)weatherModel;


/**
 展示当天的天气信息

 @param headerView headerView
 @param weatherModel 天气信息
 */
-(void)weatherViewModelDisplayHeaderView:(WeatherHeaderView*)headerView weatherModel:(WeatherItemModel*)weatherModel;


@end
