//
//  UIView+LLWebCache.h
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

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


- (void)ll_setImageWithURL:(NSURL *_Nullable)imageURL placeholder:(UIImage *_Nullable)placeholder;
- (void)ll_setImageWithURL:(NSURL *_Nullable)imageURL
               placeholder:(UIImage *_Nullable)placeholder
                   options:(SDWebImageOptions)options
                completion:(SDExternalCompletionBlock _Nullable )completion;
- (void)ll_setImageWithURL:(NSURL *_Nullable)imageURL placeholder:(UIImage *_Nullable)placeholder progress:(SDImageLoaderProgressBlock _Nullable )progressBlock completion:(SDExternalCompletionBlock _Nullable )completion;
+ (void)ll_requestImageWithURL:(NSURL *_Nullable)imageURL;
- (void)ll_cancelCurrentImageLoad;


- (NSURL *_Nullable)ll_imageURL;
// cache
+ (void)imageCacheWithURL:(NSURL *_Nullable)imageURL completed:(SDImageCacheQueryCompletionBlock _Nullable )completed;
+ (void)removeImageForKey:(NSString *_Nullable)key;
+ (void)removeAllCacheImage;
+ (void)ll_setImage:(UIImage *_Nullable)image imageData:(NSData *_Nullable)imageData forKey:(NSString *_Nullable)key;


+ (LLImageFormat)ll_imageFormatForImageData:(nullable NSData *)data;
@end

