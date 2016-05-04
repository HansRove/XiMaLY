//
//  AnchorMoreViewController.m
//  喜马拉雅FM(高仿品)
//
//  Created by YH_WY on 16/3/15.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "AnchorMoreViewController.h"
#import "AnchorListTableViewCell.h"
#import "BaseNetManager.h"
#import "AnchorDetailInfoViewController.h"

@interface AnchorMoreViewController ()
<
UITableViewDataSource,UITableViewDelegate
>
{
    BOOL _isChangeCondition;  // 控制着清空数组
    NSUInteger _pageId;
    NSUInteger _page;
    NSUInteger _countPage;
    NSUInteger _selectedIndex;  // 记住上次选中
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,readwrite,strong) NSMutableArray *anchorMArray;
@property (nonatomic,readwrite,strong) NSString *condition;
@end

static NSString *const anchorCellIdentifier = @"AnchorListTableViewCell";
@implementation AnchorMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"主播列表", nil);
    self.anchorMArray = [NSMutableArray array];
    
    _condition = @"hot";
    _selectedIndex = 10;
    [self getMoreAnthorFromService];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AnchorListTableViewCell" bundle:nil] forCellReuseIdentifier:anchorCellIdentifier];
    self.tableView.rowHeight = 120;
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        if (_page < _countPage) {   // 当前页数，小于服务器总共页数，则去服务器更新数据
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getMoreAnthorFromService];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)changedCondition:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (_selectedIndex == index) {
        return;
    }
    _selectedIndex = index;
    _isChangeCondition = YES;
    if (index == 0) {
        _condition = @"hot";
    } else {
        _condition = @"new";
    }
    _pageId = 1;
    _page = 20;
    [self getMoreAnthorFromService];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _anchorMArray.count;
}

// 分组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnchorListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:anchorCellIdentifier forIndexPath:indexPath];
    
    [cell bindAnchorListTableViewCellContentData:self.anchorMArray[indexPath.section]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnchorDetailInfoViewController *ctrlVC = [[AnchorDetailInfoViewController alloc] initWithNibName:@"AnchorDetailInfoViewController" bundle:nil];
    ctrlVC.anthorTitle = _anchorMArray[indexPath.section][@"nickname"];  //personDescribe
    ctrlVC.anthorUid = [_anchorMArray[indexPath.section][@"uid"] integerValue];
    [self.navigationController pushViewController:ctrlVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

#define autoLoadMoreRatio 0.9
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_page < _countPage && scrollView.contentOffset.y+scrollView.bounds.size.height>scrollView.contentSize.height*autoLoadMoreRatio) {
        
        [self.tableView.mj_footer beginRefreshing];
    }
}

#pragma mark - Services
- (void)getMoreAnthorFromService {
    
    // news hot
    NSString *url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/m/explore_user_list?category_name=%@&condition=%@&device=android&page=%ld&per_page=20",_category_name,_condition,_pageId];
    
    NSString *encodURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *encodURL = [url stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
    
    NSLog(@"%@",encodURL);
    [[BaseNetManager defaultManager] GET:encodURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            _countPage = [responseObject[@"totalCount"] unsignedIntegerValue];
            
            if ([responseObject[@"list"] count]) {
                
                if (_isChangeCondition && _pageId == 1) {
                    [self.anchorMArray removeAllObjects];
                }
                
                [self.anchorMArray addObjectsFromArray:responseObject[@"list"]];
            }
            
        }
        
        [self.tableView reloadData];
        
        _pageId++;
        _page += 20;
        _isChangeCondition = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


@end
