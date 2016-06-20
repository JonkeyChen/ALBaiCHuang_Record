//
//  AppDelegate.m
//  BaiChuanTest
//
//  Created by 陈胜华 on 16/6/17.
//  Copyright © 2016年 oneyd.me. All rights reserved.
//

#import "AppDelegate.h"
#import <ALBBSDK/ALBBSDK.h>

@interface AppDelegate ()

@end

//tbopen
static NSString *const baiChuanAppKey    = @"23389263";                        //阿里百川appkey
static NSString *const baiChuanAppSecret = @"0aeae74d72f41ede696f37148b177e6e";//阿里百川appSecret
static NSString *const baiChuanSpaceName = @"jonkeychen.baichuan";             //
static NSString *const baiChuanImage     = @"jonkeychenbaichuan.image.alimmdn.com";//阿里百川图片域名

@implementation AppDelegate

//DEMO_NAMESPACE 这个参数，对应控制台里面的 “空间名”namespace
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[ALBBSDK sharedInstance] setDebugLogOpen:NO];//开发阶段打开日志开关，方便排查错误信息
    
    //授权注册阿里百川
    [[ALBBSDK sharedInstance] asyncInit:^{
        
        NSLog(@"注册授权成功(阿里百川)");
    } failure:^(NSError *error) {
        
        NSLog(@"注册授权失败(阿里百川 %@)",error);
    }];
    
    return YES;
}

@end
