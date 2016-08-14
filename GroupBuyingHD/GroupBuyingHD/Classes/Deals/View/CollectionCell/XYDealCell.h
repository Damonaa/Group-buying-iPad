//
//  XYDealCell.h
//  团购HD
//
//  Created by 李小亚 on 16/8/6.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDeal, XYDealCell;


@protocol  XYDealCellDelegate <NSObject>

@optional
- (void)dealCellDidSelected:(XYDealCell *)dealCell;

@end

@interface XYDealCell : UICollectionViewCell

@property (nonatomic, strong) XYDeal *deal;

@property (nonatomic, weak) id<XYDealCellDelegate> delegate;

@end

