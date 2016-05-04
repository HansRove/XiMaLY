//
//  HRFindViewController.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/9.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "HRFindViewController.h"
#import "HomePageViewController.h"
#import "CategoryViewController.h"
#import "LiveViewController.h"
#import "RankingViewController.h"
#import "AnchorViewController.h"
//#import "RecommendViewController.h"


@interface HRFindViewController ()

@end

@implementation HRFindViewController

+ (UINavigationController *)defaultFindUINavigationController {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       HRFindViewController *findVC = [[HRFindViewController alloc] initWithViewControllerClasses:[self ViewControllerClasses] andTheirTitles:@[@"推荐",@"分类",@"榜单"]];
//        WMPageController的设置
        findVC.menuViewStyle = WMMenuViewStyleLine;
        // 设置每个item的宽
        findVC.itemsWidths = @[@(kWindowW/3),@(kWindowW/3),@(kWindowW/3)];
        findVC.progressColor = [UIColor redColor];
        findVC.progressHeight = 3.5;
        navi = [[UINavigationController alloc] initWithRootViewController:findVC];
    });
    return navi;
}

// 存响应的控制器
+ (NSArray *)ViewControllerClasses {
    return @[[HomePageViewController class],[CategoryViewController class] ,[RankingViewController class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"首页","");
    
    NSLog(@"%@",NSStringFromCGPoint(self.scrollView.contentOffset));
}

//- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
//    NSLog(@"select:%ld,current:%ld",index,currentIndex);
//}

@end
