//
//  LLPhotoItem.m
//  LLPhotoBrowser
//
//  Created by LianLeven on 2017/12/26.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import "LLPhotoItem.h"

@interface LLPhotoItem()<NSCopying>

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;

@end

@implementation LLPhotoItem

+ (instancetype)photoItemWithThumbView:(UIView *)thumbView largeImageSize:(CGSize)largeImageSize imageURL:(NSURL *)imageURL;{
    LLPhotoItem *item = [LLPhotoItem new];
    item.thumbView = thumbView;
    item.largeImageURL = imageURL;
    item.largeImageSize = largeImageSize;
    return item;
}

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.width < 1 || view.height < 1) return NO;
    return imageSize.height / imageSize.width > view.width / view.height;
}

- (id)copyWithZone:(NSZone *)zone {
    LLPhotoItem *item = [self.class new];
    return item;
}

@end
