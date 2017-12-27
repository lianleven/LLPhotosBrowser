//
//  LLPhotoItem.h
//  LLPhotoBrowser
//
//  Created by LianLeven on 2017/12/26.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCategories.h"
@import UIKit;
@interface LLPhotoItem : NSObject

@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;

@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;

+ (instancetype)photoItemWithThumbView:(UIView *)thumbView largeImageSize:(CGSize)largeImageSize imageURL:(NSURL *)imageURL;

@end
