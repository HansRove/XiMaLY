//
//  AnchorDetailInfoViewController.m
//  喜马拉雅FM(高仿品)
//
//  Created by YH_WY on 16/3/16.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "AnchorDetailInfoViewController.h"
#import "BaseNetManager.h"
#import "AnchorTopView.h"
#import "MoreCategoryCell.h"
#import "MusicDetailCell.h"

#import "DestinationViewController.h"

@interface AnchorDetailInfoViewController ()
<
UITableViewDataSource,UITableViewDelegate,
AnchorTopViewDelegate
>
{
    NSUInteger _pageId;
    NSUInteger _page;
    NSUInteger _countPage;
    NSUInteger _albumTotalCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,readwrite,strong) AnchorTopView *topView;

@property (nonatomic,readwrite,strong) NSArray *albumArray;
@property (nonatomic,readwrite,strong) NSDictionary *anchorInfo;
@property (nonatomic,readwrite,strong) NSString *filePath;
@property (nonatomic,readwrite,strong) NSMutableArray *tracksMArray;
@property (nonatomic,readwrite,strong) NSMutableArray *anchorList;

@end


static NSString *const sysCellIdentifier = @"UITableViewCell";
static NSString *const albumCellIdentifier = @"MoreCategoryCell";
static NSString *const tracksCellIdentifier = @"MusicDetailCell";
@implementation AnchorDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    _filePath = [documPath stringByAppendingPathComponent:@"focusAnchorList.plist"];
    
    self.anchorList = [NSMutableArray arrayWithContentsOfFile:_filePath];
    
    self.tracksMArray = [NSMutableArray array];
    
    [self getAnthorDetailFormService];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (void)setupTableView {
    
    self.topView = [[NSBundle mainBundle] loadNibNamed:@"AnchorTopView" owner:self options:nil].firstObject;
    self.topView.delegate = self;
    [_topView setFrame:CGRectMake(0, -300, self.tableView.bounds.size.width, 250)];;
    [self.tableView addSubview:_topView];
    self.tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
    
//    self.topView.backgroundColor = [UIColor greenColor];
    
//    self.tableView.rowHeight = 95.f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sysCellIdentifier];
    [self.tableView registerClass:[MoreCategoryCell class] forCellReuseIdentifier:albumCellIdentifier];
    [self.tableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:tracksCellIdentifier];
    
    _pageId = 1;
    _page = 30;
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        if (_page < _countPage) {   // 当前页数，小于服务器总共页数，则去服务器更新数据
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getAnthorTrackFromService];
            });
        }
    }];
}

- (void)bindTopViewDataFromDictionary:(NSDictionary *)responseObject {

    if (!responseObject.count) {
        return ;
    }
    
    self.anchorInfo = responseObject;
    
    NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"backgroundLogo"]];
    
    [self.topView.bgImageView setImageWithURL:url];
    
    if (self.topView.bgImageView.image) {
        [self.topView.bgImageView setImage:[self coreBlurImage:self.topView.bgImageView.image withBlurNumber:1]];
    }
    
    self.topView.fansNumLabel.text = [[responseObject objectForKey:@"followers"] integerValue] > 10000 ? [NSString stringWithFormat:@"%.1lf万",[[responseObject objectForKey:@"followers"] integerValue]/10000.0] : [[responseObject objectForKey:@"followers"] stringValue];
    
    self.topView.praiseNumLabel.text = [[responseObject objectForKey:@"favorites"] integerValue] > 10000 ? [NSString stringWithFormat:@"%.1lf万",[[responseObject objectForKey:@"favorites"] integerValue]/10000.0] : [[responseObject objectForKey:@"favorites"] stringValue];
    
    self.topView.attentionNumLabel.text = [[responseObject objectForKey:@"followings"] integerValue] > 10000 ? [NSString stringWithFormat:@"%.1lf万",[[responseObject objectForKey:@"followings"] integerValue]/10000.0] : [[responseObject objectForKey:@"followings"] stringValue];
    
    [self.topView.iconImageButton setImageForState:(UIControlStateNormal) withURL:[NSURL URLWithString:[responseObject objectForKey:@"mobileMiddleLogo"]]];
    
    self.topView.anchorName.text = [responseObject objectForKey:@"nickname"];
    
    self.topView.explainLabel.text = [responseObject objectForKey:@"personDescribe"];

    self.topView.vipIconButton.hidden = ![[responseObject objectForKey:@"isVerified"] boolValue];
}

#define autoLoadMoreRatio 0.9
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_page < _countPage && scrollView.contentOffset.y+scrollView.bounds.size.height>scrollView.contentSize.height*autoLoadMoreRatio) {
        
        [self.tableView.mj_footer beginRefreshing];
    }
}

