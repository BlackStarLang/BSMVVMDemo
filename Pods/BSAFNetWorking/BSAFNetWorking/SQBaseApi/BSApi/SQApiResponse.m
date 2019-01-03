//
//  SQApiResponse.m
//  SQBJ-IOS
//
//  Created by 一枫 on 2018/9/7.
//  Copyright © 2018年 SQBJ. All rights reserved.
//

#import "SQApiResponse.h"



#pragma 接口成功数据
@implementation SQApiResponse


+(instancetype)responseWithObject:(id)responseObject{
    
    return [[self alloc]initWithData:responseObject];
}


-(instancetype)initWithData:(id)responseObject{
    self = [super init];
    if (self) {
        _responseObject = responseObject;
    }
    return self;
}

@end




#pragma 接口错误数据
@implementation SQApiResponseError


+(instancetype)responseErrorWithError:(NSError *)error{
    
    return [[self alloc]initWithData:error];
}

-(instancetype)initWithData:(NSError*)error{
    self = [super init];
    if (self) {
        _SQError = error;
        [self analysisError:_SQError];
    }
    return self;
}


/**
 错误解析
 
 @param error 要解析的错误
 */
-(void)analysisError:(NSError*)error{
    
    _errorCode = error.code;
    if (error.userInfo[@"statusCode"]) {
        _statusCode = [NSString stringWithFormat:@"%@",error.userInfo[@"statusCode"]].integerValue;
    }

    NSDictionary *errorData = @{@"errorCode":@(error.code),@"statusCode":@(_statusCode),@"domain":error.domain};
    NSMutableDictionary *errorDic = [NSMutableDictionary dictionaryWithDictionary:errorData];
    
    //解析data内的错误
    NSData *data = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
    if (data && data.length>0) {
        id errorDescrip = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        
        if ([errorDescrip isKindOfClass:[NSDictionary class]]) {
             [errorDic setObject:errorDescrip forKey:@"errorDescription"];
        }else{
            [errorDic setObject:@"无法解析userInfo中的data数据" forKey:@"errorAnalysis"];
        }
    }
    [errorDic setObject:error.userInfo forKey:@"originUserInfo"];
    _errorDic = errorDic;
}

@end




