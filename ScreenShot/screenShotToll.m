//
//  screenShotToll.m
//  ScreenShot
//
//  Created by 函冰 on 2017/9/4.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import "screenShotToll.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface screenShotToll ()

/** 文件夹管理者   */
@property (nonatomic ,strong) NSFileManager *manager;

@end

@implementation screenShotToll

+ (instancetype)shareInstance
{
    static screenShotToll *toll ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toll = [[screenShotToll alloc] init];
    });
    return toll;
}
- (NSFileManager *)manager
{
    if (!_manager) {
        //创建一个属性
        _manager = [NSFileManager defaultManager];
    }
    return  _manager;
}
+ (UIImage *)shotInView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)writeImageToHD:(NSInteger)time inView:(UIView *)view writeOk:(void (^)(BOOL isOK))writeOK
{
//    创建gif图的文件保存目录
    __block NSString *imagePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    imagePath = [imagePath stringByAppendingPathComponent:@"gif"];
    [[screenShotToll shareInstance].manager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    __block int i = 1;
//    为即将保存的图片设置图片名称
    __block NSString *imagePS = [imagePath stringByAppendingString:[NSString stringWithFormat:@"/image-%d.png",i]];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        将定时器时间内每隔.1（截图频率，自己可以控制）的屏幕截图储存起来，保存成功后进行下一张存放
        if ([UIImagePNGRepresentation([screenShotToll shotInView:view]) writeToFile:imagePS atomically:YES] && i  < (time / .1)) {
            i ++;
            imagePS = [imagePath stringByAppendingString:[NSString stringWithFormat:@"/image-%d.png",i]];
        }else{
//            屏幕截图完成后返回YES，图片数量 = time / 截图频率
            [timer invalidate];
            timer = nil;
            writeOK(YES);
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
+ (void)RecordScreenInView:(UIView *)view During:(NSInteger)time gifPath:(void (^)(NSString *gifsPath))gifsPath
{
    
    [[screenShotToll shareInstance] writeImageToHD:time inView:view writeOk:^(BOOL isOK) {
        if (isOK) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            path = [path stringByAppendingPathComponent:@"/gif"];
//            创建数组保存所有图片
            NSMutableArray *images = [NSMutableArray array];
            for (int j = 1; j < time / .1; j ++) {
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/image-%d.png",path,j]];
                if (image) {
                    [images addObject:image];
                }
            }
            CGImageDestinationRef destination;
            NSString *doucument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            设置gif图的储存地址
            NSString *gif = [doucument stringByAppendingPathComponent:@"gif"];
            [[screenShotToll shareInstance].manager createDirectoryAtPath:gif withIntermediateDirectories:YES attributes:nil error:nil];
//            获取gif的储存地址 --- 再往下的是我在网上扒了好久扒到的
            NSString *gifPath = [gif stringByAppendingPathComponent:@"image.gif"];
            CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)gifPath, kCFURLPOSIXPathStyle, false);
            destination = CGImageDestinationCreateWithURL(url,kUTTypeGIF, images.count, NULL);
//            接下来配置制作gif时的一些属性
            NSDictionary *framePro = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:.5],(NSString *)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];
            [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString *)kCGImagePropertyDepth];
            [dict setObject:(NSString *)kCGImagePropertyGIFImageColorMap forKey:(NSString *)kCGImagePropertyColorModel];
            [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
            
//            遍历截图数组，制作gif图
            NSDictionary *gifPro = [NSDictionary dictionaryWithObject:dict forKey:(NSString *)kCGImagePropertyGIFDictionary];
            for (UIImage *image in images) {
                CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)framePro);
            }
            CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifPro);
            CGImageDestinationFinalize(destination);
            CFRelease(destination);
            
            gifsPath(gifPath);
        }
    }];
}


@end
