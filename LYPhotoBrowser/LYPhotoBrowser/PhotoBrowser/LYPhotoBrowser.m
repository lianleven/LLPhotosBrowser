//
//  LYPhotoBrowser.m
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/13.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "LYPhotoBrowser.h"
#import "LYZoomingImageView.h"
@interface LYPhotoBrowser()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSInteger currentPage;/**< 当前索引 */


@property (nonatomic, strong) UIScrollView  *browserScrollView;
@property (nonatomic, strong) UIPageControl *pageController;
@property (nonatomic, strong) UILabel *countLabel;/**< 计数label */
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UILabel *maskViewLabel;


@property (nonatomic) BOOL isScroll;

@end

@implementation LYPhotoBrowser


#pragma mark - public method

+ (LYPhotoBrowser *)showPhotos:(NSArray *)photos currentPhotoIndex:(NSInteger)currentIndex countType:(LYPhotoBrowserCountType)countType{
    LYPhotoBrowser *photoBrowser = [[LYPhotoBrowser alloc] init];
    [photoBrowser showPhotos:photos currentPhotoIndex:currentIndex countType:countType];
    return photoBrowser;
}
- (void)showPhotos:(NSArray *)photos currentPhotoIndex:(NSInteger)currentPhotoIndex countType:(LYPhotoBrowserCountType)countType{
    self.photos = photos.copy;
    self.currentPage = currentPhotoIndex;
    if (photos.count > 1) {
        self.pageController.numberOfPages = photos.count;
        self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(currentPhotoIndex + 1),@(photos.count)];
    }else{
        self.browserScrollView.scrollEnabled = NO;
    }
    switch (countType) {
        case LYPhotoBrowserCountTypeNone: {
            self.countLabel.hidden = YES;
            self.pageController.hidden = YES;
            break;
        }
        case LYPhotoBrowserCountTypePageControl: {
            self.countLabel.hidden = YES;
            break;
        }
        case LYPhotoBrowserCountTypeCountLabel: {
            self.pageController.hidden = YES;
            break;
        }
        default: {
            self.countLabel.hidden = YES;
            break;
        }
    }
    [self photoBrowserDidShowCurrentImage];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    for (UIView *view in self.browserScrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.frame = CGRectMake(imageView.tag * width, 0, width, height);
        }
    }
    self.browserScrollView.contentSize = CGSizeMake(width * 3, height);
    self.browserScrollView.contentOffset = CGPointMake(width, 0);
    
    
}
- (void)setup{
    
    self.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0;
    self.isScroll = NO;
    self.currentPage = 0; //设置默认值
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    
    [self addSubview:self.browserScrollView];
    [self addSubview:self.pageController];
    [self addSubview:self.countLabel];
    [self reUseZoomingImageView];
    [self addSubview:self.saveButton];
    [self addSubview:self.maskViewLabel];
    
    [self setFrameForSubViews];
    
}
- (void)setFrameForSubViews{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_browserScrollView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_browserScrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_browserScrollView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_browserScrollView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_pageController]-60-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_pageController)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageController]-8-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_pageController)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_countLabel]-60-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_countLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_countLabel(==40)]-8-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_countLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_saveButton(==40)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_saveButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_saveButton(==30)]-15-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_saveButton)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_maskViewLabel(==100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_maskViewLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_maskViewLabel(==40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_maskViewLabel)]];
    
    //垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_maskViewLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_maskViewLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isScroll = YES;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for (UIView *view in self.browserScrollView.subviews) {
        if ([view isKindOfClass:[LYZoomingImageView class]]) {
            
            LYZoomingImageView *imageView = (LYZoomingImageView *)view;
            imageView.zoomScale = imageView.minimumZoomScale;
            imageView.contentOffset = CGPointZero;
            
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.pageController.currentPage = [self pageIndexForZoomImageWillBeginShowWithCurrentPage:self.currentPage];
    self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.pageController.currentPage + 1),@(self.photos.count)];
    if (scrollView.contentOffset.x >= 2 * CGRectGetWidth(scrollView.frame)) {
        self.currentPage = [self pageIndexForZoomImageWillBeginShowWithCurrentPage:self.currentPage + 1];
        [self photoBrowserDidShowCurrentImage];
        
    }
    if (scrollView.contentOffset.x <= 0)
    {
        self.currentPage = [self pageIndexForZoomImageWillBeginShowWithCurrentPage:self.currentPage - 1];
        [self photoBrowserDidShowCurrentImage];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScroll = NO;
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.browserScrollView.frame), 0)];
}
#pragma mark - private Action
/**
 *  显示当前的image
 */
