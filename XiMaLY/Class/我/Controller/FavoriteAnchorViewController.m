//
//  FavoriteAnchorViewController.m
//  XiMaLY
//
//  Created by macbook on 16/4/21.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "FavoriteAnchorViewController.h"
#import "AnchorDetailInfoViewController.h"
#import "PromptView.h"

@interface FavoriteAnchorViewController ()
<
    UITableViewDataSource,UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,readwrite,strong) NSArray *anchorList;

@end

@implementation FavoriteAnchorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"关注主播列表", nil);
    
    NSString *documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *filePath = [documPath stringByAppendingPathComponent:@"focusAnchorList.plist"];
    
    self.anchorList = [NSArray arrayWithContentsOfFile:filePath];
    
    if (self.anchorList) {
        self.tableView.rowHeight = 70.f;
        self.tableView.tableFooterView = [UIView new];
    } else {
        
        [PromptView promptViewShowInSuperView:self.view promptType:(PromptTypeNoneData) dataSource:self.anchorList actionBlock:nil];
    
    }
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _anchorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSURL *picURL = [NSURL URLWithString:_anchorList[indexPath.row][@"mobileMiddleLogo"]];
    
    [cell.imageView setImageWithURL:picURL placeholderImage:[UIImage imageNamed:@"cell_bg_noData_6"]];
    
    cell.textLabel.text = _anchorList[indexPath.row][@"nickname"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnchorDetailInfoViewController *ctrlVC = [[AnchorDetailInfoViewController alloc] initWithNibName:@"AnchorDetailInfoViewController" bundle:nil];
    ctrlVC.anthorTitle = _anchorList[indexPath.row][@"nickname"];  //personDescribe
    ctrlVC.anthorUid = [_anchorList[indexPath.row][@"uid"] integerValue];
    [self.navigationController pushViewController:ctrlVC animated:YES];
}

@end
