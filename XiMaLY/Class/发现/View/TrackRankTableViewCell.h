//
//  TrackRankTableViewCell.h
//  XiMaLY
//
//  Created by macbook on 16/4/10.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrackRankTableViewCellDelegate <NSObject>

- (void)trackRankTableViewCellDidCilckDownloadButton;

@end

@interface TrackRankTableViewCell : UITableViewCell

@property (nonatomic,weak) id<TrackRankTableViewCellDelegate> delegate;

- (void)bindTrackRankTableViewCellDataWithDictionary:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath;

@end
