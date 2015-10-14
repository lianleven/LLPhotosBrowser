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
    }
    switch (countType) {
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
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_browserScrollView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_browserScrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_browserScrollView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_browserScrollView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_pageController]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_pageController)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageController]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_pageController)]];
    
    self.countLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame), 30);
    
    
}

#pragma mark - private
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
        
    }
    return _countLabel;
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
        [self.browserScrollView addSubview:imageView];
    }
}
@end
