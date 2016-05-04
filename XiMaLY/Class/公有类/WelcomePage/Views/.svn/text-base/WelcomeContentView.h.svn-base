//
//  WelcomeView.h
//  LiangCeApp
//
//  Created by YunHan on 12/8/15.
//  Copyright (c) 2015 YunHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelcomeContentViewDelegate;

@interface WelcomeContentView : UIView

@property (nonatomic) id<WelcomeContentViewDelegate> delegate;

@property (nonatomic) int index;

+ (instancetype)welcomeViewFromXIB;

- (void)displayContent:(NSDictionary *)data;

@end

@protocol WelcomeContentViewDelegate <NSObject>

@optional
- (void)welcomePageDidEntry:(WelcomeContentView *)sender;

@end
