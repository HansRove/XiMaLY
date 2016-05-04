//
//  DownloadSongViewController.m
//  XiMaLY
//
//  Created by macbook on 16/4/22.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "DownloadSongViewController.h"
#import "PromptView.h"
#import "MusicDetailCell.h"

@interface DownloadSongViewController ()
<
UITableViewDataSource,UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,readwrite,strong) NSString *filePath;
@property (nonatomic,readwrite,strong) NSMutableArray *downloadList;

@end

static NSString *const musicIdentifier = @"MusicDetailCell";
@implementation DownloadSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"下载列表", nil);
    
    NSString *documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    _filePath = [documPath stringByAppendingPathComponent:@"downloadList.plist"];
    
    self.downloadList = [NSMutableArray arrayWithContentsOfFile:_filePath];
    
    if (self.downloadList) {
        self.tableView.rowHeight = 90.f;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:musicIdentifier];
    } else {
        
        [PromptView promptViewShowInSuperView:self.view promptType:(PromptTypeNoneData) dataSource:self.downloadList actionBlock:nil];
        
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
  
    return self.downloadList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:musicIdentifier forIndexPath:indexPath];
    NSURL *coverURL = [NSURL URLWithString:self.downloadList[indexPath.row][@"coverSmall"]];
    [cell.coverIV setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
    cell.titleLb.text = self.downloadList[indexPath.row][@"title"];
    cell.sourceLb.text = self.downloadList[indexPath.row][@"nickname"];
    
    NSString *updateStr = nil;
    if ([self.downloadList[indexPath.row][@"createdAt"] isKindOfClass:[NSString class]]) {
        updateStr = self.downloadList[indexPath.row][@"createdAt"];
    } else {
        // 获取当前时时间戳
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        // 创建歌曲时间戳
        NSTimeInterval createTime = [self.downloadList[indexPath.row][@"createdAt"] floatValue]/1000;
        // 时间差
        NSTimeInterval time = currentTime - createTime;
        NSInteger minutes = time/60;
        if (minutes<60) {
            updateStr = [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        } else {
            // 秒转小时
            NSInteger hours = time/60/60;
            
            if (hours<24) {
                updateStr = [NSString stringWithFormat:@"%ld小时前",(long)hours];
            } else {
                //秒转天数
                NSInteger days = time/3600/24;
                if (days < 30) {
                    updateStr = [NSString stringWithFormat:@"%ld天前",(long)days];
                } else {
                    //秒转月
                    NSInteger months = time/3600/24/30;
                    //秒转年
                    NSInteger years = time/3600/24/30/12;
                    if (months < 12) {
                        updateStr = [NSString stringWithFormat:@"%ld月前",(long)months];
                    } else {
                        updateStr = [NSString stringWithFormat:@"%ld年前",(long)years];
                    }
                }
            }
        }
    }
    cell.updateTimeLb.text = updateStr ;
    
    
    NSString *durationStr = nil;
    if ([self.downloadList[indexPath.row][@"duration"] isKindOfClass:[NSString class]]) {
        durationStr = self.downloadList[indexPath.row][@"duration"];
    } else {
        
        NSTimeInterval duration = [self.downloadList[indexPath.row][@"duration"] floatValue];
        // 分
        NSInteger durMinutes = duration/60;
        // 秒
        NSInteger seconds = (NSInteger)duration%60;
        durationStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)durMinutes,(long)seconds];
    }
    
    cell.durationLb.text = durationStr;
    
    if (self.downloadList[indexPath.row][@"playtimes"]) {
        cell.playCountLb.text = [self.downloadList[indexPath.row][@"playtimes"] isKindOfClass:[NSString class]]?self.downloadList[indexPath.row][@"playtimes"] : [self.downloadList[indexPath.row][@"playtimes"] stringValue];
    } else {
        cell.playCountLb.text = [self.downloadList[indexPath.row][@"playsCounts"] stringValue];
    }
    
    if (self.downloadList[indexPath.row][@"likes"]) {
        cell.favorCountLb.text = [self.downloadList[indexPath.row][@"likes"] isKindOfClass:[NSString class]]?self.downloadList[indexPath.row][@"likes"] : [self.downloadList[indexPath.row][@"likes"] stringValue];
    } else {
        cell.favorCountLb.text = [self.downloadList[indexPath.row][@"sharesCounts"] stringValue];
    }
    
    if (self.downloadList[indexPath.row][@"comments"]) {
        cell.commentCountLb.text = [self.downloadList[indexPath.row][@"comments"] isKindOfClass:[NSString class]]?self.downloadList[indexPath.row][@"comments"] : [self.downloadList[indexPath.row][@"comments"] stringValue];
    } else {
        cell.commentCountLb.text = [self.downloadList[indexPath.row][@"commentsCounts"] stringValue];
    }
    
    cell.downloadBtn.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 通知按钮旋转,播放及按钮改变
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [NSURL URLWithString:self.downloadList[indexPath.row][@"coverSmall"]];
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fullPath = [cachesPath stringByAppendingPathComponent:self.downloadList[indexPath.row][@"downloadPath"]];
    
    userInfo[@"musicURL"] = [NSURL fileURLWithPath:fullPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
}

@end
