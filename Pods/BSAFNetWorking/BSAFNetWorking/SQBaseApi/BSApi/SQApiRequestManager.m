//
//  SQApiRequestManager.m
//  SQBJ-IOS
//
//  Created by 一枫 on 2018/8/25.
//  Copyright © 2018年 SQBJ. All rights reserved.
//

#import "SQApiRequestManager.h"

@interface SQApiRequestManager ()

@property (nonatomic,copy)NSString *url;
@property (nonatomic,strong)NSDictionary *parameter;
@property (nonatomic,strong)NSMutableURLRequest *currentRequest;        //当前请求的URLRequest


@end

@implementation SQApiRequestManager


+(instancetype)requestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter requestMethod:(NSString *)requestMethod{
    
    return [[self alloc]initRequestWithUrl:url parameter:parameter requestMethod:requestMethod];
}

-(instancetype)initRequestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter requestMethod:(NSString *)requestMethod{
    
    self = [super init];
    if (self) {
       
        _sessionManager = [[AFHTTPSessionManager alloc]init];
        //请求设置
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sessionManager.requestSerializer.timeoutInterval = 45;
//        if ([url hasSuffix:@"https://"]) {
//            [_sessionManager setSecurityPolicy:[self customSecurityPolicy]];
//        }

        //请求响应设置
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/xml",@"multipart/form-data", nil];

        //参数全局接收
        //对中文进行编码
        NSString *encodeUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
        self.url = encodeUrl;
        self.parameter = parameter;
        
        self.headerParam = [NSMutableDictionary dictionary];
        self.requestMethod = requestMethod;
        self.isBodyRequest = NO;
        
       
    }
    return self;
}

-(void)startRequestWithSuccess:(SQApiSuccessBlock)successBlock failure:(SQApiFailureBlock)failure{
    
    self.successBlock = successBlock;
    self.failureBlock = failure;
    [self initRequest];
    [self startRequest];
}

-(void)initRequest{
    if (!self.currentRequest) {
        self.currentRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:_requestMethod URLString:self.url parameters:self.isBodyRequest?nil:self.parameter error:nil];
    }
    if (self.isBodyRequest) {
        //将参数转为data
        NSError *error = nil;
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:self.parameter options:NSJSONWritingPrettyPrinted|NSJSONReadingMutableContainers error:&error];
        if (!error) {
            //将body体进行U8编码，在转data
            NSString *paramString = [[NSString alloc] initWithData:paramData encoding:NSUTF8StringEncoding];
            NSData *body  =[paramString dataUsingEncoding:NSUTF8StringEncoding];
            
            [self.currentRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self.currentRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [self.currentRequest setHTTPBody:body];
            
        }else{
            NSLog(@"body体为空");
        }
    }
}

-(void)startRequest{

    [self setRequestHeader];
    
    //如果是表单格式,则将requestSerializer设置成AFHTTPRequestSerializer不是json
    if ([self.headerParam[@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"]) {
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    //发起请求
    [[_sessionManager dataTaskWithRequest:self.currentRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200) {
            SQApiResponse *response = [SQApiResponse responseWithObject:responseObject];
            self.successBlock(response);
        }else{
            
            //将error的UserInfo改造成 带有httpResponse.statusCode的UserInfo
            NSMutableDictionary *myUserInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
            [myUserInfo setObject:@(httpResponse.statusCode) forKey:@"statusCode"];
            [myUserInfo setObject:@"网络请求错误，请检查网络是否可用" forKey:@"errorMsg"];

            NSError *myError = [[NSError alloc]initWithDomain:error.domain code:error.code userInfo:myUserInfo];
            SQApiResponseError *responseError = [SQApiResponseError responseErrorWithError:myError];
            responseError.errorMsg = @"网络请求错误，请检查网络是否可用";
            self.failureBlock(responseError);
        }
    }]resume];
}


/**
 设置请求头
 */
-(void)setRequestHeader{
    __weak typeof(self)weakSelf = self;
    [self.headerParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weakSelf.currentRequest setValue:weakSelf.headerParam[key] forHTTPHeaderField:key];
    }];
}



#pragma mark 设置HTTPS证书验证
- (AFSecurityPolicy *)customSecurityPolicy{
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"证书名字" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    if (certData.length<=0) {
        return nil;
    }
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    //securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}



@end
