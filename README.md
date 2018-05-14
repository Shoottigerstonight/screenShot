# screenShot
####这是一个屏幕录制demo，用起来很简单。
#####具体的使用方法是：
 [screenShotToll RecordScreenInView:web During:5 gifPath:^(NSString *gifsPath) {
        
<br>//        获取到gif保存的地址，可以显示可以储存
<br>        NSLog(@"%@",gifsPath);
<br>//        显示
<br>        UIWebView *webs = [[UIWebView alloc] init];
<br>        webs.frame = CGRectMake(0, sheight / 2,swidth, sheight / 2);
<br>        [self.view addSubview:webs];
<br>       NSData *gifData = [NSData dataWithContentsOfFile:gifsPath];
<br>        [webs loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
<br>//        储存
<br>        NSData *data = [NSData dataWithContentsOfFile:gifsPath];
<br>//         保存到本地相册  ALAssetsLibrary需要导入头文件
<br>        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
<br>        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
<br>            NSLog(@"Success at %@", [assetURL path] );
<br>        }] ;
<br>   }];
    
<br>    收工
