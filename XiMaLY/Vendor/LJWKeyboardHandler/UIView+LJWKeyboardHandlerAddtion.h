//
//  UIView+LJWKeyboardHandlerAddtion.h
//  Pods
//
//  Created by ljw on 15/6/19.
//
//

#import <UIKit/UIKit.h>

static NSString *const kLJWFirstResponderChanged = @"kLJWFirstResponderChanged";

@interface UIView (LJWKeyboardHandlerAddtion)

#pragma mark - FindOutViews
- (NSMutableArray *)findOutViews:(NSArray *)viewClasses;

- (NSMutableArray *)findOutAllSubViewsCanBecomeFirstResponder;

#pragma mark - PropertyAddition
/**
 *  是否作为响应者,被找出来。
 */
@property (nonatomic, assign) BOOL shouldBeFoundOut;

/**
 *  辅助高度偏移量
 */
@property (nonatomic, assign) CGFloat assistantHeight;

@end
