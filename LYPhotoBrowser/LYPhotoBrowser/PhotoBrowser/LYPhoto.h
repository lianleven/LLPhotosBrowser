//
//  LYPhoto.h
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/14.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface LYPhoto : NSObject



+ (instancetype)photoWithImageView:(UIImageView *)imageView placeHold:(UIImage *)image photoUrl:(NSString *)photoUrl;
- (instancetype)initWithImageView:(UIImageView *)imageView placeHold:(UIImage *)image photoUrl:(NSString *)photoUrl;


/**
 *  显示网络图片
 */
@property (nonatomic, copy)   NSString *photoUrl;
/**
 *  可以看作是placeHolder image，和imageView.image等价，可以去掉
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  显示图片的View，可以为空
 */
@property (nonatomic, strong)  UIImageView *imageView;

@end
