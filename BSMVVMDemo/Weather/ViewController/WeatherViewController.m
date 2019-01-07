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
#import "WeatherHeaderView.h"
#import "WeatherTableViewCell.h"
/*Model*/
#import "WeatherDataManager.h"
#import "WeatherModel.h"
#import "WeatherViewModel.h"

@interface WeatherViewController ()<UITableViewDelegate,UITableViewDataSource,WeatherHeaderViewDelegate>

/*view*/
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) WeatherHeaderView *headerView;

/*model*/
@property (nonatomic,strong) WeatherDataManager *dataManager;
@property (nonatomic,strong) WeatherViewModel *viewModel;

@end

@implementation WeatherViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    [self initSubViews];
    [self masonryLayout];
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
    __weak typeof(self)weakSelf = self;
    [self.dataManager getWeatherDataWithCityName:@"北京" weahtherBlock:^(WeatherModel *weatherModel, NSString *errorMsg) {
       
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }else{
            WeatherItemModel *itemModel = [weatherModel.forecast firstObject];
            [weakSelf.viewModel weatherViewModelDisplayHeaderView:weakSelf.headerView weatherModel:itemModel];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - Private
//设置数据
- (void)setupDefault{
    
}

//添加子控件
- (void)initSubViews{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

-(void)masonryLayout{
    
    //因为是demo，没有导入masonry，暂时用frame 代替
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 260);
}


#pragma mark - Action&PrivateDelegate

-(void)weatherHeaderViewRefreshBtnClick{
    [self.headerView.refreshBtn setTitle:@"刷新中..." forState:UIControlStateNormal];
    [self requestData];
}

#pragma mark - SystemDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataManager.weatherModel.forecast.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WeatherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    WeatherItemModel *model = self.dataManager.weatherModel.forecast[indexPath.row];
    [self.viewModel weatherViewModelDisplayCell:cell weatherModel:model];
    
    return cell;
}

#pragma mark - Lazy

-(WeatherDataManager*)dataManager{
    if (!_dataManager) {
        _dataManager = [[WeatherDataManager alloc]init];
    }
    return _dataManager;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(WeatherHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WeatherHeaderView alloc]init];
        _headerView.delegate = self;
    }
    return _headerView;
}

-(WeatherViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[WeatherViewModel alloc]init];
    }
    return _viewModel;
}

@end
