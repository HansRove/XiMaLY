//
//  XiMaAlbumViewModel.h
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseViewModel.h"
#import "XiMaNetManager.h"

@interface XiMaAlbumViewModel : BaseViewModel
/** 专门的初始化方法 */
- (instancetype)initWithAlbumId:(NSInteger)albumId NS_DESIGNATED_INITIALIZER;
@property(nonatomic) NSInteger albumId;
/** 行数 */
@property(nonatomic) NSInteger rowNumber;
/** 当前请求页数 */
@property(nonatomic) NSInteger pageId;
/** 最大页数 */
@property(nonatomic) NSInteger maxPageId;
/** 是否有更多页 */
@property(nonatomic, getter=isHasMore) BOOL hasMore;
/** 获取某行的封面图片URL */
- (NSURL *)coverURLForRow:(NSInteger)row;
/** 获取某行题目 */
- (NSString *)titleForRow:(NSInteger)row;
/** 获取某行更新时间 */
- (NSString *)timeForRow:(NSInteger)row;
/** 获取某行出处 */
- (NSString *)sourceForRow:(NSInteger)row;
/** 获取某行播放数 */
- (NSString *)playCountForRow:(NSInteger)row;
/** 获取某行喜欢数 */
- (NSString *)favorCountForRow:(NSInteger)row;
/** 获取某行评论数 */
- (NSString *)commentCountForRow:(NSInteger)row;
/** 获取某行播放时长 */
- (NSString *)durationForRow:(NSInteger)row;
/** 获取某行下载链接地址 */
- (NSURL *)downLoadURLForRow:(NSInteger)row;
/** 获取某行音频播放地址 */
- (NSURL *)musicURLForRow:(NSInteger)row;
@end













