//
//  WelcomeImageView.h
//  LiangCeApp
//
//  Created by YunHan on 9/24/15.
//  Copyright (c) 2015 YunHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelcomeImageViewDelegate <NSObject>

@optional
- (void)enterToHomeViewController:(id)sender;

@end

@interface WelcomeImageView : UIView

@property (nonatomic) id<WelcomeImageViewDelegate> delegate;
@property (assign) NSInteger index;

- (void)displayImage:(UIImage *)image;

@end
