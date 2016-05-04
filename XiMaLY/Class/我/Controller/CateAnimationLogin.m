//
//  CateAnimationLogin.m
//  cutelogin
//
//  Created by nb616 on 16/1/9.
//  Copyright © 2016年 国服第一. All rights reserved.
//

#import "CateAnimationLogin.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeigh [UIScreen mainScreen].bounds.size.height
#define rectLeftArm CGRectMake(1, 90, 40, 65)
#define rectRightArm CGRectMake(header.frame.size.width / 2 + 60, 90, 40, 65)
#define rectLeftHand CGRectMake(kWidth/ 2 - 100, loginview.frame.origin.y - 22, 40, 40)
#define rectRightHand CGRectMake(kWidth/ 2 + 62, loginview.frame.origin.y - 22, 40, 40)


@interface CateAnimationLogin()<UITextFieldDelegate>

//猫的手
@property (strong,nonatomic) UIImageView *lefthand;
@property (strong,nonatomic) UIImageView *righthand;


//猫的蒙眼胳膊
@property (strong,nonatomic) UIImageView *lefthArm;
@property (strong,nonatomic) UIImageView *rightArm;
@property (assign,nonatomic) ClickType clicktype;


@end



@implementation CateAnimationLogin

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self drawView];
    }
    return self;
}


-(void)drawView{
    
    UIImageView* header = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/ 2 - 211 / 2, 100, 211, 109)];
    
    header.image=[UIImage imageNamed:@"header"];
    [self addSubview:header];
    
    _lefthArm=[[UIImageView alloc]initWithFrame:rectLeftArm];
    _lefthArm.image=[UIImage imageNamed:@"left"];
    [header addSubview:_lefthArm];
    
    
    _rightArm=[[UIImageView alloc]initWithFrame:rectRightArm];
    _rightArm.image=[UIImage imageNamed:@"right"];
    [header addSubview:_rightArm];

    
    UIView *loginview=[[UIView alloc]initWithFrame:CGRectMake(15, 200, kWidth-30, 160)];
    loginview.layer.borderWidth=1;
    loginview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    loginview.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:loginview];
    
    _lefthand = [[UIImageView alloc]initWithFrame:rectLeftHand];
    _lefthand.image = [UIImage imageNamed:@"hand"];
    [self addSubview:_lefthand];
    
    _righthand = [[UIImageView alloc]initWithFrame:rectRightHand];
    _righthand.image = [UIImage imageNamed:@"hand"];
    [self addSubview:_righthand];
    
    _userNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(30, 30, kWidth-90, 44)];
    _userNameTextField.tag = 100;
    _userNameTextField.delegate=self;
    _userNameTextField.layer.cornerRadius = 5;
    _userNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _userNameTextField.layer.borderWidth=0.7;
    _userNameTextField.placeholder = NSLocalizedString(@"请输入用户名或账号", nil);
    _userNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    _userNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *userimg=[[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 22, 22)];
    userimg.image=[UIImage imageNamed:@"user"];
    [_userNameTextField.leftView addSubview:userimg];
    [loginview addSubview:_userNameTextField];
    
    
    _PassWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 90,kWidth-90, 44)];
    _PassWordTextField.tag = 200;
    _PassWordTextField.delegate = self;
    _PassWordTextField.layer.cornerRadius = 5;
    _PassWordTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _PassWordTextField.layer.borderWidth = 0.5;
    _PassWordTextField.secureTextEntry = YES;
    _PassWordTextField.placeholder = NSLocalizedString(@"请输入密码", nil);
    _PassWordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _PassWordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _PassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* pssimag = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    pssimag.image = [UIImage imageNamed:@"pass"];
    [_PassWordTextField.leftView addSubview:pssimag];
    [loginview addSubview:_PassWordTextField];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_userNameTextField]) {
        if (_clicktype != clicktypePass) {
            _clicktype =clicktypeUser;
            return;
        }
        _clicktype=clicktypeUser;

        [UIView animateWithDuration:0.5 animations:^{
            self.lefthArm.frame = CGRectMake(self.lefthArm.frame.origin.x - 60, self.lefthArm.frame.origin.y + 30, self.lefthArm.frame.size.width, self.lefthArm.frame.size.height);
            
            self.rightArm.frame = CGRectMake(self.rightArm.frame.origin.x+48, self.rightArm.frame.origin.y + 30, self.rightArm.frame.size.width, self.rightArm.frame.size.height);
            
            self.lefthand.frame = CGRectMake(self.lefthand.frame.origin.x-70, self.lefthand.frame.origin.y, 40, 40);
            self.righthand.frame = CGRectMake(self.righthand.frame.origin.x +30, self.righthand.frame.origin.y, 40, 40);
        } completion:^(BOOL finished) {
            
        }];
    }else if ([textField isEqual:_PassWordTextField]){
        if (_clicktype == clicktypePass)
        {
            return;
        }
        _clicktype = clicktypePass;

        [UIView animateWithDuration:0.5 animations:^{
            self.lefthArm.frame = CGRectMake(self.lefthArm.frame.origin.x + 60, self.lefthArm.frame.origin.y - 30, self.lefthArm.frame.size.width, self.lefthArm.frame.size.height);
            
            self.rightArm.frame = CGRectMake(self.rightArm.frame.origin.x - 48, self.rightArm.frame.origin.y - 30, self.rightArm.frame.size.width, self.rightArm.frame.size.height);
            
            self.lefthand.frame = CGRectMake(self.lefthand.frame.origin.x + 70, self.lefthand.frame.origin.y, 0, 0);
            self.righthand.frame = CGRectMake(self.righthand.frame.origin.x - 30, self.righthand.frame.origin.y, 0, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if ([self.delegate respondsToSelector:@selector(cateAnimationLoginDidInputText:)]) {
        [self.delegate cateAnimationLoginDidInputText:textField];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}




@end
