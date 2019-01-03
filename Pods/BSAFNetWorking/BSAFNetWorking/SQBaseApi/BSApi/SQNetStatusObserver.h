//
//  SQNetStatusObserver.h
//  SQBJ-IOS
//
//  Created by 一枫 on 2018/10/30.
//  Copyright © 2018 SQBJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SQNetStatusObserverDelegate <NSObject>

@optional

/**
 网络状态监测结果：开启状态(4G或WiFi)
 
 @param netWorkStatus 状态为1：4g网络，状态2：WiFi网络
 */
-(void)netWorkOpened:(AFNetworkReachabilityStatus)netWorkStatus;


/**
 网络状态监测结果：关闭状态
 */
-(void)netWorkClosed;

/**
 网络状态监听
 
 @param netWorkStatus 网络状态
 */
-(void)netWorkStatus:(AFNetworkReachabilityStatus)netWorkStatus;


@end

/**
 网络状态监听
 */
@interface SQNetStatusObserver : NSObject

@property(nonatomic,weak) id<SQNetStatusObserverDelegate> netStatusDelegate;  //网络监听代理


+(instancetype)shareNetStatusObserver;

-(void)startMonitoring;

-(void)stopMonitoring;


@end

NS_ASSUME_NONNULL_END
