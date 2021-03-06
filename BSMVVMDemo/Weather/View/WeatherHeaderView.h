//
//  WeatherHeaderView.h
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeatherHeaderViewDelegate<NSObject>

@optional
-(void)weatherHeaderViewRefreshBtnClick;

@end

@interface WeatherHeaderView : UIView

@property (nonatomic,weak) id <WeatherHeaderViewDelegate> delegate;

@property (nonatomic,strong) UILabel *dateLabel;        //日期
@property (nonatomic,strong) UILabel *temLabel;         //温度显示
@property (nonatomic,strong) UILabel *fengLabel;        //风力
@property (nonatomic,strong) UILabel *typeLabel;        //天气描述

@property (nonatomic,strong) UIButton *refreshBtn;      //刷新按钮


@end
