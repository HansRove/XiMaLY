//
//  PromptView.m
//  YunHanCoreDemo
//
//  Created by panda.pan on 16/2/15.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import "PromptView.h"
//#import "MJRefresh.h"
//#import "MBProgressHUD.h"

//#define appTintColor [UIColor blueColor]

@interface PromptView ()

@property (weak, nonatomic) IBOutlet UIImageView *promptImgView;
@property (weak, nonatomic) IBOutlet UILabel *promptTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *promptBtn;

@property (weak, nonatomic) UIView *parentView;
@property(strong) void (^actionBlock)();
@end

@implementation PromptView

+ (PromptView *)promptViewShowInSuperView:(UIView *)view promptType:(PromptType)type dataSource:(id)dataSource actionBlock:(void (^)())block
{
    BOOL hasDataFlag = NO;
    
    if ([dataSource isKindOfClass:[NSArray class]]) {
        hasDataFlag =  [dataSource count] > 0;
    } else if ([dataSource isKindOfClass:[NSDictionary class]]) {
        hasDataFlag =  [dataSource allKeys].count > 0;
    }

    if (hasDataFlag) {
        // 如果已经有数据了,MB(toast)展示提示
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (type == PromptTypeNoNetwork) {
            hud.detailsLabelText = NSLocalizedString(@"无网络连接,请检查网络", nil);
        } else if (type == PromptTypeNoneData) {
            // 没有数据不可能...
        } else if (type == PromptTypeErrorData)  {
            hud.detailsLabelText =  NSLocalizedString(@"数据加载失败,请下拉刷新", nil);
        } else if (type == PromptTypeOther) {
            // 貌似这也没可能
        }
        [hud hide:YES afterDelay:1];
        return nil;
    } else {
        
        if ([PromptView selfForView:view]) {
            PromptView *promptView = [PromptView selfForView:view];
            [promptView show];
            return promptView;
        }
        PromptView *promptView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
        promptView.parentView = view;
        
        if (type == PromptTypeNoNetwork) {
            [promptView.promptImgView setImage:[UIImage imageNamed:@"prompt_view_no_network"]];
            promptView.promptTitleLabel.text = NSLocalizedString(@"网络请求失败", nil);
            promptView.promptDetailLabel.text = NSLocalizedString(@"排除问题后请点击按钮刷新页面", nil);
        } else if (type == PromptTypeNoneData) {
            [promptView.promptImgView setImage:[UIImage imageNamed:@"prompt_view_no_data"]];
            promptView.promptTitleLabel.text = NSLocalizedString(@"暂无数据", nil);
            promptView.promptBtn.hidden = YES;
        } else if (type == PromptTypeErrorData) {
            [promptView.promptImgView setImage:[UIImage imageNamed:@"prompt_view_error_data"]];
            promptView.promptTitleLabel.text = NSLocalizedString(@"数据加载失败", nil);
            promptView.promptDetailLabel.text = NSLocalizedString(@"刷新无效请重启应用", nil);
        } else if (type == PromptTypeOther) {
            [promptView.promptImgView setImage:[UIImage imageNamed:@"prompt_view_no_data"]];
        }
        
        [promptView setPromptButtonInPromptView:promptView.promptBtn];
        promptView.actionBlock = block;
        [promptView show];
        
        return promptView;
    }
}

+ (PromptView *)promptViewShowInSuperView:(UIView *)view icon:(UIImage *)img title:(NSString *)title detail:(NSString *)detail buttonTitle:(NSString *)btnTitle dataSource:(id)dataSource actionBlock:(void (^)())block {
    
    BOOL hasDataFlag = NO;
    
    if ([dataSource isKindOfClass:[NSArray class]]) {
        hasDataFlag =  [dataSource count] > 0;
    } else if ([dataSource isKindOfClass:[NSDictionary class]]) {
        hasDataFlag =  [dataSource allKeys].count > 0;
    }
    
    if (hasDataFlag) {
        // 如果已经有数据了,MB(toast)展示提示
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText =  NSLocalizedString(title, nil);
        
        [hud hide:YES afterDelay:1];
        return nil;
    } else {
        
        if ([PromptView selfForView:view]) {
            PromptView *promptView = [PromptView selfForView:view];
            [promptView show];
            return promptView;
        }
        
        PromptView *promptView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
        promptView.parentView = view;
        promptView.promptImgView.image = img;
        promptView.promptTitleLabel.text = title;
        promptView.promptDetailLabel.text = detail;
        if (btnTitle) {
            [promptView.promptBtn setTitle:btnTitle forState:UIControlStateNormal];
            [promptView setPromptButtonInPromptView:promptView.promptBtn];
        } else {
            promptView.promptBtn.hidden = YES;
        }
        promptView.actionBlock = block;
        [promptView show];
        
        return promptView;
    }
}

- (void)setPromptButtonInPromptView:(UIButton *)promptBtn {
    [promptBtn setTitleColor:[UIColor colorWithRed:46/255.0f green:165/255.0f blue:231/255.0f alpha:1] forState:UIControlStateNormal];
    promptBtn.layer.borderColor = UIColorFromRGB(0x999999, 1.0).CGColor;
    promptBtn.layer.borderWidth = .5f;
    promptBtn.layer.cornerRadius = .3f;
    promptBtn.clipsToBounds = YES;
}

- (IBAction)promptBtnAction:(UIButton *)sender {
    [self removeFromSuperview];
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)show{
    if (self.parentView) {
        self.frame = self.parentView.bounds;
        [self.parentView addSubview:self];
    }
    else{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.bounds;
        [window addSubview:self];
    }
}

+ (PromptView*)selfForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (PromptView*)subview;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
