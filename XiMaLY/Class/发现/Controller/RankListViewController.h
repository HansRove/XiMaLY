//
//  RankListViewController.h
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankListViewController : UIViewController
/*制作单例原因:侧边栏需要经常切换内容页，内容页不应该随着切换而被释放掉，每次切换的应该是同一个内存地址 */
//+ (UINavigationController *)defaultNavi;

- (instancetype)initWithTitle:(NSString *)title type:(NSString *)type rankingListKey:(NSString *)key;

@end












