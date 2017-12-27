//
//  UIView+LLWebCache.h
//  LLPhotoBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIView (LLWebCache)


- (void)ll_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;
- (void)ll_setImageWithURL:(NSURL *)imageURL
placeholder:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                completion:(SDExternalCompletionBlock)completion;
- (void)ll_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                completion:(SDExternalCompletionBlock)completion;
+ (void)ll_requestImageWithURL:(NSURL *)imageURL;
- (void)ll_cancelCurrentImageLoad;


- (NSURL *)ll_imageURL;
// cache
+ (UIImage *)imageCacheWithURL:(NSURL *)imageURL;
+ (void)removeImageForKey:(NSString *)key;
+ (void)removeAllCacheImage;
+ (void)ll_setImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key;

@end

