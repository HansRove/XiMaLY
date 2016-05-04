//
//  RankListViewController.m
//  BaseProject
//
//  Created by apple-jd33 on 15/11/17.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "RankListViewController.h"
#import "XiMaCategoryCell.h"
#import "XiMaCategoryViewModel.h"
#import "MusicListViewController.h"
#import "DestinationViewController.h"
#import "TrackRankTableViewCell.h"
#import "AnchorRankTableViewCell.h"
#import "AnchorDetailInfoViewController.h"
// http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album?device=iPhone&key=ranking%3Aalbum%3Aplayed%3A1%3A2&pageId=1&pageSize=20&position=0&title=%E6%8E%92%E8%A1%8C%E6%A6%9C

@interface RankListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isChangeCondition;  // 控制着清空数组
    NSUInteger _pageId;
    NSUInteger _maxPageId;
//    NSUInteger _countPage;
    NSUInteger _selectedIndex;  // 记住上次选中
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *rankMArray;
@property(nonatomic,strong) XiMaCategoryViewModel *ximaVM;

@property (nonatomic,strong) NSString *rankingListTitle;
@property (nonatomic,strong) NSString *rankingListType;
@property (nonatomic,strong) NSString *rankingListKey;
@end


static NSString *const trackCellIdentifier = @"TrackRankTableViewCell";
static NSString *const anchorCellIdentifier = @"AnchorRankTableViewCell";
@implementation RankListViewController
- (XiMaCategoryViewModel *)ximaVM{
    if (!_ximaVM) {
        _ximaVM = [XiMaCategoryViewModel new];
    }
    return _ximaVM;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 170/2;
        _tableView.estimatedRowHeight = 170/2;
        [_tableView registerClass:[XiMaCategoryCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerNib:[UINib nibWithNibName:trackCellIdentifier bundle:nil] forCellReuseIdentifier:trackCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:anchorCellIdentifier bundle:nil] forCellReuseIdentifier:anchorCellIdentifier];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageId = 1;
            [self getRankListFromService];
        }];
        self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (_pageId<=_maxPageId) {
                [self getRankListFromService];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }];
    }
    return _tableView;
}

+ (UINavigationController *)defaultNavi{
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RankListViewController *vc = [RankListViewController new];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

- (instancetype)initWithTitle:(NSString *)title type:(NSString *)type rankingListKey:(NSString *)key {
    if (self = [super init]) {
        _rankingListTitle = title;
        _rankingListType = type;
        _rankingListKey = key;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rankMArray = [NSMutableArray arrayWithCapacity:100];
    
    self.navigationItem.title = _rankingListTitle;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _rankMArray.count;
//    return self.ximaVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_rankingListType isEqualToString:@"track"]) {
        
       TrackRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:trackCellIdentifier forIndexPath:indexPath];
        [cell bindTrackRankTableViewCellDataWithDictionary:_rankMArray[indexPath.row] indexPath:indexPath];
        return cell;
    } else if ([_rankingListType isEqualToString:@"album"]) {
        
        XiMaCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.titleLb.text = _rankMArray[indexPath.row][@"title"];
        [cell.iconIV setImageWithURL:[NSURL URLWithString:_rankMArray[indexPath.row][@"coverSmall"]] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_1"]];
        cell.orderLb.text = @(indexPath.row + 1).stringValue;
        cell.descLb.text = _rankMArray[indexPath.row][@"intro"];
        cell.numberLb.text = [NSString stringWithFormat:@"%@集",_rankMArray[indexPath.row][@"tracks"]];
        return cell;
    } else if ([_rankingListType isEqualToString:@"anchor"]) {
    
        AnchorRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:anchorCellIdentifier forIndexPath:indexPath];
        [cell bindAnchorRankTableViewCellDataWithDictionary:_rankMArray[indexPath.row] indexPath:indexPath];
        return cell;
    
    } else {
        return nil;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_rankingListType isEqualToString:@"track"]) {
        // 通知按钮旋转,播放及按钮改变
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"coverURL"] = [NSURL URLWithString:_rankMArray[indexPath.row][@"coverSmall"]];
        userInfo[@"musicURL"] = [NSURL URLWithString:_rankMArray[indexPath.row][@"playPath64"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
        
    } else if ([_rankingListType isEqualToString:@"album"]) {
        
        DestinationViewController *ctrlVC = [[DestinationViewController alloc] initWithAlbumId:[_rankMArray[indexPath.row][@"albumId"] integerValue] title:_rankMArray[indexPath.row][@"title"]];
        // 隐藏状态栏及底部栏
        ctrlVC.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:ctrlVC animated:YES];
    } else if ([_rankingListType isEqualToString:@"anchor"]) {
        
        AnchorDetailInfoViewController *ctrlVC = [[AnchorDetailInfoViewController alloc] initWithNibName:@"AnchorDetailInfoViewController" bundle:nil];
        ctrlVC.anthorTitle = _rankMArray[indexPath.row][@"nickname"];
        ctrlVC.anthorUid = [_rankMArray[indexPath.row][@"uid"] integerValue];
        [self.navigationController pushViewController:ctrlVC animated:YES];
    }
    
    
    
    
    
//    MusicListViewController *vc =[[MusicListViewController alloc] initWithAlbumId:[self.ximaVM albumIdForRow:indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Services
- (void)getRankListFromService {
    
    // news hot
    NSString *url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/%@?device=iPhone&key=%@&pageId=%ld&pageSize=20&position=0&title=排行榜",_rankingListType,_rankingListKey,(long)_pageId];
    
    NSString *encodURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"%@",encodURL);
    [[BaseNetManager defaultManager] GET:encodURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            _maxPageId = [responseObject[@"maxPageId"] unsignedIntegerValue];
            
            if ([responseObject[@"list"] count]) {
                
                if (_isChangeCondition && _pageId == 1) {
                    [self.rankMArray removeAllObjects];
                }
                
                [self.rankMArray addObjectsFromArray:responseObject[@"list"]];
            }
            
        }
        
        [self.tableView reloadData];
        
        _pageId++;
//        _page += 20;
        _isChangeCondition = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

@end
