//
//  XYSortViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSortViewController.h"
#import "XYSort.h"

#pragma mark - 自定义排序按钮
@interface XYSortButton : UIButton
@property (nonatomic, strong) XYSort *sort;
@end

@implementation XYSortButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bgImage = @"btn_filter_normal";
        self.selectedBgImage = @"btn_filter_selected";
        self.titleColor = [UIColor blackColor];
        self.selectedTitleColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted{
    
}
- (void)setSort:(XYSort *)sort{
    _sort = sort;
    self.title = sort.label;
}
@end

#pragma mark - 控制器
@interface XYSortViewController ()

@property (nonatomic, weak) XYSortButton *selectedBtn;

@end

@implementation XYSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.preferredContentSize = self.view.size;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *sorts = [XYMetaDataTool shareMateData].sorts;
    CGFloat margin = 15;
    CGFloat leftX = 20;
    //最大Y值
    CGFloat contentY = 0.0;
    for (NSInteger i = 0; i < sorts.count; i ++) {
        XYSortButton *btn = [[XYSortButton alloc] init];
        [self.view addSubview:btn];
        btn.sort = sorts[i];
        
        btn.x = leftX;
        btn.width = self.view.width - leftX * 2;
        btn.height = 30;
        btn.y = margin + i * (btn.height + margin);
        
        [btn addTarget:self action:@selector(sortBtnClick:)];
        
//        if (i == 0) {
//            [self sortBtnClick:btn];
//        }
        
        contentY = CGRectGetMaxY(btn.frame) + margin;
    }
    
    UIScrollView *sv = (UIScrollView *)self.view;
    sv.contentSize = CGSizeMake(0, contentY);
}

//排序按钮的点击事件
- (void)sortBtnClick:(XYSortButton *)btn{
    //切换选中状态
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    //发出通知
    [XYNotificationCenter postNotificationName:XYSortDidChangeNotification object:self userInfo:@{XYSelectedSort: btn.sort}];
}


- (void)setSelectedSort:(XYSort *)selectedSort{
    _selectedSort = selectedSort;
    
    for (XYSortButton *btn in self.view.subviews) {
        if ([btn isKindOfClass:[XYSortButton class]]) {
            if (btn.sort == selectedSort) {
                self.selectedBtn.selected = NO;
                btn.selected = YES;
                self.selectedBtn = btn;
            }
        }
    }
}

@end
