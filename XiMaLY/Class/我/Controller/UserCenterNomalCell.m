//
//  UserCenterNomalCell.m
//  ServiceBusiness
//
//  Created by YH_WY on 16/4/5.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import "UserCenterNomalCell.h"

@interface UserCenterNomalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation UserCenterNomalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindUserCenterData:(NSDictionary *)userInfo {

    if (!userInfo.count) {
        return ;
    }
    
    self.leftLabel.text = userInfo[@"title"];
    
    self.middleLabel.hidden = [userInfo[@"instr"] isEqualToString:@""];
    self.middleLabel.text = userInfo[@"instr"];
    if ([userInfo[@"title"] isEqualToString:@"登录密码"]) {
        [self.middleLabel setTextColor:[UIColor redColor]];
    }
    
    self.rightLabel.hidden = [userInfo[@"detail"] isEqualToString:@""];
    self.rightLabel.text = userInfo[@"detail"];
}


@end
