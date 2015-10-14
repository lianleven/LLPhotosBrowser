//
//  LYPhoto.m
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/14.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "LYPhoto.h"

@implementation LYPhoto

+ (instancetype)photoWithImageView:(UIImageView *)imageView placeHold:(UIImage *)image photoUrl:(NSString *)photoUrl{
    LYPhoto *photo = [[LYPhoto alloc] initWithImageView:imageView placeHold:image photoUrl:photoUrl];
    return photo;
}

- (instancetype)initWithImageView:(UIImageView *)imageView placeHold:(UIImage *)image photoUrl:(NSString *)photoUrl{
    self = super.init;
    if (self) {
        _imageView = imageView;
        _image = image;
        _photoUrl = photoUrl;
    }
    return self;
}
@end
