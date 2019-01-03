//
//  WeatherViewController.m
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/2.
//  Copyright © 2019 BlackStar. All rights reserved.
//

//VC
#import "WeatherViewController.h"

/*View*/

/*Model*/

@interface WeatherViewController ()

/*view*/

/*model*/

@end

@implementation WeatherViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    [self initSubViews];
    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    
}

#pragma mark - Network
//主网络
- (void)requestData{
    
}

#pragma mark - Private
//设置数据
- (void)setupDefault{
    
}

//添加子控件
- (void)initSubViews{
    
}

//主网络处理
- (void)handleWithMainModel{
    
}

#pragma mark - Action&PrivateDelegate


#pragma mark - SystemDelegate


#pragma mark - Lazy


@end
