//
//  UserCenterInfoView.h
//  ServiceBusiness
//
//  Created by YH_WY on 16/4/5.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserCenterInfoViewDelegate <NSObject>

- (void)userCenterInfoViewButtonDidClick:(NSUInteger)butonTag;

@end

@interface UserCenterInfoView : UIView

@property (nonatomic,readwrite,weak) id<UserCenterInfoViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *userHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
