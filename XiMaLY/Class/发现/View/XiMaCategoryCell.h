//
//  XiMaCategoryCell.h
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 懒加载插件名称 DZLazyInstantiate */
@interface XiMaCategoryCell : UITableViewCell
/** 序号标签 */
@property(nonatomic,strong) UILabel *orderLb;
/** 类型图片 */
@property(nonatomic,strong) UIImageView *iconIV;
/** 类型名称 */
@property(nonatomic,strong) UILabel *titleLb;
/** 类型描述 */
@property(nonatomic,strong) UILabel *descLb;
/** 集数 */
@property(nonatomic,strong) UILabel *numberLb;
/** 集数图标 */
@property(nonatomic,strong) UIImageView *numberIV;
@end






