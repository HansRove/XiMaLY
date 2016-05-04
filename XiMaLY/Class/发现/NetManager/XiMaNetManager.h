//
//  XiMaNetManager.h
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseNetManager.h"
#import "XiMaLaYaModel.h"

@interface XiMaNetManager : BaseNetManager
//下方注释是 VVDocumenter 插件生成的。 安装此插件，在任何需要注释的位置 写///   三个/ 就可以自动弹出注释模板了

/**
 *  获取音乐分类列表 top50
 *
 *  @param pageId 当前页数从1开始. eg 1,2,3,4,5...
 *
 *  @return 返回当前请求所在的任务
 */
+ (id)getRankListWithPageId:(NSInteger)pageId kCompletionHandle;

/**
 *  根据音乐组类型ID获取对应音乐列表。 两个参数的确定完全是靠经验,工作以后会有服务器人员告诉你哪些是参数,应该传什么!
 *
 *  @param ID     音乐组ID
 *  @param pageId 当前页数，从1开始 eg 1,2,3,4,5...
 *
 *  @return 返回当前请求所在任务
 */
+ (id)getAlbumWithId:(NSInteger)ID page:(NSInteger)pageId kCompletionHandle;

@end
