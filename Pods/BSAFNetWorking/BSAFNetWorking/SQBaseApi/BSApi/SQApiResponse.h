//
//  SQApiResponse.h
//  SQBJ-IOS
//
//  Created by 一枫 on 2018/9/7.
//  Copyright © 2018年 SQBJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 网络请求数据模型
 
 网络请求成功 statusCode:200 时
 */
@interface SQApiResponse : NSObject

@property(nonatomic, strong) id responseObject;                // 返回原始数据

+ (instancetype)responseWithObject:(id)responseObject;

@end



/**
 网络请求成功 statusCode !=200 时
 */
@interface SQApiResponseError : NSObject

@property(nonatomic, strong) NSError *SQError;                 // 请求错误模型
@property(nonatomic, strong) NSDictionary *errorDic;           // 请求错误信息data解析
@property (nonatomic, assign) NSInteger errorCode;             // 错误码(NSError的code)
@property (nonatomic, assign) NSInteger statusCode;            // HTTP错误码（此错误码是httprespons的code）
@property (nonatomic, copy) NSString * errorMsg;               // 错误信息

+ (instancetype)responseErrorWithError:(NSError*)error;

@end

