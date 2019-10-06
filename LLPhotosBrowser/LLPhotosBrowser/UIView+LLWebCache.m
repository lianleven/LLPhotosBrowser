//
//  UIView+LLWebCache.m
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import "UIView+LLWebCache.h"
#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import "UIButton+WebCache.h"
#import "UIView+WebCache.h"
#import "NSData+ImageContentType.h"
@implementation UIView (LLWebCache)
- (void)ll_setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder{
    
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        [imageView sd_setImageWithURL:imageURL placeholderImage:placeholder];
    }else if ([self isKindOfClass:UIButton.class]){
        UIButton *button = (UIButton *)self;
        [button sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:placeholder];
    }
}
- (void)ll_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                completion:(SDExternalCompletionBlock)completion{
    [self ll_setImageWithURL:imageURL placeholder:placeholder options:options progress:nil completion:completion];
}
- (void)ll_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   progress:(SDImageLoaderProgressBlock)progressBlock
                completion:(SDExternalCompletionBlock)completion{
    [self ll_setImageWithURL:imageURL placeholder:placeholder options:0 progress:progressBlock completion:completion];
}
- (void)ll_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(SDImageLoaderProgressBlock)progressBlock
                completion:(SDExternalCompletionBlock)completion{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        [imageView sd_setImageWithURL:imageURL placeholderImage:placeholder options:options progress:progressBlock completed:completion];
    }else if ([self isKindOfClass:[UIButton class]]){
        UIButton *button = (UIButton *)self;
        [button sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:placeholder options:options completed:completion];
    }
}

+ (void)ll_requestImageWithURL:(NSURL *)imageURL{
    if (!imageURL) return;
    [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
}
+ (void)ll_downloadImageWithURL:(NSURL *)imageURL
                       progress:(SDImageLoaderProgressBlock)progressBlock
                      completed:(SDInternalCompletionBlock)completedBlock;{
    [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:SDWebImageRetryFailed progress:progressBlock completed:completedBlock];
}

- (void)ll_cancelCurrentImageLoad{
    [self sd_cancelCurrentImageLoad];
}

- (NSURL *)ll_imageURL;{
    return [self sd_imageURL];
}
+ (void)imageCacheWithURL:(NSURL *)imageURL completed:(SDImageCacheQueryCompletionBlock)completed{
    if (!imageURL) return;
    NSString *URLString = imageURL.absoluteString;
    NSURL *url = [NSURL URLWithString:URLString];
    if (!url) return;
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    [[SDWebImageManager sharedManager].imageCache queryImageForKey:key options:SDWebImageRetryFailed context:nil completion:completed];
}
+ (void)removeAllCacheImage;{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}
+ (void)removeImageForKey:(NSString *)key{
    if (!key || ![key isKindOfClass:[NSString class]]) return;
    [[[SDWebImageManager sharedManager] imageCache]removeImageForKey:key cacheType:SDImageCacheTypeAll completion:nil];
}

+ (void)ll_setImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key{
    if (!key || (image == nil && imageData.length == 0)) return;
    [[[SDWebImageManager sharedManager] imageCache] storeImage:image imageData:imageData forKey:key cacheType:SDImageCacheTypeAll completion:nil];
    
}

+ (LLImageFormat)ll_imageFormatForImageData:(nullable NSData *)data;{
    return (LLImageFormat)[NSData sd_imageFormatForImageData:data];
}


@end
