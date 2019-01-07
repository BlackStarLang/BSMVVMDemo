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

@end

@interface WeatherHeaderView : UIView

@property (nonatomic,weak) id <WeatherHeaderViewDelegate> delegate;

@end
