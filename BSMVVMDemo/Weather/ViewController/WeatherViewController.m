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
#import "WeatherDataManager.h"

@interface WeatherViewController ()

/*view*/

/*model*/
@property (nonatomic,strong) WeatherDataManager *dataManager;

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
//    __weak typeof(self)weakSelf = self;
    [self.dataManager getWeatherDataWithCityName:@"beijing" weahtherBlock:^(WeatherModel *weatherModel, NSString *errorMsg) {
       
        if (errorMsg) {
            NSLog(@"获取天气失败");
        }else{
            
        }
    }];
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

-(WeatherDataManager*)dataManager{
    if (!_dataManager) {
        _dataManager = [[WeatherDataManager alloc]init];
    }
    return _dataManager;
}

@end
