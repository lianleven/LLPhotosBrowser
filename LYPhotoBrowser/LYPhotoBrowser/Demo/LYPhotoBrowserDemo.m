//
//  ViewController.m
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/13.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "LYPhotoBrowserDemo.h"
#import "LYPhotoBrowser.h"
@interface LYPhotoBrowserDemo ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *imageArray;/**< <#属性描述#> */

@end

@implementation LYPhotoBrowserDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageArray = [NSMutableArray new];
    
    for (UIImageView *imageView in self.imageViewArray) {
        [self.imageArray addObject:imageView.image];
        imageView.userInteractionEnabled = YES;
        
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    }
    
}

- (void)tapAction:(UIGestureRecognizer *)gestureRecognizer{
    NSArray *imageUrlArray = @[@"http://h.hiphotos.baidu.com/image/pic/item/ac345982b2b7d0a2ab6ef529ceef76094a369adb.jpg",
                          @"http://pic3.bbzhi.com/xitongbizhi/gaoduibidujingmeigaoqingkuan/computer_kuan_281529_18.jpg",
                          @"http://d.hiphotos.baidu.com/image/pic/item/1f178a82b9014a90cd5ab709ac773912b31bee1a.jpg",
                          @"http://a.hiphotos.baidu.com/image/pic/item/94cad1c8a786c917b77e890dcc3d70cf3bc75781.jpg",
                          ];
    
    NSMutableArray *photoArrayM = @[].mutableCopy;
    
    for (UIImageView *imageView in self.imageViewArray) {
        NSInteger index = [self.imageViewArray indexOfObject:imageView];
        LYPhoto *photo = nil;
        //只有图片
        //photo = [LYPhoto photoWithImageView:nil placeHold:imageView.image photoUrl:nil];
        
        //只有图片对应的imageView
        photo = [LYPhoto photoWithImageView:imageView placeHold:nil photoUrl:nil];
        
        //只有图片对应的url
        //photo = [LYPhoto photoWithImageView:nil placeHold:nil photoUrl:imageUrlArray[index]];
        [photoArrayM addObject:photo];
    }
    UIView *view = gestureRecognizer.view;
    NSInteger index = [self.imageViewArray indexOfObject:view];
    
    [LYPhotoBrowser showPhotos:photoArrayM currentPhotoIndex:index countType:LYPhotoBrowserCountTypePageControl];
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
