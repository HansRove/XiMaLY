//
//  UserCenterViewController.m
//  ServiceBusiness
//
//  Created by YH_WY on 16/4/5.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterNomalCell.h"
#import "UserCenterInfoView.h"
#import "AccountSettingViewController.h"
#import "LoginViewController.h"
#import "FavoriteAnchorViewController.h"
#import "DownloadSongViewController.h"

//#import "UserDefaultsManager.h"
//#import "UIKit+AFNetworking.h"

@interface UserCenterViewController ()
<
UITableViewDataSource,UITableViewDelegate,
UserCenterInfoViewDelegate,LoginViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,readwrite,strong) NSArray *settingArray;

@property (nonatomic,readwrite,strong) UserCenterInfoView *infoView;

@end

static NSString *const nomalCellIdentifier = @"UserCenterNomalCell";
@implementation UserCenterViewController

+ (UINavigationController *)defaultUserCenterNavigationController {
    
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UserCenterViewController *userCenterVC = [[UserCenterViewController alloc] initWithNibName:@"UserCenterViewController" bundle:nil];
        navi = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    });
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.settingArray = @[
                          @[
                              @{@"icon":@"",@"title":@"我的发布",@"ctrlVC":@""},
                              @{@"icon":@"",@"title":@"我的圈子",@"ctrlVC":@""}
                              ],
                          @[
                              @{@"icon":@"",@"title":@"我的赞",@"ctrlVC":@""},
                              @{@"icon":@"",@"title":@"我的评价",@"ctrlVC":@""},
                              @{@"icon":@"",@"title":@"我的转发",@"ctrlVC":@""}
                              ],
                          ];
 
    [self.tableView registerNib:[UINib nibWithNibName:nomalCellIdentifier bundle:nil] forCellReuseIdentifier:nomalCellIdentifier];
    [self setupTableViewHeader];
    
    if (![self loginStatus]) {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:NO completion:nil];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [userDefaults objectForKey:@"isLogin"];
        _infoView.userName.text = userInfo[@"userName"];
        [_infoView.userHeadIcon setImageForState:(UIControlStateNormal) withURL:[NSURL URLWithString:userInfo[@"headPicture"]] placeholderImage:[UIImage imageNamed:@"app_loading"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)loginStatus
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"isLogin"] ;
}

#pragma mark - UITableViewHeader
- (void)setupTableViewHeader {
    
    // tableView必须做这个处理， 不然内部视图会改frame
    self.tableView.autoresizesSubviews = NO;
    _infoView = [[NSBundle mainBundle] loadNibNamed:@"UserCenterInfoView" owner:self options:nil].firstObject;
    [_infoView setFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    
//    NSDictionary *userInfo = [UserDefaultsManager userInfo];
//    _infoView.userName.text = [NSString stringWithFormat:@"%@%@",userInfo[@"lastName"],userInfo[@"firstName"]];
//    [_infoView.userHeadIcon setImageForState:(UIControlStateNormal) withURL:[NSURL URLWithString:userInfo[@"headPicture"]] placeholderImage:[UIImage imageNamed:@"app_loading"]];
//    [_infoView.bgImageView setImageWithURL:[NSURL URLWithString:@"http://mt1.baidu.com/timg?wh_rate=0&wapiknow&quality=100&size=w250&sec=0&di=9037f3be1d1cfb6cc152950dd7ef5a36&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fwh%253D800%252C450%2Fsign%3D113efda0e2dde711e7874bfe97dfe22f%2F0df3d7ca7bcb0a463643c69c6c63f6246b60af36.jpg"]];
    _infoView.delegate = self;
    [self.tableView addSubview:_infoView];
    self.tableView.contentInset = UIEdgeInsetsMake(220, 0, 0, 0);
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _settingArray.count;
}

// 分组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [(NSArray *)_settingArray[section] count];
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserCenterNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:nomalCellIdentifier forIndexPath:indexPath];
    
    NSArray *tempArray = _settingArray[indexPath.section];
    [cell bindUserCenterData:tempArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSArray *tempArray = _settingArray[indexPath.section];
//    if ([tempArray[indexPath.row][@"ctrlVC"] isEqualToString:@""]) {
//        return;
//    }
//    
//    // 跳转控制器
//    id ctrlVC = NSClassFromString(tempArray[indexPath.row][@"ctrlVC"]);
//    
//    [self.navigationController pushViewController:ctrlVC animated:YES];
    
//    [self.navigationController popViewControllerAnimated:NO];
//    [self.tabBarController setSelectedIndex:2];
    
}

#pragma mark - LoginViewControllerDelegate
- (void)loginViewControllerDidLoginSuccess:(NSDictionary *)userInfo {
    
    if (!userInfo || ![userInfo count]) {
        return ;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userInfo forKey:@"isLogin"];
    [userDefaults synchronize];
    
    _infoView.userName.text = userInfo[@"userName"];
    [_infoView.userHeadIcon setImageForState:(UIControlStateNormal) withURL:[NSURL URLWithString:userInfo[@"headPicture"]] placeholderImage:[UIImage imageNamed:@"app_loading"]];
    
}


#pragma mark - UserCenterInfoViewDelegate
- (void)userCenterInfoViewButtonDidClick:(NSUInteger)butonTag {

    switch (butonTag) {
    
        case 300:
        {   // 头像
            DLog(@"点击了头像");
            break;
        }
        case 400:
        {   // 技能
            DownloadSongViewController *dSVC = [[DownloadSongViewController alloc] init];
            [self.navigationController pushViewController:dSVC animated:YES];
            break;
        }
        case 500:
        {   // 需求
            FavoriteAnchorViewController *dSVC = [[FavoriteAnchorViewController alloc] initWithNibName:@"FavoriteAnchorViewController" bundle:nil];
            [self.navigationController pushViewController:dSVC animated:YES];
            break;
        }
        case 600:
        {
            // 设置
            //            DLog(@"点击了设置");
            AccountSettingViewController *ctrlVC = [[AccountSettingViewController alloc]init];
            [self.navigationController pushViewController:ctrlVC animated:YES];
            break;
            break;
        }
    }
}

#pragma mark - UIScrollViewDelegate
// 连带滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<-200) {
        CGRect frame = _infoView.frame;
        frame.origin.y = offsetY;
        frame.size.height = -offsetY;
        _infoView.frame = frame;
    }
}

@end
