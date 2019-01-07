//
//  WeatherTableViewCell.m
//  BSMVVMDemo
//
//  Created by 一枫 on 2019/1/3.
//  Copyright © 2019 BlackStar. All rights reserved.
//

#import "WeatherTableViewCell.h"

@interface WeatherTableViewCell ()

@end

@implementation WeatherTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

- (void)initSubViews{
    
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.temLabel];
    [self.contentView addSubview:self.fengLabel];
    [self.contentView addSubview:self.typeLabel];
}

- (void)masonryLayout{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    self.dateLabel.frame = CGRectMake(20, 10, 300, 20);
    self.temLabel.frame = CGRectMake(20, 30, 300, 20);
    self.fengLabel.frame = CGRectMake(20, 50, screenWidth - 40, 20);
    self.typeLabel.frame = CGRectMake(screenWidth - 120, 10, 100, 20);
}


#pragma mark - Lazy

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
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
    }
    return _temLabel;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textAlignment = 2;
    }
    return _typeLabel;
}

@end
