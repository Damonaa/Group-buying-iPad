//
//  XYDetailViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/7.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDetailViewController.h"
#import "XYDeal.h"
#import "XYLineLabel.h"
#import "XYRestrictions.h"
#import "XYDealTool.h"
#import "XYGetSingleDealParam.h"
#import "XYGetSingleDealResult.h"
#import "MBProgressHUD+CZ.h"
#import "XYDealLocalTool.h"
#import "UIImageView+WebCache.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface XYDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *urlStr;
/**
 *  加载进度圈
 */
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet XYLineLabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refoundAnyBtn;
@property (weak, nonatomic) IBOutlet UIButton *refoundDeadlineBtn;
@property (weak, nonatomic) IBOutlet UIButton *deadlineTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *saleCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
- (IBAction)buyNow;
- (IBAction)collect;
- (IBAction)share;
- (IBAction)dismiss;


@end

@implementation XYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XYGlobalBG;
    self.webView.backgroundColor = XYGlobalBG;
    self.webView.scrollView.hidden = YES;
    //设置详情
    [self setupDetailInfo];
    
    [self loadMoreDetail];
    //加载H5数据
    NSString *dealID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
    self.urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", dealID];
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    //启动圈圈
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_webView addSubview:loadingView];
    [loadingView autoCenterInSuperview];
    [loadingView startAnimating];
    self.loadingView = loadingView;
    
    
    //保存浏览记录到沙盒
    [[XYDealLocalTool shareDealLocalTool] saveHistoryDeal:self.deal];
}
//加载详情
- (void)loadMoreDetail{
    
    XYGetSingleDealParam *param = [[XYGetSingleDealParam alloc] init];
    param.deal_id = self.deal.deal_id;
    
    [XYDealTool getSingleDealWithParam:param success:^(XYGetSingleDealResult *result) {
        //覆盖原有的deal数据
//        XYLog(@"%@", result.mj_keyValues);
        if (result.deals.count) {
            self.deal = [result.deals lastObject];
            //重新设置详情的数据
            [self setupDetailInfo];
        }else{
            [MBProgressHUD showError:@"没有找到指定的团购信息" toView:self.navigationController.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"没有找到指定的团购信息" toView:self.navigationController.view];
    }];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
//设置详情展示的信息
- (void)setupDetailInfo{
    self.titleLabel.text = _deal.title;
    self.descLabel.text = _deal.desc;
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", _deal.current_price];
    self.listPriceLabel.text = [NSString stringWithFormat:@"门店价￥%@", _deal.list_price];
    self.refoundAnyBtn.selected = _deal.restrictions.is_refundable;
    self.refoundDeadlineBtn.selected = _deal.restrictions.is_refundable;
    self.saleCountBtn.title = [NSString stringWithFormat:@"已售%ld", _deal.purchase_count];
    self.collectBtn.selected = _deal.isCollected;
    [self.dealImage sd_setImageWithURL:[NSURL URLWithString:_deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if ([webView.request.URL.absoluteString isEqualToString:self.urlStr]) {
        NSMutableString *js = [NSMutableString string];
        [js appendString:@"var bodyHTML = '';"];
        //link
        [js appendString:@"var link = document.body.getElementsByTagName('link')[0];"];
        [js appendString:@"bodyHTML += link.outerHTML;"];
        //div
        [js appendString:@"var divs = document.getElementsByClassName('detail-info');"];
        [js appendString:@"for (var i = 0; i <= divs.length; i++) {"];
        [js appendString:@"var div = divs[i];"];
        [js appendString:@"if(div){ bodyHTML += div.outerHTML;}"];
        [js appendString:@"}"];
        //body
        [js appendString:@"document.body.innerHTML = bodyHTML;"];
        //加载新网页
        [webView stringByEvaluatingJavaScriptFromString:js];
        webView.scrollView.hidden = NO;
        [self.loadingView removeFromSuperview];
    }
}

/**
 *  js
 var textSee = document.getElementsByTagName('html')[0];
 alert(textSee.outerHTML);
 */

- (IBAction)buyNow {
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
#warning 需要填写商户app申请的
    NSString *appID = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = self.deal.title;
    order.biz_content.subject = self.deal.desc;
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [dateF stringFromDate:[NSDate date]];
    
    order.biz_content.out_trade_no = [NSString stringWithFormat:@"%@%@",self.deal.deal_id, dateStr]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",self.deal.current_price.floatValue]; //商品价格
    order.biz_content.seller_id = seller;
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"tuangouHD";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

    
}

- (IBAction)collect {
    
    self.collectBtn.selected = !self.collectBtn.isSelected;
    
    if (self.collectBtn.isSelected) {//收藏
        self.deal.collected = YES;
        [[XYDealLocalTool shareDealLocalTool] saveCollectDeal:self.deal];
    }else{//取消收藏
        self.deal.collected = NO;
        [[XYDealLocalTool shareDealLocalTool] cancelCollectDeal:self.deal];
    }
    
    
}

- (IBAction)share {
}

- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
