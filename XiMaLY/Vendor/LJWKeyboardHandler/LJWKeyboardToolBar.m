//
//  LJWKeyboardToolBar.m
//  LJWKeyboardHandlerExample
//
//  Created by ljw on 15/6/15.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "LJWKeyboardToolBar.h"
#import "LJWKeyboardHandlerHeaders.h"

@interface LJWKeyboardToolBar ()

@property (nonatomic, strong) UIBarButtonItem *lastItem;

@property (nonatomic, strong) UIBarButtonItem *nextItem;

@end

@implementation LJWKeyboardToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *resourcesBundlePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:resourcesBundlePath];
        
        UIImage *lastImage = [UIImage imageWithContentsOfFile:[resourcesBundle pathForResource:@"LJWButtonBarArrowLeft@2x" ofType:@"png"]];
        
        UIImage *nextImage = [UIImage imageWithContentsOfFile:[resourcesBundle pathForResource:@"LJWButtonBarArrowRight@2x" ofType:@"png"]];
        
        self.lastItem = [[UIBarButtonItem alloc] initWithImage:lastImage style:UIBarButtonItemStylePlain target:self action:@selector(didClickLastItem:)];
        
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem.width = 20.f;
        
        self.nextItem = [[UIBarButtonItem alloc] initWithImage:nextImage style:UIBarButtonItemStylePlain target:self action:@selector(didClickNextItem:)];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSString *doneTitle = NSLocalizedStringFromTableInBundle(@"Done", @"LJWKeyBoardLocalization", resourcesBundle, nil);
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:doneTitle style:UIBarButtonItemStyleDone target:self action:@selector(didClickDoneItem:)];
        
        [self setItems:@[self.lastItem, fixedItem, self.nextItem, flexibleItem, doneItem]];
        
    }
    return self;
}

#pragma mark - ItemClickMethod
- (void)didClickLastItem:(UIBarButtonItem *)item
{
    
    [self lastOne];
    
    if ([self.ljwKeyboardDelegate respondsToSelector:@selector(ljwKeyboardToolBar:didClickLastItem:)]) {
        
        [self.ljwKeyboardDelegate ljwKeyboardToolBar:self didClickLastItem:item];
        
    }
    
}

- (void)didClickNextItem:(UIBarButtonItem *)item
{
    
    [self nextOne];
    
    if ([self.ljwKeyboardDelegate respondsToSelector:@selector(ljwKeyboardToolBar:didClickNextItem:)]) {
        
        [self.ljwKeyboardDelegate ljwKeyboardToolBar:self didClickNextItem:item];

    }
    
}

- (void)didClickDoneItem:(UIBarButtonItem *)item
{
    
    [self.currentResponder resignFirstResponder];
    
    if ([self.ljwKeyboardDelegate respondsToSelector:@selector(ljwKeyboardToolBar:didClickDoneItem:)]) {
        
        [self.ljwKeyboardDelegate ljwKeyboardToolBar:self didClickDoneItem:item];

    }
    
}

#pragma mark - setterMethod
- (void)setCurrentResponderIndex:(NSInteger)currentResponderIndex
{
    _currentResponderIndex = currentResponderIndex;
    
    if (currentResponderIndex == 0) {
        self.lastItem.enabled = NO;
    }
    else
    {
        self.lastItem.enabled = YES;
    }
    if (currentResponderIndex == self.responders.count - 1) {
        self.nextItem.enabled = NO;
    }
    else
    {
        self.nextItem.enabled = YES;
    }
}

- (void)setCurrentResponder:(UIResponder *)currentResponder
{
    
    if ([currentResponder isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
        
        _currentResponder = [[(UIView *)currentResponder superview] superview];
    }
    else
    {
        _currentResponder = currentResponder;
    }
    
    self.currentResponderIndex = [self.responders indexOfObject:_currentResponder];
    
    [_currentResponder becomeFirstResponder];
}

#pragma mark - ControlMethod
- (void)nextOne
{
    self.currentResponderIndex ++;
    
    self.currentResponder = [self.responders objectAtIndex:self.currentResponderIndex];
    
}

- (void)lastOne
{
    self.currentResponderIndex --;
    
    self.currentResponder = [self.responders objectAtIndex:self.currentResponderIndex];
}

- (NSMutableArray *)responders
{
    return [[UIApplication sharedApplication].keyWindow.presentViewController.view findOutAllSubViewsCanBecomeFirstResponder];
}

@end
