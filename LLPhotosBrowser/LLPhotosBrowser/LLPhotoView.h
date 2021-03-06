//
//  LLPhotoView.h
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPhotoItem.h"
#import "UIView+LLWebCache.h"
NS_ASSUME_NONNULL_BEGIN
@interface LLPhotoView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) LLPhotoItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;

@end
NS_ASSUME_NONNULL_END
