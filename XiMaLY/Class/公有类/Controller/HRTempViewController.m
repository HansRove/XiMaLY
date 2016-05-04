//
//  HRTempViewController.m
//  XiMaLY
//
//  Created by macbook on 16/5/4.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "HRTempViewController.h"
#import "PromptView.h"
@interface HRTempViewController ()

@end

@implementation HRTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = NSLocalizedString(@"论坛已移除", nil);
    
    [PromptView promptViewShowInSuperView:self.view promptType:(PromptTypeNoneData) dataSource:nil actionBlock:nil];

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
