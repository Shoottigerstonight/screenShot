//
//  screenShotToll.h
//  ScreenShot
//
//  Created by 函冰 on 2017/9/4.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface screenShotToll : NSObject
+ (UIImage *)shotInView:(UIView *)view;
+ (void)RecordScreenInView:(UIView *)view During:(NSInteger)time gifPath:(void (^)(NSString *gifsPath))gifsPath;
@end
