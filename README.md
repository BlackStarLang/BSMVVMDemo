# BSMVVMDemo
架构初探，如何设计一个简单的架构 <br/>

这套方案使用的依赖三方是：BSAFNetWorking,Masonry，YYModel,<br/>
如果不使用Masonry和YYModel 开发成本会很高，<br/>
当然 这两个三方也是可以替换成别的，只要能完成相应工作即可

题外话：demo中使用的网络 是封装的 AFNetWorking ，<br/>
叫做BSNetWorking[点击查看源代码](https://github.com/BlackStarLang/BSAFNetWorking.git) ，<br/>
支持pod,  使用方式 pod 'BSAFNetWorking'


正文<br/>
*此观点仅是小白的我个人理解，轻喷*

>一千个观众眼中有一千个哈姆雷特（There are a thousand Hamlets in a thousand people's eyes.）-- 莎士比亚

>一千个程序员中眼里有一千种架构 （There are a thousand framework in a thousand developer's eyes.）-- BlackStar

~~和莎士比亚并列有木有很高端， 哈哈哈~~ 有点装逼了 sorry
***
***
言归正传，由于老大要求重构项目，让我们研究下架构，那好吧，虽然啥都不懂，但是对这方面还是希望有所了解的，所以 baidu、google、github ...

经过一番 ~~查找~~ 研究，发现嗯...

架构这东西就是为了更好的贴合业务，便于测试，查找问题，修改，后续他人接手

反正好处一堆一堆的，但是我是小白啊，一次怎么可能弄那么高端，那就别好高骛远，先整个初级的，然后经过一周的研究，整理出来这个模式。我称之为 二次元MVVM

**UI上全部采用 Masonry 布局，个别需要用到frame的灵活运用
Model 全部采用 YYModel  进行解析**

目录结构：

- ViewController  处理交互相关
- View   单纯视图
- Model    数据模型            
- ViewModel   数据展示
- DataManager 数据请求、缓存处理

目前由于老大的要求，我们建立了很多 Base基类 包含ViewController、Model、ViewModel、DataManager，其实View 也是有的，但是感觉没有用到，就没有用，先说下Base里做的事情
- ViewController  tableview 初始化、加载更多、下拉刷新、网络请求的加载框等功能都在这里做了，子类只需要调用父类方法就可以，反正老大的要求就是能提到父类的就都提到父类
***但是我个人并不喜欢这样做，因为基类会大大增加文件之间的耦合性，如果要做一些公共的东西可以使用category，但是并不能达到完全解耦的目的，模块间或多或少都会有业务上的联系，我们不能因为想要做模块分离就忽略其带来的不便，说到底，我们的架构是服务于业务的，所以要以业务为主，由于找不到更好的方案处理，所以就还是按照老大的要求来了***

- View  这一层只是做视图处理，不绑定任何数据，目的就是为了view&model彻底分离，这样的好处是复用，UI测试，由于视图往往跟随者交互，那么如何处理交互成了需要解决的问题，我们需要考虑点击后进行网络请求、进行数据变更、进行提示框弹出、页面跳转等多种情况，但是很多事情其实在View里做并不合适，所以决定所有的交互在VC层做，那么View的事件如何传递到VC层呢，三种方案：block、protocol、在vc层通过.view.button addTarget 方式执行交互，但是考虑到block 的设计问题（最大的问题：查找bug太费劲）所以弃用，如果通过 .view.button 的方式呢，可以做，但是我们有的事情是在view里直接处理的，比如说点击按钮数量+1，这种可能不需要其他的判断或网络交互，那么我们就需要在view 和vc层分别处理不同的事情，这样与我设计的代码规范不一致（职责划分），所以最终采用protocol方式处理，protocol使用时，代码上要注意，调用的时候需要做 
``` 
if ([self.delegate respondsToSelector:@selector()]) {
    [self.delegate ...];
}
```
- Model  数据模型，自身属性+数据验证
- ViewModel 只做数据展示，那么如何把 需要展示数据的view 和 Model 关联起来呢，直接用一个方法把两个参数传进来即可
示例代码：
.h文件
``` Object-C
#import "SQBaseViewModel.h"

@class SQPropertyPaymentDetailCell;
@class SQProPayHistoryHeaderView;

@interface SQProPayViewModel : SQBaseViewModel

-(void)propertyPaymentDetailHeaderView:(SQProPayHistoryHeaderView*)headerView houseInfo:(NSDictionary *)houseInfo searchType:(NSString *)searchType;

-(void)propertyPaymentDetailCell:(SQPropertyPaymentDetailCell *)cell  cellInfoKey:(NSString*)key cellInfoValue:(NSString*)value;

@end
```
.m文件
```
#import "SQProPayViewModel.h"
#import "SQPropertyPaymentDetailCell.h"
#import "SQProPayHistoryHeaderView.h"

@implementation SQProPayViewModel

-(void)propertyPaymentDetailCell:(SQPropertyPaymentDetailCell *)cell cellInfoKey:(NSString *)key cellInfoValue:(NSString *)value{
    
    if ([key isEqualToString:@"watermarkImg"]) {
        if ([value isEqualToString:@"1"]) {
            cell.watermarkImg.image = [UIImage imageNamed:@"pay_finish_recieve"];
        }else{
            cell.watermarkImg.image = [UIImage imageNamed:@"pay_finish_refund"];
        }
    }else{
        
        if ([key isEqualToString:@"houseLabel"]) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"房间：%@",value?:@""]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 3)];
            cell.houseLabel.attributedText = attr;
            
        }else if ([key isEqualToString:@"houseKeeper"]){
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"业主：%@",value?:@""]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 3)];
            cell.houseKeeper.attributedText = attr;
            
        }else if ([key isEqualToString:@"telLabel"]){
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"手机：%@",value?:@""]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 3)];
            cell.telLabel.attributedText = attr;
            
        }else if ([key isEqualToString:@"timeLabel"]){
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"收费时间：%@",value?:@""]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
            cell.timeLabel.attributedText = attr;
            
        }else{
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"收费人：%@",value?:@""]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 4)];
            cell.tollCollector.attributedText = attr;
        }
    }
}


-(void)propertyPaymentDetailHeaderView:(SQProPayHistoryHeaderView *)headerView houseInfo:(NSDictionary *)houseInfo searchType:(NSString *)searchType{

    if (!houseInfo) return;
    
    if ([searchType isEqualToString:@"1"]) {

        NSString *addresStr = [NSString stringWithFormat:
                               @"%@%@%@%@%@%@%@%@",
                               houseInfo[@"manageAreaName"],
                               houseInfo[@"projectName"],
                               houseInfo[@"buildingNumber"],
                               houseInfo[@"buildingName"],
                               houseInfo[@"unitNumber"],
                               houseInfo[@"unitName"],
                               houseInfo[@"houseNumber"],
                               houseInfo[@"houseName"]];
        
        headerView.addressLabel.text = addresStr;
    }else{
        
        headerView.nameLabel.text = [NSString stringWithFormat:@"业主：%@   %@",houseInfo[@"name"],houseInfo[@"phone"]];
    }
}

@end
```
其中需要注意的点：
1. .h文件中使用@class引入，告诉编译器这个是个类，不要报错，然后在.m中 #import ， 这样做的目的就是减少编译时间
2. 要使用此方式，需要所有的 view 将属性（控件）全部声明在.h 中，以便调用和 复用的时候UI 微调。之所以这么设计是参考了storyboard的设计理念。xcode创建出来的view 在.m中是没有@interface的，意思就是建议我们将 视图属性添加在.h中，所以我们在用storyboard做view的构建时，都是拉线到.h中，只有viewcontroller的才会在.m中。而且这么设计最大的好处是复用，不是所有UI都是一样的设计，但可能很相近，我们做一个控件应该尽可能的让其胜任多种情况。

- DataManager 数据管理层，这一层其实做的并不好，因为这里我采用的是block 传值，这种方式最大的缺点是会延长controller 的生命周期，但是当时做的时候只考虑了 代码追踪问题，所以不是很理想。这一层主要的代码都在基类里边，封装了缓存方法，还有一些 接口调用时的公用方法。在使用的时候很简单 **这里不贴Base了**
示例代码：
```
#import "SQBaseDataManager.h"

@class SQPropertyPaymentListModel;
@class SQProPaymentPreviewModel;
@class SQProPayHistoryModel;
@class SQProPayBillPreviewDetailModel;
@class SQProPreviewPayInfoModel;

@interface SQPropertyPaymentDataManager : SQBaseDataManager

@property (nonatomic,strong) SQPropertyPaymentListModel *proPaymentListModel;       //物业缴费列表
@property (nonatomic,strong) SQProPaymentPreviewModel *proPaymentPreviewModel;      //物业缴费预览模型
@property (nonatomic,strong) SQProPayHistoryModel *historyModel;                    //物业缴费历史记录模型
@property (nonatomic,strong) SQProPayBillPreviewDetailModel *tollModel;             //缴费单详情模型
@property (nonatomic,strong) SQProPreviewPayInfoModel *payInfoModel;                //缴费信息模型

/**
 获取物业缴费单

 @param addressId 房屋对硬的地区ID
 @param categoryId  1：常规费用 | 2：临时费用
 */
-(void)getPropertyPaymentFeeListWithAddressId:(NSString *)addressId categoryId:(NSString *)categoryId block:(void(^)(SQPropertyPaymentListModel *classifyModel,NSString* errMsg))block;

```
.m文件
```
-(void)getPropertyPaymentFeeListWithAddressId:(NSString *)addressId categoryId:(NSString *)categoryId block:(void (^)(SQPropertyPaymentListModel *, NSString *))block{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/apps/bpps/bpp/bill/roomFeeSum",LocalCfg.SQ_PROPERTY_BASE];
    
    NSDictionary *param = @{@"addressId":addressId,
                            @"categoryId":categoryId};
    
    SQLeApiRequest *request = [SQLeApiRequest requestWithUrl:url param:param];
    request.requestMethod = REQUEST_GET;
    [request setLeHeader:@{@"Authorization":@"yes"} needSign:NO needAccessToken:YES];
    
    [request startRequestWithSuccess:^(SQApiResponse *response) {
       
        SQPropertyPaymentListModel *classifyModel = [SQPropertyPaymentListModel modelWithOriginData:response.responseObject];
        self.proPaymentListModel = classifyModel;
        block(classifyModel,nil);
        
    } failure:^(NSError *error) {
        block(nil,@"请求失败，请重试");
    }];    
}

```
1. 设计考虑到数据模型使用问题，因为dataManager 是要在VC层声明的，所以将model声明在了dataManager里，网络回调后在dataManager里直接赋值，包含加载更多后的数据拼接等，都可以在dataManager里去实现，帮controller分担了数据整合的问题
2. 缓存的调用也是在dataManager里实现的，在调用方法的同时block先回调缓存的数据，数据回来后，在此block回调接口数据

目前总结的差不多就是这此研究架构的一些心得，在开发中我们需要便捷开发，快速开发，很多重复性的工作我们应该尽可能的只做一遍，所以像view层的 protocol 我这里都是创建的时候自带的，不用一遍一遍去声明。

[如何创建文件自动生成我们常用的代码，点击进入](https://www.jianshu.com/p/85b0581ace8c)

对于架构的初探还有一些没有写出来，比如说网络层、工具层，后续可能会补也可能不补
