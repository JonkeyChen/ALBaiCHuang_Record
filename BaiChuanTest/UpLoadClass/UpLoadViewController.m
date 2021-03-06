//
//  UpLoadViewController.m
//  BaiChuanTest
//
//  Created by 陈胜华 on 16/6/20.
//  Copyright © 2016年 oneyd.me. All rights reserved.
//

#import "UpLoadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "NSURL+Extend.h"
#import <ALBBSDK/ALBBSDK.h>
#import "ALBBMedia.h"
#import "UpLoadCell.h"
#import "PlayerVideoViewController.h"

static NSString *const cellIndentifier = @"UpLoadViewCell";

@interface UpLoadViewController ()<UpLoadCellDelegate>{
    
    __weak IBOutlet UITableView *_evtblImagesList;
    
    UIImagePickerController *_picker;
    
    NSMutableArray<NSMutableDictionary*> *_imagesArray;
}


@end

@implementation UpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self efConfigure];
}

//配置UI及数据
- (void)efConfigure{

    _picker = ({
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, (NSString *) kUTTypeImage, nil];
        picker;
    });
    
    [_evtblImagesList registerNib:[UINib nibWithNibName:@"UpLoadCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
    
    _imagesArray = [NSMutableArray new];
}

/*********************************************************************/
- (IBAction)efOnClickSelectedPictures:(id)sender {

    NSLog(@"选择图片");
    
    [self presentViewController:_picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [_picker dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *localUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSString *mediaurl = localUrl.absoluteString;
    
    
    BOOL flag = YES;
    
    for (NSDictionary *info in _imagesArray) {
        
        if ([mediaurl isEqualToString:[info objectForKey:@"assetsUrl"]]) {
            
            flag = NO;
            
            break;
        }
    }
    
    if (flag) {
        [_imagesArray addObject:[@{@"assetsUrl" : mediaurl,
                                  @"type" : @0,
                                  @"name" : [self uuidString],
                                  @"uploadedSize " : @0,
                                  @"size" : @0,
                                  @"status" : @0
                                  } mutableCopy]];
    }
    
    _evtblImagesList.rowHeight = 120;
    
    [_evtblImagesList reloadData];
    
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_imagesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    cell.delegate = self;
    
    NSMutableDictionary *data = [_imagesArray objectAtIndex:indexPath.item];
    
    NSString *path;
    if ([[data objectForKey:@"type"] integerValue] == 0) {
        path = [data objectForKey:@"assetsUrl"];
        if (![data objectForKey:@"image"]) {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullResolutionImage];
                if (iref) {
                    [data setObject:[UIImage imageWithCGImage:iref] forKey:@"image"];
                    [data setObject:[NSNumber numberWithLongLong:[rep size]] forKey:@"size"];
                    [data setObject:rep.filename forKey:@"filename"];
                    [_evtblImagesList reloadData];
                }
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
                //NSLog(@"cant get image - %@", [myerror localizedDescription]);
            };
            
            NSURL *asseturl = [NSURL URLWithString:path];
            ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
        
        cell.evimgeHeader.layer.cornerRadius = 32;
        cell.evimgeHeader.layer.masksToBounds = YES;
        cell.evbtnCancleUpLoad.layer.cornerRadius = 1.5;

        cell.row = (int) indexPath.item;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.evbtnCancleUpLoad.tag = indexPath.item;
        cell.deleteRow = ^(int row) {
            [_imagesArray removeObjectAtIndex:row];
            [_evtblImagesList reloadData];
        };
        cell.data = data;
    }
    
    return cell;
}

- (void)upLoadCell:(UpLoadCell *)cell withData:(NSMutableDictionary *)data withLoadStatus:(LoadStatus)loadStatus{
    
    NSLog(@"%@",data);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"refresh......%@,%@",@(loadStatus),_imagesArray);
        
        [_evtblImagesList reloadData];
    });
}

- (void)upLoadCell:(UpLoadCell *)cell withIndexPath:(NSInteger)indexPath withData:(NSMutableDictionary *)data {
    
    if ([NSString stringWithFormat:@"%@",[data objectForKey:@"url"]]) {
        
        PlayerVideoViewController *playerVC = [[PlayerVideoViewController alloc]init];
        
        playerVC.playerUrl = data[@"url"];
        
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}

- (NSString *)uuidString {
    
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    return uuidString;
}

/*********************************************************************/
- (IBAction)efOnClickCancelUpLoad:(id)sender {
    
    NSLog(@"全部取消");
}

@end