-(void)photoBrowserDidShowCurrentImage
{
    if (!self.photos.count>0) return;
    
    for (UIView *view in self.browserScrollView.subviews) {
        if ([view isKindOfClass:[LYZoomingImageView class]]) {
            LYZoomingImageView *imageView = (LYZoomingImageView *)view;
            NSInteger index = [self pageIndexForZoomImageDidEndShowWithZoomImageTag:imageView.tag];
            imageView.isScroll = self.isScroll;
            
            imageView.photo = self.photos[index];
        }
    }
    
    [self.browserScrollView setContentOffset:CGPointMake(self.browserScrollView.frame.size.width, 0)];
}

- (NSInteger)pageIndexForZoomImageDidEndShowWithZoomImageTag:(NSInteger)zoomImageTag{
    NSInteger index = [self pageIndexForZoomImageWillBeginShowWithCurrentPage:self.currentPage + (zoomImageTag - 1)];
    return index;
}
/**
 *  根据当前索引，获得将要显示的zoomImage的索引,循环滚动
 */
- (NSInteger)pageIndexForZoomImageWillBeginShowWithCurrentPage:(NSInteger)CurrentPage{
    NSInteger index = 0;
    NSInteger imageCount = self.photos.count;
    if (CurrentPage == -1) {
        index = imageCount - 1;
    }else if (CurrentPage == imageCount){
        index = 0;
    }else{
        index = CurrentPage;
    }
    return index;
}
- (void)saveCurrentImage:(UIButton *)sender{
    [self saveImage];
}
- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LYPhoto *photo = _photos[self.currentPage];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        [self showCompletedMaskWithText:@"保存失败"];
    } else {
        [self showCompletedMaskWithText:@"保存成功"];
    }
}
- (void)showCompletedMaskWithText:(NSString *)text{
    self.maskViewLabel.text = text;
    [UIView animateWithDuration:.8 animations:^{
        self.maskViewLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.maskViewLabel.alpha = 0;
    }];
}
#pragma mark - setter/getter
- (UIScrollView *)browserScrollView{
    if (!_browserScrollView) {
        _browserScrollView = [[UIScrollView alloc] init];
        _browserScrollView.showsHorizontalScrollIndicator = NO;
        _browserScrollView.showsVerticalScrollIndicator = NO;
        _browserScrollView.directionalLockEnabled = YES;
        _browserScrollView.pagingEnabled = YES;
        _browserScrollView.delegate = self;
        _browserScrollView.backgroundColor = [UIColor clearColor];
        _browserScrollView.contentOffset  = CGPointMake(0, 0);
        _browserScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _browserScrollView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _browserScrollView;
}
- (UIPageControl *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageControl alloc] init];
        _pageController.currentPage = 0;
        _pageController.backgroundColor = [UIColor clearColor];
        _pageController.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageController.translatesAutoresizingMaskIntoConstraints = NO;
        _pageController.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return  _pageController;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _countLabel.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _countLabel;
}
- (UIButton *)saveButton{
    if (!_saveButton) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _saveButton.layer.cornerRadius = 4;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _saveButton.layer.borderWidth = 1;
        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_saveButton addTarget:self action:@selector(saveCurrentImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (UILabel *)maskViewLabel{
    if (!_maskViewLabel) {
        _maskViewLabel = [[UILabel alloc] init];
        
        _maskViewLabel.font = [UIFont systemFontOfSize:16];
        _maskViewLabel.textColor = [UIColor whiteColor];
        _maskViewLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _maskViewLabel.layer.cornerRadius = 4;
        _maskViewLabel.layer.masksToBounds = YES;
        _maskViewLabel.textAlignment = NSTextAlignmentCenter;
        _maskViewLabel.alpha = 0;
        _maskViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
       
    }
    return _maskViewLabel;
}
/**
 *  创建三个可重用的缩放对象
 */
- (void)reUseZoomingImageView{
    for (int i = 0; i<3; i++) {
        LYZoomingImageView *imageView = [[LYZoomingImageView alloc]init];
        imageView.tag = i;
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        imageView.frame = CGRectMake(i * width, 0, width, height);
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = self.backgroundColor;
        _countLabel.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.browserScrollView addSubview:imageView];
    }
}
@end
