//
//  PromptView.h
//  YunHanCoreDemo
//
//  Created by panda.pan on 16/2/15.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PromptType) {
    PromptTypeNoNetwork,  // 网络请求失败
    PromptTypeNoneData,   // no data from service
    PromptTypeErrorData,  // error from service
    PromptTypeOther,
};

@interface PromptView : UIView
/**
 *  增强用户体验,提示界面(注意: 如果tableView有上下拉刷新的时候, 记得在数据请求成功后remove此self)
 *
 *  @param view       内容视图,将self绑定到此View上
 *  @param type       数据类型, (网络请求失败, 没有数据, 数据请求失败)
 *  @param dataSource 网络请求回来后的数据源(数组或者字典)
 *  @param block      回调的方法,通常会再次请求XXX网络(不知道,所以block)
 *
 *  @return 返回self类方法
 */
+ (PromptView *)promptViewShowInSuperView:(UIView *)view promptType:(PromptType)type dataSource:(id)dataSource actionBlock:(void (^)())block;

/**
 *  增强用户体验,提示界面(注意: 如果tableView有上下拉刷新的时候, 记得在数据请求成功后remove此self)
 *
 *  @param view     内容视图,将self绑定到此View上
 *  @param img      展示图片Icon
 *  @param title    展示标题
 *  @param detail   展示详情说明
 *  @param btnTitle 展示按钮文字(设置nil的时候,按钮隐藏)
 *  @param dataSource 网络请求回来后的数据源(数组或者字典)
 *  @param block    回调的方法,通常会再次请求XXX网络(不知道,所以block)
 *
 *  @return 返回self类方法
 */
+ (PromptView *)promptViewShowInSuperView:(UIView *)view icon:(UIImage *)img title:(NSString *)title detail:(NSString *)detail buttonTitle:(NSString *)btnTitle dataSource:(id)dataSource actionBlock:(void (^)())block;

@end
