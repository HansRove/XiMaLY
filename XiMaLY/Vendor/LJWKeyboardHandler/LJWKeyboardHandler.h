//
//  LJWKeyboardHandler.h
//  Parking
//
//  Created by ljw on 15/5/17.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

/*
 *  由于有问题还没解决,目前只支持自动调整vc.view。
 *
 *  强烈不建议直接使用此类,如果掉坑里了就自己爬出来吧~~~
 *
 *  如需直接使用,请在vc里保留,并在viewDidAppear里使用法调用startHandling,在viewWillDisappear里调用stopHandling;
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJWKeyboardHandler : NSObject

/**
 *  辅助的高度
 */
@property (nonatomic, assign) CGFloat assistantHeight;

/**
 *  是否显示keyboardToolBar(默认显示)
 */
@property (nonatomic, assign) BOOL shouldShowKeyboardToolBar;

/**
 *  开始处理
 */
- (void)startHandling;

/**
 *  结束处理
 */
- (void)stopHandling;

@end
