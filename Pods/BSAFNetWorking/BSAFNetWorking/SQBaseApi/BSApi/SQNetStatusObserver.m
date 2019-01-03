//
//  SQNetStatusObserver.m
//  SQBJ-IOS
//
//  Created by 一枫 on 2018/10/30.
//  Copyright © 2018 SQBJ. All rights reserved.
//

#import "SQNetStatusObserver.h"

@interface SQNetStatusObserver ()

@property(nonatomic,strong)AFNetworkReachabilityManager* reachabilityManager;

@end


@implementation SQNetStatusObserver

+(instancetype)shareNetStatusObserver{
    
    static SQNetStatusObserver *netStatus = nil;
    if (!netStatus) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            netStatus = [[SQNetStatusObserver alloc]init];
        });
    }
    return netStatus;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //网络监测 监听初始化
        [self CheckNetStatus];
    }
    return self;
}

-(void)startMonitoring{
    [self.reachabilityManager startMonitoring];
}

-(void)stopMonitoring{
    [self.reachabilityManager stopMonitoring];
}

-(void)CheckNetStatus{
    
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    __weak typeof(self)weakSelf = self;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         -1 未知网络
         0  网络不可用
         1  4G网络
         2  WiFi
         */
        NSLog(@"网络状态值含义：  -1：未知网络，  0：网络不可用，    1：4G网络， 2：WiFi ");
        NSLog(@"网络状态监听值：  %ld",(long)status);
        if ([weakSelf.netStatusDelegate respondsToSelector:@selector(netWorkStatus:)]) {
            [weakSelf.netStatusDelegate netWorkStatus:status];
        }
        if (status == 0|| status == -1) {
            if ([weakSelf.netStatusDelegate respondsToSelector:@selector(netWorkClosed)]) {
                [weakSelf.netStatusDelegate netWorkClosed];
            }
        }else{
            if ([weakSelf.netStatusDelegate respondsToSelector:@selector(netWorkOpened:)]) {
                [weakSelf.netStatusDelegate netWorkOpened:status];
            }
        }
    }];
}


@end
