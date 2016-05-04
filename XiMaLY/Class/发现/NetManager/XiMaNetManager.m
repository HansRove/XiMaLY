//
//  XiMaNetManager.m
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "XiMaNetManager.h"

#define kRankListPath       @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album"
#define kAlbumPath          @"http://mobile.ximalaya.com/mobile/others/ca/album/track/%@/true/%@/20"

@implementation XiMaNetManager

+ (id)getRankListWithPageId:(NSInteger)pageId completionHandle:(void (^)(id, NSError *))completionHandle{
//只能使用单独传参方式。  使用地址+参数字符串 会导致程序崩溃!
    NSDictionary *params = @{@"device":@"iPhone", @"key":@"ranking:album:played:1:2", @"pageId":@(pageId), @"pageSize": @20, @"position": @0, @"title": @"排行榜"};
    return [self GET:kRankListPath parameters:params complationHandle:^(id responseObject, NSError *error) {
        
//        NSLog(@"url = %@",responseObject.r)
        
        completionHandle([RankingListModel mj_objectWithKeyValues:responseObject], error);
    }];
}

+ (id)getAlbumWithId:(NSInteger)ID page:(NSInteger)pageId completionHandle:(void (^)(id, NSError *))completionHandle{
//  %@  已经拼入 宏定义 kAlbumPath 中
    NSString *path = [NSString stringWithFormat:kAlbumPath, @(ID), @(pageId)];
    return [self GET:path parameters:@{@"device": @"iPhone"} complationHandle:^(id responseObject, NSError *error) {
        completionHandle([AlbumModel mj_objectWithKeyValues:responseObject], error);
    }];
}

@end










