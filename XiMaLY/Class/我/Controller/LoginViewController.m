//
//  LoginViewController.m
//  XiMaLY
//
//  Created by macbook on 16/4/16.
//  Copyright © 2016年 HansRove. All rights reserved.
//

#import "LoginViewController.h"

#import "CateAnimationLogin.h"

@interface LoginViewController ()<CateAnimationLoginDelegate>

@property (nonatomic,readwrite,strong) NSString *userName;
@property (nonatomic,readwrite,strong) NSString *userPass;
@property (nonatomic,readwrite,strong) NSString *promptStr;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CateAnimationLogin *login=[[CateAnimationLogin alloc]initWithFrame:CGRectMake(0, 50,self.view.bounds.size.width, 400)];
    login.delegate = self;
    [self.view addSubview:login];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (IBAction)clickLoginButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInfomation.plist" ofType:nil];

    NSDictionary *userInfo= [NSDictionary dictionaryWithContentsOfFile:path];
    
    if ([self checkUserLoginInfomation]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = NSLocalizedString(@"欢迎回来！", nil);
        [hud hide:YES afterDelay:1];
        if ([self.delegate respondsToSelector:@selector(loginViewControllerDidLoginSuccess:)]) {
            [self.delegate loginViewControllerDidLoginSuccess:userInfo[_userName]];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = _promptStr;
        [hud hide:YES afterDelay:1];
    }
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL)isEmpty:(NSString *) str {

    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];

        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];

        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (BOOL)checkUserLoginInfomation {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserAccount" ofType:@"plist"];
    NSMutableDictionary *userdailycheckinDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    __block BOOL loginResult = NO;
    
    if ([self isEmpty:_userName]&&[self isEmpty:_userPass]) {
        _promptStr = @"请输入用户名和密码！";
    } else if ([self isEmpty:_userName]&&![self isEmpty:_userPass]) {
        _promptStr = @"用户名为空，请输入用户名！";
    } else if ([self isEmpty:_userPass]&&![self isEmpty:_userName]) {
        _promptStr = @"密码为空，请输入密码！";
    } else {
        __block NSString *p_errorPromptStr = nil;
        [userdailycheckinDict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([_userName isEqualToString:key]) {
                if ([_userPass isEqualToString:obj]) {
                    loginResult = YES;
                } else {
                    p_errorPromptStr = @"密码输入错误，请重新输入";
                }
                *stop = YES;
            } else {
                p_errorPromptStr = @"账号错误，请返回重新输入";
            }
        }];
        _promptStr = p_errorPromptStr;
    }
    return loginResult;
}


#pragma mark - CateAnimationLoginDelegate
- (void)cateAnimationLoginDidInputText:(UITextField *)textField {
    
    NSLog(@"%ld---%@",(long)textField.tag,textField.text);
    
    if (textField.tag == 100) {
        // 用户用
        _userName = textField.text;
    } else if (textField.tag == 200) {
        // 密码
        _userPass = textField.text;
    }
}


@end
