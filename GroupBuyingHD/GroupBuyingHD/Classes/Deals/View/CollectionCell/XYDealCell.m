//
//  XYDealCell.m
//  团购HD
//
//  Created by 李小亚 on 16/8/6.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDealCell.h"
#import "XYDeal.h"
#import "UIImageView+WebCache.h"

@interface XYDealCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UILabel *dealTitle;
@property (weak, nonatomic) IBOutlet UILabel *dealDesc;
@property (weak, nonatomic) IBOutlet UILabel *dealCurrentPrice;
@property (weak, nonatomic) IBOutlet UILabel *dealOriginalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *dealNewImage;
@property (weak, nonatomic) IBOutlet UILabel *dealSalesCount;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
- (IBAction)coverClick;

@end

@implementation XYDealCell

//为cell赋值
- (void)setDeal:(XYDeal *)deal{
    _deal = deal;
    
    [_dealImage sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    _dealTitle.text = deal.title;
    _dealDesc.text = deal.desc;
    
    //设置现价文本
    _dealCurrentPrice.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    
    //原价中划线
    _dealOriginalPrice.text = [NSString stringWithFormat:@"￥%@", deal.list_price];
    //销量
    _dealSalesCount.text = [NSString stringWithFormat:@"已售%ld",deal.purchase_count];
    //新单
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    dateForm.dateFormat = @"yyyy-MM-dd";
    NSString *currentDate = [dateForm stringFromDate:[NSDate date]];
    //新单
    _dealNewImage.hidden = ([currentDate compare:deal.publish_date] == NSOrderedDescending);
    
    //遮盖曾
    _coverBtn.hidden = !deal.isEditing;
    //选中标记
    _selectedImage.hidden = !deal.isSelected;
    
}

- (void)drawRect:(CGRect)rect{
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}
- (IBAction)coverClick {
    self.selectedImage.hidden = !self.selectedImage.isHidden;
    self.deal.selected = !self.selectedImage.isHidden;
    
    if ([self.delegate respondsToSelector:@selector(dealCellDidSelected:)]) {
        [self.delegate dealCellDidSelected:self];
    }
}
@end
