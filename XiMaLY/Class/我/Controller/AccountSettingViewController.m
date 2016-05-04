//
//  AccountSettingViewController.m
//  ServiceBusiness
//
//  Created by YH_WY on 16/4/5.
//  Copyright © 2016年 YunHan. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "UserCenterNomalCell.h"
#import "AccountSettingTableViewCell.h"
#import "PublishFooterView.h"

//#import "UserDefaultsManager.h"

@interface AccountSettingViewController ()
<
UITableViewDataSource,UITableViewDelegate,
PublishFooterViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,readwrite,strong) NSArray *settingArray;

@end


static NSString *const nomalCellIdentifier = @"UserCenterNomalCell";
static NSString *const settingCellIdentifier = @"AccountSettingTableViewCell";
@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"账号设置", nil);
//    NSDictionary *userInfo = [UserDefaultsManager userInfo];
//    NSString *phoneNumber = [userInfo[@"mobilePhone"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//    NSString *gender = [userInfo[@"gender"] isEqualToString:@"M"] ? @"男" : @"女";
//    DLog(@"%@",phoneNumber);
    self.settingArray = @[
                          @[
                              @{@"ctrlVC":@"",@"icon":@"",@"title":@"用户名",@"detail":@"修改",@"instr":@""},
                              @{@"ctrlVC":@"",@"icon":@"",@"title":@"常住地址",@"detail":@"广州",@"instr":@""},
                              @{@"ctrlVC":@"",@"icon":@"",@"title":@"性别",@"detail":@"男",@"instr":@""}
                              ],
                          @[
                              @{},
                              @{@"ctrlVC":@"",@"icon":@"",@"title":@"已绑定手机号",@"detail":@"更换",@"instr":@"183****8783"},
                              @{@"ctrlVC":@"",@"icon":@"",@"title":@"登录密码",@"detail":@"修改",@"instr":@"强"},
                              @{@"ctrlVC":@"",@"icon":@"",@"title":@"安保问题",@"detail":@"未设置",@"instr":@""}
                              ],
                          ];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:nomalCellIdentifier bundle:nil] forCellReuseIdentifier:nomalCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:settingCellIdentifier bundle:nil] forCellReuseIdentifier:settingCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self setHomePageNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _settingArray.count;
}

// 分组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    return [(NSArray *)_settingArray[section] count];
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier forIndexPath:indexPath];
        return cell;
        
    } else {
    
        UserCenterNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:nomalCellIdentifier forIndexPath:indexPath];
        
        NSArray *tempArray = _settingArray[indexPath.section];
        [cell bindUserCenterData:tempArray[indexPath.row]];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (!section) {
        return nil;
    }
    PublishFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"PublishFooterView" owner:self options:nil].lastObject;
    footerView.backgroundColor = [UIColor clearColor];
    footerView.delegate = self;
    [footerView setupFooterViewButtonBackgroundColor:[UIColor whiteColor] borderColor:UIColorFromRGB(0x50B3B9, 1) borderWidth:1.f corner:3.f title:@"退出账号" titleColor:UIColorFromRGB(0x50B3B9, 1)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section ? 60 : 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSArray *tempArray = _settingArray[indexPath.section];
//    if (!tempArray[indexPath.row][@"ctrlVC"] && [tempArray[indexPath.row][@"ctrlVC"] isEqualToString:@""]) {
//        return;
//    }
//    
//    // 跳转控制器
//    id ctrlVC = NSClassFromString(tempArray[indexPath.row][@"ctrlVC"]);
//    
//    [self.navigationController pushViewController:ctrlVC animated:YES];
}

#pragma mark - PublishFooterViewDelegate
- (void)publishFooterViewDidClickSubmitButton {
    // 底部按钮被点击, 注销
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您确定要退出吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
//        [UserDefaultsManager saveLoginStatus:NO];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
