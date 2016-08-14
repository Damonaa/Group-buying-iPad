//
//  XYHistoryDealsController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYHistoryDealsController.h"
#import "XYEmptyView.h"
#import "XYDealLocalTool.h"
#import "XYDeal.h"

@interface XYHistoryDealsController ()

@end

@implementation XYHistoryDealsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //没有数据的时候，展示的提示图
    self.emptyView.image = [UIImage imageNamed:@"icon_latestBrowse_empty"];
    self.title = @"浏览记录";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.deals removeAllObjects];
    NSArray *data = [XYDealLocalTool shareDealLocalTool].historyDeals;
    for (XYDeal *deal in data) {
        deal.editing = NO;
    }
    [self.deals addObjectsFromArray:data];
    [self.collectionView reloadData];
}

- (void)deleteItemClick{
    [[XYDealLocalTool shareDealLocalTool] cancelHistoryDeals:self.willCancelDeals];
    
    [super deleteItemClick];
}

@end
