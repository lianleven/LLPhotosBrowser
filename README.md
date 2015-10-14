# LYPhotoBrowser
# 一行代码为你的应用添加简单的照片浏览器，支持本地和远程
使用很简单的照片浏览器

# 效果如下


![](https://github.com/lianleven/LYPhotoBrowser/raw/master/LYBrowser.gif) 
# 如何使用
NSArray *urlArray = @[@"http://h.hiphotos.baidu.com/image/pic/item/ac345982b2b7d0a2ab6ef529ceef76094a369adb.jpg",
                          @"http://pic3.bbzhi.com/xitongbizhi/gaoduibidujingmeigaoqingkuan/computer_kuan_281529_18.jpg",
                          @"http://d.hiphotos.baidu.com/image/pic/item/1f178a82b9014a90cd5ab709ac773912b31bee1a.jpg",
                          @"http://a.hiphotos.baidu.com/image/pic/item/94cad1c8a786c917b77e890dcc3d70cf3bc75781.jpg",
                          ];
    
    NSMutableArray *photoArrayM = @[].mutableCopy;
    
    for (UIImageView *imageView in self.imageViewArray) {
        NSInteger index = [self.imageViewArray indexOfObject:imageView];
        LYPhoto *photo = [LYPhoto photoWithImageView:imageView placeHold:imageView.image photoUrl:urlArray[index]];
        [photoArrayM addObject:photo];
    }
    UIView *view = gestureRecognizer.view;
    NSInteger index = [self.imageViewArray indexOfObject:view];
    
    [LYPhotoBrowser showPhotos:photoArrayM currentPhotoIndex:index countType:LYPhotoBrowserCountTypePageControl];
