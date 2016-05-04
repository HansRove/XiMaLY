//
//  PublishFooterView.m
//  ServiceBusiness
//
//  Created by YH_WY on 16/3/17.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import "PublishFooterView.h"

@interface PublishFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *currentButton;

@end

@implementation PublishFooterView

- (void)setupFooterViewButtonBackgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)width corner:(CGFloat)corner title:(NSString *)title titleColor:(UIColor *)titleColor {
    
    self.currentButton.layer.cornerRadius = corner;
    self.currentButton.clipsToBounds = YES;
    self.currentButton.layer.borderColor = borderColor.CGColor;
    self.currentButton.layer.borderWidth = width;
    [self.currentButton setBackgroundColor:bgColor];
    [self.currentButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    [self.currentButton setTitle:title forState:(UIControlStateNormal)];
    
}
- (IBAction)clickSubmitButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(publishFooterViewDidClickSubmitButton)]) {
        [self.delegate publishFooterViewDidClickSubmitButton];
    }
}

@end
