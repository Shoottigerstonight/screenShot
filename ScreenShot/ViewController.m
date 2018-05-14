//
//  ViewController.m
//  ScreenShot
//
//  Created by 函冰 on 2017/9/4.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import "ViewController.h"
#import "screenShotToll.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    
    CGFloat swidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat sheight = [UIScreen mainScreen].bounds.size.height;
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = CGRectMake(0, 0,swidth, sheight / 2);
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    
    [screenShotToll RecordScreenInView:web During:5 gifPath:^(NSString *gifsPath) {
        
//        获取到gif保存的地址，可以显示可以储存
        NSLog(@"%@",gifsPath);
//        显示
        UIWebView *webs = [[UIWebView alloc] init];
        webs.frame = CGRectMake(0, sheight / 2,swidth, sheight / 2);
        [self.view addSubview:webs];
        NSData *gifData = [NSData dataWithContentsOfFile:gifsPath];
        [webs loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        储存
        NSData *data = [NSData dataWithContentsOfFile:gifsPath];
//         保存到本地相册
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            NSLog(@"Success at %@", [assetURL path] );
        }] ;
    }];
    
    
}


@end
