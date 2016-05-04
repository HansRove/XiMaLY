//
//  LJWKeyboardToolBar.h
//  LJWKeyboardHandlerExample
//
//  Created by ljw on 15/6/15.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LJWKeyboardToolBar;
@protocol LJWKeyboardToolBarDelegate <NSObject>

@optional;
- (void)ljwKeyboardToolBar:(LJWKeyboardToolBar *)toolBar didClickLastItem:(UIBarButtonItem *)item;

- (void)ljwKeyboardToolBar:(LJWKeyboardToolBar *)toolBar didClickNextItem:(UIBarButtonItem *)item;

- (void)ljwKeyboardToolBar:(LJWKeyboardToolBar *)toolBar didClickDoneItem:(UIBarButtonItem *)item;

@end

@interface LJWKeyboardToolBar : UIToolbar

@property (nonatomic, weak) id<LJWKeyboardToolBarDelegate> ljwKeyboardDelegate;

@property (nonatomic, strong) NSMutableArray *responders;

@property (nonatomic, strong) UIResponder *currentResponder;

@property (nonatomic, assign) NSInteger currentResponderIndex;

@end
