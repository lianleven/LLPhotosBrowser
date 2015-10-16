# LYPhotoBrowser
简单的照片浏览器，支持本地图片和远程图片。（使用场景：1.聊天界面类似扣扣微信那样显示照片，2.微博和朋友圈。）如果有其他需求也可以提issues，我会尽快加上。
# （希望大家能够提出宝贵意见，例如代码的bug，书写的不规范，命名的不规范，代码的排版格式等等，只要是问题都希望能够提出来。希望大家能够帮助我提高，在此谢谢了）
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
