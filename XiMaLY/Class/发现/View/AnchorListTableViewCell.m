//
//  AnchorListTableViewCell.m
//  喜马拉雅FM(高仿品)
//
//  Created by YH_WY on 16/3/15.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "AnchorListTableViewCell.h"

@interface AnchorListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *testSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *anchorName;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
@end

@implementation AnchorListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindAnchorListTableViewCellContentData:(NSDictionary *)paraDict {
//    @property (weak, nonatomic) IBOutlet UIButton *testSongBtn;
//    @property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
//    @property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//    @property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
//    @property (weak, nonatomic) IBOutlet UILabel *anchorName;
//    @property (weak, nonatomic) IBOutlet UILabel *infoLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *trackNumLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
    
    NSURL *url = [NSURL URLWithString:paraDict[@"middleLogo"]];
    [self.iconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_focusImage_loading"]];
    
    self.anchorName.text = paraDict[@"nickname"];
    
    self.infoLabel.text = paraDict[@"personDescribe"];
    
    self.vipImageView.hidden = ![paraDict[@"isVerified"] boolValue];
    
    self.trackNumLabel.text = [paraDict[@"tracksCounts"] stringValue];
    
    NSInteger count = [paraDict[@"followersCounts"] integerValue];
    NSString *followersCounts = nil;
    if (count>10000) {
        followersCounts = [NSString stringWithFormat:@"%.1lf万",count/10000.0];
    } else {
        followersCounts  = [NSString stringWithFormat:@"%ld",(long)count];
    }
    
    self.playNumLabel.text = followersCounts;
}

@end
