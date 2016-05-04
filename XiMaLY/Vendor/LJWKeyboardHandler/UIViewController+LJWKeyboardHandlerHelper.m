//
//  UIViewController+LJWKeyboardHandlerHelper.m
//  LJWKeyboardHandlerExample
//
//  Created by ljw on 15/5/27.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import <objc/runtime.h>

@implementation UIViewController (LJWKeyboardHandlerHelper)

@dynamic ljwKeyboardHandler;

- (void)setLjwKeyboardHandler:(LJWKeyboardHandler *)ljwKeyboardHandler
{
    objc_setAssociatedObject(self, @selector(ljwKeyboardHandler), ljwKeyboardHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LJWKeyboardHandler *)ljwKeyboardHandler
{
    return objc_getAssociatedObject(self, @selector(ljwKeyboardHandler));
}

#pragma mark - MethodSwizzling
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzlingWithObject:self originSEL:@selector(viewDidAppear:) newSEL:@selector(ljw_viewDidAppear:)];
        [self swizzlingWithObject:self originSEL:@selector(viewWillDisappear:) newSEL:@selector(ljw_viewWillDisappear:)];
        
    });
}

+ (void)swizzlingWithObject:(id)object originSEL:(SEL)originSEL newSEL:(SEL)newSEL
{
    Method originMethod = class_getInstanceMethod(object, originSEL);
    Method newMethod = class_getInstanceMethod(object, newSEL);
    
    if (class_addMethod(self.class, originSEL, class_getMethodImplementation(self.class, newSEL), method_getTypeEncoding(newMethod))) {
        
        class_replaceMethod(self.class, newSEL, class_getMethodImplementation(self.class, originSEL), method_getTypeEncoding(originMethod));
        
    }
    else
    {
        method_exchangeImplementations(originMethod, newMethod);
    }
    
    
}

- (void)ljw_viewDidAppear:(BOOL)animated
{
    [self ljw_viewDidAppear:animated];
    
    [self.ljwKeyboardHandler startHandling];
}

- (void)ljw_viewWillDisappear:(BOOL)animated
{
    [self ljw_viewWillDisappear:animated];
    
    [self.ljwKeyboardHandler stopHandling];
}

/**
 *  注册LJWKeyboardHandler
 *
 *  @return handler实例
 */
- (LJWKeyboardHandler *)registerLJWKeyboardHandler
{
    self.ljwKeyboardHandler = [[LJWKeyboardHandler alloc] init];
    
    return self.ljwKeyboardHandler;
}

@end
