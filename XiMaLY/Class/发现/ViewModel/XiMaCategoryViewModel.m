//
//  XiMaCategoryViewModel.m
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "XiMaCategoryViewModel.h"

@implementation XiMaCategoryViewModel
- (void)refreshDataCompletionHandle:(void(^)(NSError *error))completionHandle{
    _pageId = 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}
- (void)getMoreDataCompletionHandle:(void(^)(NSError *error))completionHandle{
//如果当前页数已经是最大页数，那么没有必要再发送获取更多请求了，这样会浪费用户流量
    if (self.isHasMore) {
        _pageId += 1;
        [self getDataFromNetCompleteHandle:completionHandle];
    }else{
        NSError *err=[NSError errorWithDomain:@"" code:999 userInfo:@{NSLocalizedDescriptionKey:@"没有更多数据了"}];
        completionHandle(err);
    }
}
- (void)getDataFromNetCompleteHandle:(void(^)(NSError *error))completionHandle{
    self.dataTask=[XiMaNetManager getRankListWithPageId:_pageId completionHandle:^(RankingListModel* model, NSError *error) {
        if (!error) {
            if (_pageId == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:model.list];
            _maxPageId = model.maxPageId;
        }
        completionHandle(error);
    }];
}
- (RankListListModel *)modelForRow:(NSInteger)row{
    return self.dataArr[row];
}
- (NSInteger)rowNumber{
    return self.dataArr.count;
}
- (NSInteger)albumIdForRow:(NSInteger)row{
    return [self modelForRow:row].albumId;
}
- (NSURL *)iconURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].albumCoverUrl290];
}
- (NSString *)titleForRow:(NSInteger)row{
    return [self modelForRow:row].title;
}
- (NSString *)descForRow:(NSInteger)row{
    return [self modelForRow:row].intro;
}
- (NSString *)numberForRow:(NSInteger)row{
    return [NSString stringWithFormat:@"%ld集", (long)[self modelForRow:row].tracks];
}

- (BOOL)isHasMore{
    return _maxPageId > _pageId;
}
@end














