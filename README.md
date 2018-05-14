# screenShot
这是一个屏幕录制demo，用起来很简单。
具体的使用方法是：
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
//         保存到本地相册  ALAssetsLibrary需要导入头文件
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            NSLog(@"Success at %@", [assetURL path] );
        }] ;
    }];
    
    收工
