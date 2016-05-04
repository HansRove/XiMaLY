//
//  AnchorViewController.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/10.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "AnchorViewController.h"
#import "AnchorViewModel.h"
#import "AnchorCell.h"
#import "TitleView.h"  // 分组头视图

#import "AnchorMoreViewController.h"
#import "AnchorDetailInfoViewController.h"


@interface AnchorViewController ()
<
UITableViewDataSource,UITableViewDelegate,
AnchorViewDelegate, TitleViewDelegate
>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) AnchorViewModel *anchorVM;
@property (nonatomic,readwrite,strong) NSString *filePath;
@property (nonatomic,readwrite,strong) NSMutableArray *focusAnchorList;
@end

@implementation AnchorViewController

+ (UINavigationController *)defaultAnthorNavigationController {
    
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AnchorViewController *anchorVC = [[AnchorViewController alloc] init];
        navi = [[UINavigationController alloc] initWithRootViewController:anchorVC];
    });
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"主播",nil);
    
    [MBProgressHUD showMessage:@"正在努力为您加载..."];
    [self.anchorVM getDataCompletionHandle:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView reloadData];
    }];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    _filePath = [path stringByAppendingPathComponent:@"focusAnchorList.plist"];
    
    self.focusAnchorList = [NSMutableArray arrayWithContentsOfFile:_filePath];
    
//     NSLog(@"%@\n%@",self.focusAnchorList,_filePath);
    if (!self.focusAnchorList) {
        self.focusAnchorList = [NSMutableArray array];
    }
}

#pragma mark - UITableView代理协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.anchorVM.section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnchorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACell"];
    cell.anchorView0.delegate = self;
    cell.anchorView0.indexPath = indexPath;
    cell.anchorView0.tag = 0;
    [cell.anchorView0.anchorBtn setImageForState:UIControlStateNormal withURL:[self.anchorVM coverURLForSection:indexPath.section Index:0] placeholderImage:[UIImage imageNamed:@"find_usercover"]];
    cell.anchorView0.nameLb.text = [self.anchorVM nameForSection:indexPath.section Index:0];
    
    cell.anchorView1.delegate = self;
    cell.anchorView1.indexPath = indexPath;
    cell.anchorView1.tag = 1;
    [cell.anchorView1.anchorBtn setImageForState:UIControlStateNormal withURL:[self.anchorVM coverURLForSection:indexPath.section Index:1] placeholderImage:[UIImage imageNamed:@"find_usercover"]];
    cell.anchorView1.nameLb.text = [self.anchorVM nameForSection:indexPath.section Index:1];
    
    cell.anchorView2.delegate = self;
    cell.anchorView2.indexPath = indexPath;
    cell.anchorView2.tag = 2;
    [cell.anchorView2.anchorBtn setImageForState:UIControlStateNormal withURL:[self.anchorVM coverURLForSection:indexPath.section Index:2] placeholderImage:[UIImage imageNamed:@"find_usercover"]];
    cell.anchorView2.nameLb.text = [self.anchorVM nameForSection:indexPath.section Index:2];
    
    return cell;
}

// 分组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TitleView *titleView = [[TitleView alloc] initWithTitle:[self.anchorVM mainTitleForSection:section] hasMore:1];
    titleView.section = section;
    titleView.delegate = self;
    return titleView;
}
// 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
// 尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

kRemoveCellSeparator

#pragma mark - AnchorViewDelegate
// 主播详情
- (void)anchorViewDidClickButtom:(NSIndexPath *)indexPath index:(NSUInteger)index {
    NSLog(@"%@",[self.anchorVM nameForSection:indexPath.section Index:index])
    ;
    
    AnchorDetailInfoViewController *ctrlVC = [[AnchorDetailInfoViewController alloc] initWithNibName:@"AnchorDetailInfoViewController" bundle:nil];
    
    // 传递参数
    ctrlVC.anthorTitle = [self.anchorVM nameForSection:indexPath.section Index:index];
    
    ctrlVC.anthorUid = [self.anchorVM anthorUidForSection:indexPath.section Index:index];
    
    [self.navigationController pushViewController:ctrlVC animated:YES];
    
}

- (void)anchorViewDidClickAttractButtom:(NSIndexPath *)indexPath index:(NSUInteger)index isAttracted:(BOOL)isAttacted {
    
    if (isAttacted) {
        
        NSDictionary *dict = @{@"uid":@([self.anchorVM anthorUidForSection:indexPath.section Index:index]),@"nickname":[self.anchorVM nameForSection:indexPath.section Index:index],@"mobileMiddleLogo":[NSString stringWithFormat:@"%@",[self.anchorVM coverURLForSection:indexPath.section Index:index]]};
        
        NSLog(@"%@",[self.anchorVM nameForSection:indexPath.section Index:index]);
        __block NSUInteger listIdx = 99999;
        [self.focusAnchorList enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"nickname"] isEqualToString:[self.anchorVM nameForSection:indexPath.section Index:index]]) {
                // 重复
                listIdx = idx;
                *stop = YES;
            }
        }];
        
        if (listIdx != 99999) {
            [self.focusAnchorList removeObjectAtIndex:listIdx];
        }
        [self.focusAnchorList addObject:dict];
        
        NSArray *tempArr = self.focusAnchorList;
        if ([tempArr writeToFile:_filePath atomically:YES]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = NSLocalizedString(@"主播关注成功", nil);
            [hud hide:YES afterDelay:1];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = NSLocalizedString(@"主播关注失败", nil);
            [hud hide:YES afterDelay:1];
        }
        
//        [self.focusAnchorList  writeToFile:_filePath atomically:YES];
        NSLog(@"%@\n%@",self.focusAnchorList,_filePath);
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = NSLocalizedString(@"已取消关注该主播", nil);
        [hud hide:YES afterDelay:1];
    }
}

#pragma mark - TitleViewDelegate
// 更多
- (void)titleViewDidClickSection:(NSInteger)section {
//    NSLog(@"%ld",(long)section);
    AnchorMoreViewController *ctrlVC = [[AnchorMoreViewController alloc] initWithNibName:@"AnchorMoreViewController" bundle:nil];
    ctrlVC.category_name = [self.anchorVM mainNameForSection:section];
    [self.navigationController pushViewController:ctrlVC animated:YES];
}


#pragma mark - VM,TableView懒加载
- (AnchorViewModel *)anchorVM {
    if (!_anchorVM) {
        _anchorVM = [AnchorViewModel new];
    }
    return _anchorVM;
}
- (UITableView *)tableView {
    if (!_tableView) {
        // 创建分组
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            // 防止头部空出一块
            make.top.mas_equalTo(-35);
            make.bottom.left.right.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AnchorCell class] forCellReuseIdentifier:@"ACell"];
        // 因为cell只有一个无特殊, indexPath不需要
        _tableView.rowHeight = [self.anchorVM cellHeightForIndexPath:nil];
        // 去分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 不能超
        _tableView.bounces = NO;
    }
    return _tableView;
}
@end
