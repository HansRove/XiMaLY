//
//  UIViewController+LJWKeyboardHandlerHelper.h
//  LJWKeyboardHandlerExample
//
//  Created by ljw on 15/5/27.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJWKeyboardHandler.h"

@interface UIViewController (LJWKeyboardHandlerHelper)

@property (nonatomic, strong) LJWKeyboardHandler *ljwKeyboardHandler;

/**
 *  注册LJWKeyboardHandler
 *
 *  @return handler实例
 */
- (LJWKeyboardHandler *)registerLJWKeyboardHandler;

@end
