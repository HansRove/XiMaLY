//
//  PublishFooterView.h
//  ServiceBusiness
//
//  Created by YH_WY on 16/3/17.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishFooterViewDelegate <NSObject>

- (void)publishFooterViewDidClickSubmitButton;

@end

@interface PublishFooterView : UIView

@property (nonatomic,readwrite,weak) id<PublishFooterViewDelegate> delegate;

- (void)setupFooterViewButtonBackgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)width corner:(CGFloat)corner title:(NSString *)title titleColor:(UIColor *)titleColor;

@end
