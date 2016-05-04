//
//  WelcomeView.m
//  LiangCeApp
//
//  Created by YunHan on 12/8/15.
//  Copyright (c) 2015 YunHan. All rights reserved.
//

#import "WelcomeContentView.h"

@interface WelcomeContentView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *entryBtn;

@end

@implementation WelcomeContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)welcomeViewFromXIB
{
    NSString *name = NSStringFromClass(self);
    
    return [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    
//    self.titleLabel.textColor = UIColorFromRGB(0x55C8A9, 1.0);
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:26];
//    self.detailLabel.textColor = UIColorFromRGB(0x999999, 1.0);
//    self.detailLabel.font = [UIFont boldSystemFontOfSize:18];
//    
//    [self.entryBtn setBackgroundImage:[ImageWithName(@"welcome_btn_normal") resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
//    [self.entryBtn setBackgroundImage:[ImageWithName(@"welcome_btn_highlight") resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
//    [self.entryBtn setTitle:@"立即体验" forState:UIControlStateNormal];
//    [self.entryBtn setTitleColor:UIColorFromRGB(0xFB7A64, 1.0) forState:UIControlStateNormal];
//    [self.entryBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateHighlighted];
    self.entryBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
}

- (void)displayContent:(NSDictionary *)data
{
//    self.iconView.image = ImageWithName(data[@"image"]);
    self.titleLabel.text = data[@"title"];
    self.detailLabel.text = data[@"detail"];
    
    if (2 == self.index)
        self.entryBtn.hidden = NO;
    else
        self.entryBtn.hidden = YES;
}

- (IBAction)entryBtnAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(welcomePageDidEntry:)]) {
        
        [self.delegate welcomePageDidEntry:self];
    }
}

@end
