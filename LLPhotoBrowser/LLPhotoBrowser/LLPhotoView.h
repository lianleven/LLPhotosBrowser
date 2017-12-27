//
//  LLPhotoView.h
//  LLPhotoBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPhotoItem.h"
#import "UIView+LLWebCache.h"
#import "YYImage.h"
#import "FLAnimatedImage.h"
@interface LLPhotoView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong)  FLAnimatedImageView*imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) LLPhotoItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;

@end
