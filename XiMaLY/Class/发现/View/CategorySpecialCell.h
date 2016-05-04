//
//  CategorySpecialCell.h
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/15.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  一个大  四个小, Cell高195
 */

@protocol CategorySpecialCellDelegate <NSObject>

- (void)categorySpecialCellCurrentButton:(NSInteger)index;

@end

@interface CategorySpecialCell : UITableViewCell

@property (nonatomic,readwrite,weak) id<CategorySpecialCellDelegate> delegate;

// 大图
@property (nonatomic,strong) UIButton *icon0;
// 四个小图
@property (nonatomic,strong) UIButton *icon1;
@property (nonatomic,strong) UIButton *icon2;
@property (nonatomic,strong) UIButton *icon3;
@property (nonatomic,strong) UIButton *icon4;

// 告诉外界 cell该有多宽
@property (nonatomic,assign) CGFloat cellHeight;
@end
