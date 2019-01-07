//
//  WeatherTableViewCell.h
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeatherTableViewCellDelegate<NSObject>

@optional

@end

@interface WeatherTableViewCell : UITableViewCell

@property (nonatomic,weak) id <WeatherTableViewCellDelegate> delegate;

@property (nonatomic,strong) UILabel *dateLabel;        //日期
@property (nonatomic,strong) UILabel *temLabel;         //温度显示
@property (nonatomic,strong) UILabel *fengLabel;        //风力
@property (nonatomic,strong) UILabel *typeLabel;        //天气描述

@end
