//
//  AnchorTopView.m
//  喜马拉雅FM(高仿品)
//
//  Created by YH_WY on 16/3/23.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "AnchorTopView.h"


@implementation AnchorTopView

- (void)awakeFromNib {
    
    self.iconImageButton.layer.cornerRadius = 40.f;
    self.iconImageButton.clipsToBounds = YES;

}

- (IBAction)handleTopViewButtonDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(anchorTopViewContentButton:)]) {
        [self.delegate anchorTopViewContentButton:sender];
    }
}

@end
