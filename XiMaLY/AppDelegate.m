//
//  AppDelegate.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/9.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "AppDelegate.h"
#import "HRTabBarController.h"
#import "HRNavigationController.h"
#import "HRFindViewController.h"
#import "WelcomeViewController.h"

#import "HomePageViewModel.h"
#import "HomePageNetManager.h"  // 测试网络解析
#import "MoreCotentNetManager.h"  //  测试

#import "SpecialSongViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

/**  是否首次运行 展示Wellcome*/
- (BOOL)shouldShowWelcomePage
{
    NSString *path = [SandDocPath() stringByAppendingPathComponent:@"cureVersion.string"];
//    DLog(@"path = %@", path);
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *lastVersion = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if (!lastVersion) {
        
        [version writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return YES;
    }
    
    if (![version isEqualToString:lastVersion]) {
        
        [version writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return YES;
    }
    
    return NO;
}

#pragma mark -WelcomePage
- (void)welcomeEntryToHome
{
//    self.tabBarCtrl = [[LCTabBarController alloc] init];
//    self.tabBarCtrl.tabBarControllerDelegate = self;
//    self.window.rootViewController = self.tabBarCtrl;
    
    HRTabBarController *tab = [[HRTabBarController alloc] init];
    HRNavigationController *navi = [[HRNavigationController alloc] initWithRootViewController:tab];
    self.window.rootViewController = navi;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSString *parcentStr = [@"%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90" stringByRemovingPercentEncoding];
    NSLog(@"%@",parcentStr);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    SpecialSongViewController *navi = [[SpecialSongViewController alloc] initWithNibName:@"SpecialSongViewController" bundle:nil];
    
    if ([self shouldShowWelcomePage]) {
        
//        [PublicFunctions checkThirdPartApps];
        
        WelcomeViewController *welcomeCtrl = [[WelcomeViewController alloc] init];
        self.window.rootViewController = welcomeCtrl;
    } else {
    
        [self welcomeEntryToHome];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
