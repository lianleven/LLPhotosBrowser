//
//  LLPhotoItem.h
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/26.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+LLAdd.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LLPhotoItem : NSObject

@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, strong) NSURL *largeImageURL;

@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;

+ (instancetype)photoItemWithThumbView:(UIView *)thumbView imageURL:(NSURL *)imageURL;

@end
NS_ASSUME_NONNULL_END
