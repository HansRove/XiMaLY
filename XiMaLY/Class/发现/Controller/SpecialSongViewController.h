//
//  SpecialSongViewController.h
//  喜马拉雅FM(高仿品)
//
//  Created by YH_WY on 16/3/14.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  精品听单控制器 */
@interface SpecialSongViewController : UIViewController

@property (nonatomic,readwrite,strong) NSString *specialTitle;
@property (nonatomic,readwrite,assign) NSUInteger specialId;

@end
