//
//  TrackRankTableViewCell.m
//  XiMaLY
//
//  Created by macbook on 16/4/10.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "TrackRankTableViewCell.h"

@interface TrackRankTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *covertImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *anchorName;

@end

@implementation TrackRankTableViewCell

- (void)awakeFromNib {
    
    [self.numberLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    self.covertImageView.layer.cornerRadius = 35.f;
    [self.covertImageView clipsToBounds];
    
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

- (void)bindTrackRankTableViewCellDataWithDictionary:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath {
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    [self.covertImageView setImageWithURL:[NSURL URLWithString:dict[@"coverSmall"]] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_1"]];
    
    self.titleLabel.text = dict[@"title"];
    
    self.anchorName.text = [NSString stringWithFormat:@"by %@",dict[@"albumTitle"]];
    
    // 最后更新时间 updatedAt
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳
    NSTimeInterval createTime = [dict[@"updatedAt"] floatValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    NSString *updateStr = nil;
    NSInteger minutes = time/60;
    if (minutes<60) {
        updateStr = [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
    } else {
        // 秒转小时
        NSInteger hours = time/60/60;
        
        if (hours<24) {
            updateStr = [NSString stringWithFormat:@"%ld小时前",(long)hours];
        } else {
            //秒转天数
            NSInteger days = time/3600/24;
            if (days < 30) {
                updateStr = [NSString stringWithFormat:@"%ld天前",(long)days];
            } else {
                //秒转月
                NSInteger months = time/3600/24/30;
                //秒转年
                NSInteger years = time/3600/24/30/12;
                if (months < 12) {
                    updateStr = [NSString stringWithFormat:@"%ld月前",(long)months];
                } else {
                    updateStr = [NSString stringWithFormat:@"%ld年前",(long)years];
                }
            }
        }
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:createTime];
    NSLog(@"%@",date);
    self.timeLabel.text = updateStr;
}

- (IBAction)cilckDownloadButtoon:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(trackRankTableViewCellDidCilckDownloadButton)]) {
        [self.delegate trackRankTableViewCellDidCilckDownloadButton];
    }
    
}

@end
