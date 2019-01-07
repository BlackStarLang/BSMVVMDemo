//
//  WeatherHeaderView.m
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import "WeatherHeaderView.h"

@interface WeatherHeaderView ()

@end

@implementation WeatherHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

#pragma mark - Layout

- (void)initSubViews{
    
    [self addSubview:self.dateLabel];
    [self addSubview:self.fengLabel];
    [self addSubview:self.temLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.refreshBtn];
}


- (void)masonryLayout{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.dateLabel.frame = CGRectMake(screenWidth - 320, 80, 300, 20);
    self.temLabel.frame = CGRectMake(screenWidth - 320, 120, 300, 20);
    self.typeLabel.frame = CGRectMake(20, 120, 100, 20);
    self.fengLabel.frame = CGRectMake(20, 160, screenWidth - 40, 20);
    self.refreshBtn.frame = CGRectMake(screenWidth/2 - 50, 200, 100, 35);
}

#pragma mark - Action

-(void)refreshBtnClick{
    if ([self.delegate respondsToSelector:@selector(weatherHeaderViewRefreshBtnClick)]) {
        [self.delegate weatherHeaderViewRefreshBtnClick];
    }
}

#pragma mark - Lazy

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textAlignment = 2;
    }
    return _dateLabel;
}

-(UILabel *)fengLabel{
    if (!_fengLabel) {
        _fengLabel = [[UILabel alloc]init];
    }
    return _fengLabel;
}

-(UILabel *)temLabel{
    if (!_temLabel) {
        _temLabel = [[UILabel alloc]init];
        _temLabel.textAlignment = 2;
        _temLabel.font = [UIFont systemFontOfSize:21];
    }
    return _temLabel;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:21];
    }
    return _typeLabel;
}

-(UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc]init];
        _refreshBtn.layer.cornerRadius = 3;
        _refreshBtn.layer.masksToBounds = YES;
        _refreshBtn.layer.borderWidth = 1;
        _refreshBtn.layer.borderColor = [UIColor colorWithRed:41/255.0 green:201/255.0 blue:133/255.0 alpha:1].CGColor;
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:201/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}


@end
