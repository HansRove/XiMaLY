//
//  LoginViewController.h
//  XiMaLY
//
//  Created by macbook on 16/4/16.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLoginSuccess:(NSDictionary *)userInfo;

@end

@interface LoginViewController : UIViewController

@property (nonatomic,readwrite,weak) id<LoginViewControllerDelegate> delegate;

@end
