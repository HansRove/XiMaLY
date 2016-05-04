//
//  MusicListViewController.m
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "MusicListViewController.h"
#import "XiMaAlbumViewModel.h"
#import "MusicDetailCell.h"

@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) XiMaAlbumViewModel *albumVM;
@property(nonatomic,strong) UITableView *tableView;
@end
@implementation MusicListViewController
- (XiMaAlbumViewModel *)albumVM{
    if (!_albumVM) {
        _albumVM=[[XiMaAlbumViewModel alloc] initWithAlbumId:_albumId];
    }
    return _albumVM;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_tableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.tableFooterView=[UIView new];
//给个猜测的行高，让cell可以自行计算应该有的高度        
        _tableView.estimatedRowHeight =UITableViewAutomaticDimension;
        _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [self.albumVM refreshDataCompletionHandle:^(NSError *error) {
               if (error) {
//                   [self showErrorMsg:error.localizedDescription];
               }else{
                   [_tableView reloadData];
                   [_tableView.mj_footer resetNoMoreData];
               }
               [_tableView.mj_header endRefreshing];
           }];
        }];
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.albumVM getMoreDataCompletionHandle:^(NSError *error) {
                if (error) {
//                    [self showErrorMsg:error.localizedDescription];
                    [_tableView.mj_footer endRefreshing];
                }else{
                    [_tableView reloadData];
                    if (self.albumVM.isHasMore) {
                       [_tableView.mj_footer endRefreshing];
                    }else{
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }];
        }];
    }
    return _tableView;
}

- (instancetype)initWithAlbumId:(NSInteger)albumId{
    if (self = [super init]) {
        self.albumId = albumId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.coverIV setImageWithURL:[self.albumVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_1"]];
    cell.titleLb.text=[self.albumVM titleForRow:indexPath.row];
//    cell.timeLb.text = [self.albumVM timeForRow:indexPath.row];
    cell.sourceLb.text=[self.albumVM sourceForRow:indexPath.row];
    cell.playCountLb.text=[self.albumVM playCountForRow:indexPath.row];
    cell.favorCountLb.text=[self.albumVM favorCountForRow:indexPath.row];
    cell.commentCountLb.text=[self.albumVM commentCountForRow:indexPath.row];
    cell.durationLb.text = [self.albumVM durationForRow:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[PlayView sharedInstance] playWithURL:[self.albumVM musicURLForRow:indexPath.row]];
}
//允许自动布局
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
