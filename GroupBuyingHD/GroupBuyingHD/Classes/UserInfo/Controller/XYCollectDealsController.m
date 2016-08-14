//
//  XYCollectDealsController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCollectDealsController.h"
#import "XYDealLocalTool.h"
#import "XYEmptyView.h"
#import "XYDeal.h"

@interface XYCollectDealsController ()

@end

@implementation XYCollectDealsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    self.emptyView.image = [UIImage imageNamed:@"icon_collects_empty"];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.deals removeAllObjects];
    NSArray *data = [XYDealLocalTool shareDealLocalTool].collectDeals;
    for (XYDeal *deal in data) {
        deal.editing = NO;
    }
    [self.deals addObjectsFromArray:data];
    [self.collectionView reloadData];
}


- (void)deleteItemClick{
    [[XYDealLocalTool shareDealLocalTool] cancelCollectDeals:self.willCancelDeals];
    [super deleteItemClick];
}

@end
