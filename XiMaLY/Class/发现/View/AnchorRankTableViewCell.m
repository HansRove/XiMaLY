//
//  AnchorRankTableViewCell.m
//  XiMaLY
//
//  Created by macbook on 16/4/11.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "AnchorRankTableViewCell.h"

@interface AnchorRankTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *anchorName;

@property (weak, nonatomic) IBOutlet UILabel *anchorDetail;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipIconImageView;

@end

@implementation AnchorRankTableViewCell

- (void)awakeFromNib {
    
    [self.numberLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    self.coverImageView.layer.cornerRadius = 35.f;
    [self.coverImageView clipsToBounds];
    
    // 添加kvo观察 123排名
    [_numberLabel bk_addObserverForKeyPath:@"text" options:(NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
        NSString *value = change[@"new"];
        if ([value isEqualToString:@"1"]) {
            _numberLabel.textColor=[UIColor redColor];
        }else if ([value isEqualToString:@"2"]){
            _numberLabel.textColor=[UIColor blueColor];
        }else if([value isEqualToString:@"3"]){
            _numberLabel.textColor=[UIColor greenColor];
        }else{
            _numberLabel.textColor=[UIColor blackColor];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindAnchorRankTableViewCellDataWithDictionary:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath {

    self.vipIconImageView.hidden = ![dict[@"isVerified"] boolValue];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    [self.coverImageView setImageWithURL:[NSURL URLWithString:dict[@"middleLogo"]] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_1"]];
    
    self.anchorName.text = dict[@"nickname"];
    self.anchorDetail.text = dict[@"personDescribe"];
    
    NSInteger count = [dict[@"followersCounts"] integerValue];
    NSString *followersCounts = nil;
    if (count>10000) {
        followersCounts = [NSString stringWithFormat:@"%.1lf万",count/10000.0];
    } else {
        followersCounts  = [NSString stringWithFormat:@"%ld",(long)count];
    }
    
    self.fansNumberLabel.text = followersCounts;
}

@end
