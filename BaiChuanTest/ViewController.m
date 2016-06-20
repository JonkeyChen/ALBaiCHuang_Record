//
//  ViewController.m
//  BaiChuanTest
//
//  Created by 陈胜华 on 16/6/17.
//  Copyright © 2016年 oneyd.me. All rights reserved.
//

#import "ViewController.h"
#import "UpLoadViewController.h"
#import "DownLoadViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)efOnClcikUpLoad:(id)sender {
    //上传
    
    UpLoadViewController *upLoadVC = [[UpLoadViewController alloc]init];
    
    [self.navigationController pushViewController:upLoadVC animated:YES];
}

- (IBAction)efOnClickDownload:(id)sender {
    //下载
    
    DownLoadViewController *downLoadVC = [[DownLoadViewController alloc]init];
    
    [self.navigationController pushViewController:downLoadVC animated:YES];
}


@end
