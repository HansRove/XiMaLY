//
//  XiMaAlbumViewModel.m
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "XiMaAlbumViewModel.h"

@implementation XiMaAlbumViewModel
- (NSInteger)rowNumber{
    return self.dataArr.count;
}
- (BOOL)isHasMore{
    return _maxPageId > _pageId;
}
- (void)refreshDataCompletionHandle:(void(^)(NSError *error))completionHandle{
    _pageId = 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}
- (void)getMoreDataCompletionHandle:(void(^)(NSError *error))completionHandle{
    if (self.isHasMore) {
        _pageId += 1;
        [self getDataFromNetCompleteHandle:completionHandle];
    }else{
        NSError *error =[NSError errorWithDomain:@"" code:999 userInfo:@{NSLocalizedDescriptionKey: @"没有更多数据"}];
        completionHandle(error);
    }
}
- (void)getDataFromNetCompleteHandle:(void(^)(NSError *error))completionHandle{
    self.dataTask=[XiMaNetManager getAlbumWithId:_albumId page:_pageId completionHandle:^(AlbumModel *model, NSError *error) {
        if (_pageId == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:model.tracks.list];
        _maxPageId = model.tracks.maxPageId;
        completionHandle(error);
    }];
}
- (instancetype)initWithAlbumId:(NSInteger)albumId{
    if (self=[super init]) {
        self.albumId = albumId;
    }
    return self;
}
- (AlbumTracksListModel *)modelForRow:(NSInteger)row{
    return self.dataArr[row];
}
/** 获取某行的封面图片URL */
- (NSURL *)coverURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].coverSmall];
}
/** 获取某行题目 */
- (NSString *)titleForRow:(NSInteger)row{
    return [self modelForRow:row].title;
}
/** 获取某行更新时间 */
- (NSString *)timeForRow:(NSInteger)row{
//    1447088462000 创建时间,距离1970年的秒数
//获取当前秒数
    NSTimeInterval currentTime= [[NSDate date] timeIntervalSince1970];
//算出当前时间和创建时间的间隔秒数
    NSTimeInterval delta = currentTime-[self modelForRow:row].createdAt/1000;
//秒数转小时
    NSInteger hours = delta/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
//秒数转天数
    NSInteger days = delta/3600/24;
    return [NSString stringWithFormat:@"%ld天前", (long)days];
}
/** 获取某行出处 */
- (NSString *)sourceForRow:(NSInteger)row{
    return [NSString stringWithFormat:@"by %@", [self modelForRow:row].nickname];
}
/** 获取某行播放数 */
- (NSString *)playCountForRow:(NSInteger)row{
//如果超过万，要显示*.*万
    NSInteger count = [self modelForRow:row].playtimes;
    if (count < 10000) {
        return @([self modelForRow:row].playtimes).stringValue;
    }else{
        return [NSString stringWithFormat:@"%.1f万", count/10000.0];
    }
}
/** 获取某行喜欢数 */
- (NSString *)favorCountForRow:(NSInteger)row{
    return @([self modelForRow:row].likes).stringValue;
}
/** 获取某行评论数 */
- (NSString *)commentCountForRow:(NSInteger)row{
    return @([self modelForRow:row].comments).stringValue;
}
/** 获取某行播放时长 */
- (NSString *)durationForRow:(NSInteger)row{
    NSInteger duration=[self modelForRow:row].duration;
    NSInteger minute= duration/60;
    NSInteger second = duration%60;
//%02ld 表示小于两位 用0补位，例如1 显示 01
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
}
/** 获取某行下载链接地址 */
- (NSURL *)downLoadURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].downloadUrl];
}
/** 获取某行音频播放地址 */
- (NSURL *)musicURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].playUrl64];
}
@end


