#pragma mark - AnchorTopViewDelegate
- (void)anchorTopViewContentButton:(UIButton *)sender {

    switch (sender.tag) {
        case 100:
            // 返回按钮
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 200:
            // 邮件按钮
            break;
        case 300:
            // 分享按钮
            break;
        case 400:
            // 关注按钮
        {
            NSDictionary *dict = @{
                                   @"uid":@(_anthorUid),
                                   @"nickname":self.anchorInfo[@"nickname"],
                                   @"mobileMiddleLogo":self.anchorInfo[@"mobileMiddleLogo"]
                                       };
            
            NSLog(@"%@",self.anchorInfo[@"nickname"]);
            __block NSUInteger listIdx = 99999;
            [self.anchorList enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"nickname"] isEqualToString:self.anchorInfo[@"nickname"]]) {
                    // 重复
                    listIdx = idx;
                    *stop = YES;
                }
            }];
            
            if (listIdx != 99999) {
                [self.anchorList removeObjectAtIndex:listIdx];
            }
            [self.anchorList addObject:dict];
            NSArray *tempArr = self.anchorList;
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
            break;
        
        }   
        case 500:
            // 关注的人按钮
            break;
        case 600:
            // 粉丝按钮
            break;
        case 700:
            // 赞过的按钮
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 分组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.albumArray.count;
    } else {
        return self.tracksMArray.count;
    }
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.section) {
        // 0行
        MoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellIdentifier forIndexPath:indexPath];
        [cell bindAnchorAlbumsData:self.albumArray[indexPath.row]];
        return cell;
    } else {
    
        MusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:tracksCellIdentifier forIndexPath:indexPath];
        [cell bindAnchorTracksData:self.tracksMArray[indexPath.row]];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        NSString *albumTitle = nil;
        
        if (_albumTotalCount > 0) {
            albumTitle = [NSString stringWithFormat:@"发布的专辑（%ld）",(long)_albumTotalCount];
        } else {
            albumTitle = [NSString stringWithFormat:@"发布的专辑"];
        }
        return albumTitle;
    } else if (section == 1) {
    
        NSString *tracksTitle = nil;
        
        if (_albumTotalCount > 0) {
            tracksTitle = [NSString stringWithFormat:@"发布的声音（%ld）",(long)_countPage];
        } else {
            tracksTitle = [NSString stringWithFormat:@"发布的声音"];
        }
        return tracksTitle;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section ? 95.f : 80.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 0行， 跳转到专辑播放页
        NSInteger albumId = [self.albumArray[indexPath.row][@"albumId"] integerValue];
        NSString *title = self.albumArray[indexPath.row][@"title"];
        DestinationViewController *vc = [[DestinationViewController alloc] initWithAlbumId:albumId title:title];
        // 隐藏状态栏及底部栏
        vc.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 1) {
        // 1行， 直接播放
        NSURL *coverURL =  [NSURL URLWithString:self.tracksMArray[indexPath.row][@"coverMiddle"]];
        NSURL *musicURL =  [NSURL URLWithString:self.tracksMArray[indexPath.row][@"playUrl64"]];
        // 通知按钮旋转,播放及按钮改变
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"coverURL"] = coverURL;
        userInfo[@"musicURL"] = musicURL;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
    }
    
}

#pragma mark - Services
- (void)getAnthorDetailFormService {
    
    NSString *url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/homePage?toUid=%ld&position=1&device=android&title=%@",(long)_anthorUid,_anthorTitle];
    
    /*
     会将后面字段转换%B0 这类
     
     URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
     URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
     URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
     URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
     URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
     URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     */
    NSString *encodURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSString *encodURL = [url stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
    NSLog(@"\n%@\n\n%@",@"ss",encodURL);
    
    [[BaseNetManager defaultManager] GET:encodURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
     
        NSLog(@"%@",responseObject);

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self bindTopViewDataFromDictionary:responseObject];
        
        }
 
        [self getAnthorAlbumFormService];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self getAnthorAlbumFormService];
        
    }];

}

- (void)getAnthorAlbumFormService {
    
    NSString *url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/%ld/1/2?toUid=%ld&position=1&device=ios&title=%@",(long)_anthorUid,(long)_anthorUid,_anthorTitle];
    
    NSString *encodURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *encodURL = [url stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
    
    NSLog(@"%@",encodURL);
    
    [[BaseNetManager defaultManager] GET:encodURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
           
            _albumTotalCount = [responseObject[@"totalCount"] integerValue];
            
            if ([responseObject[@"list"] count]) {
                
                self.albumArray = responseObject[@"list"];
            }
            
        }
        
        [self getAnthorTrackFromService];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self getAnthorTrackFromService];
        
    }];
 
}

- (void)getAnthorTrackFromService {

    NSString *url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/track/%ld/%ld/30?position=1&device=android&title=%@",(long)_anthorUid,(long)_pageId,_anthorTitle];
    
    NSString *encodURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *encodURL = [url stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
    
    NSLog(@"%@",encodURL);
    [[BaseNetManager defaultManager] GET:encodURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            _countPage = [responseObject[@"totalCount"] unsignedIntegerValue];
            
            _pageId++;
            _page += 30;
            
            if ([responseObject[@"list"] count]) {
                
                [self.tracksMArray addObjectsFromArray:responseObject[@"list"]];
            }
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}


@end
