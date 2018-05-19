//
//  UIView+LLWebCache.h
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, LLImageFormat) {
    LLImageFormatUndefined = -1,
    LLImageFormatJPEG = 0,
    LLImageFormatPNG,
    LLImageFormatGIF,
    LLImageFormatTIFF,
    LLImageFormatWebP,
    LLImageFormatHEIC
};
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


+ (LLImageFormat)ll_imageFormatForImageData:(nullable NSData *)data;
@end

