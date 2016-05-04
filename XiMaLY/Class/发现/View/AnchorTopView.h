//
//  AnchorTopView.h
//  喜马拉雅FM(高仿品)
//
//  Created by YH_WY on 16/3/23.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnchorTopViewDelegate <NSObject>

- (void)anchorTopViewContentButton:(UIButton *)sender;

@end

@interface AnchorTopView : UIView

@property (nonatomic,readwrite,weak) id<AnchorTopViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;  // 返回按钮
@property (weak, nonatomic) IBOutlet UIButton *shareButton;   // 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *messageButton;  // 邮件按钮
@property (weak, nonatomic) IBOutlet UIButton *focusButton;  // 关注按钮

@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;   //粉丝数
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLabel;  // 赞过人数
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;  // 关注人数


@property (weak, nonatomic) IBOutlet UILabel *anchorName;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UIButton *vipIconButton;
@property (weak, nonatomic) IBOutlet UIButton *iconImageButton;


@end
