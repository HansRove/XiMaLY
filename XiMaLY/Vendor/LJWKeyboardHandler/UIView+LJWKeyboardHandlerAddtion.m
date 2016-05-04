//
//  UIView+LJWKeyboardHandlerAddtion.m
//  Pods
//
//  Created by ljw on 15/6/19.
//
//

#import "UIView+LJWKeyboardHandlerAddtion.h"
#import <objc/runtime.h>

@implementation UIView (LJWKeyboardHandlerAddtion)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - FindOutViews
- (NSMutableArray *)findOutViews:(NSArray *)viewClasses
{
    
    NSArray *subviews = self.subviews;
    
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:subviews.count];
    
    for (UIView *view in subviews) {
        
        BOOL isKindOf = NO;
        
        for (Class class in viewClasses) {
            if ([view isKindOfClass:class]) {
                [views addObject:view];
                isKindOf = YES;
            }
        }
        
        if (isKindOf) {
            continue;
        }
        
        [views addObjectsFromArray:[view findOutViews:viewClasses]];
        
    }
    
    return views;
}

- (NSMutableArray *)findOutAllSubViewsCanBecomeFirstResponder
{
    NSArray *subviews = self.subviews;
    
    subviews = [subviews sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        if (view1.frame.origin.y < view2.frame.origin.y) {
            return NSOrderedAscending;
        }
        else if (view1.frame.origin.y == view2.frame.origin.y)
        {
            return NSOrderedSame;
        }
        else
        {
            return NSOrderedDescending;
        }
        
    }];
    
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:subviews.count];
    
    for (UIView *view in subviews) {
        
        if ([view canBecomeFirstResponder] && view.shouldBeFoundOut) {
            
            [views addObject:view];
            
        }
        else
        {
            [views addObjectsFromArray:[view findOutAllSubViewsCanBecomeFirstResponder]];
        }
        
    }
    
    return views;
    
}

#pragma mark - FirstResponderNotification
+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSEL = @selector(becomeFirstResponder);
        SEL newSEL = @selector(ljw_becomeFirstResponder);
        
        Method originMethod = class_getInstanceMethod([self class], originSEL);
        Method newMethod = class_getInstanceMethod(self.class, newSEL);
        
        if (class_addMethod(self.class, originSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            
            class_replaceMethod(self.class, newSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
            
        }
        else
        {
            method_exchangeImplementations(originMethod, newMethod);
        }
        
    });
}

- (BOOL)ljw_becomeFirstResponder
{
    
    //    NSLog(@"%@ becomeFirstResponder", self);
    [[NSNotificationCenter defaultCenter] postNotificationName:kLJWFirstResponderChanged object:nil userInfo:@{@"firstResponder":self}];
    
    return [self ljw_becomeFirstResponder];
}

#pragma mark - PropertyAddition
- (void)setShouldBeFoundOut:(BOOL)shouldBeFoundOut
{
    objc_setAssociatedObject(self, @selector(shouldBeFoundOut), @(shouldBeFoundOut), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldBeFoundOut
{
    
    NSNumber *shouldBeFoundOut = objc_getAssociatedObject(self, @selector(shouldBeFoundOut));
    
    if (!shouldBeFoundOut) {
        self.shouldBeFoundOut = YES;
        return YES;
    }
    
    return [shouldBeFoundOut integerValue];
}

- (void)setAssistantHeight:(CGFloat)assistantHeight
{
    objc_setAssociatedObject(self, @selector(assistantHeight), @(assistantHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)assistantHeight
{
    NSNumber *assistantHeight = objc_getAssociatedObject(self, @selector(assistantHeight));
    
    if (!assistantHeight) {
        self.assistantHeight = 0;
        return 0;
    }
    
    return [assistantHeight doubleValue];
}

@end
