//
//  WelcomeImageView.m
//  LiangCeApp
//
//  Created by YunHan on 9/24/15.
//  Copyright (c) 2015 YunHan. All rights reserved.
//

#import "WelcomeImageView.h"

@interface WelcomeImageView ()

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *entryBtn;

@end

@implementation WelcomeImageView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [_imgView removeFromSuperview];
    _imgView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imgView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _imgView.frame = self.bounds;
}

- (void)displayImage:(UIImage *)image
{
    // clear the previous imageView
    [_imgView removeFromSuperview];
    _imgView = nil;
    
    if (image) {
        // make a new UIImageView for the new image
        _imgView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imgView];
    }
    
    [self addEntryBtn];
}

- (void)addEntryBtn
{
    if (_index == 2) {
        
        [self.entryBtn removeFromSuperview];
        self.entryBtn = nil;
        
        self.entryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.entryBtn setBackgroundImage:[ImageWithName(@"welcome_btn_normal") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        self.entryBtn.frame = CGRectMake((self.bounds.size.width-120)/2, self.bounds.size.height-35-48, 120, 35);
        [self.entryBtn setTitle:NSLocalizedString(@"立即开启", @"") forState:UIControlStateNormal];
        [self.entryBtn setTitleColor:RGB(239, 79, 67) forState:UIControlStateNormal];
        [self.entryBtn addTarget:self action:@selector(entryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.entryBtn];   
    }
}

- (void)entryBtnAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(enterToHomeViewController:)]) {
        
        [self.delegate enterToHomeViewController:self];
    }
}

@end
