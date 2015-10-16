//
//  LYZoomingImageView.m
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/13.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "LYZoomingImageView.h"
#import "UIImageView+WebCache.h"
#import "MCPercentageDoughnutView.h"

@interface LYZoomingImageView()<UIScrollViewDelegate>

@property (assign, nonatomic) CGRect originalZoomScaleFrame;/**< 缩放前的frame */
@property (nonatomic, strong) UIImageView *zoomImageView;/**< 缩放的imageView */
@property (nonatomic, strong) UIImage *image;/**< 缩放imageView的image对象 */
@property (nonatomic, strong) UIImageView *imageView;

@property (strong, nonatomic) MCPercentageDoughnutView *percentageDoughnut;/**< 进度View */

@end
@implementation LYZoomingImageView
#pragma mark - life
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.minimumZoomScale = 1.0;
    
    //点击事件
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapAction:)];
    sigleTap.numberOfTouchesRequired = 1;
    sigleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:sigleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [sigleTap requireGestureRecognizerToFail:doubleTap];
    
    
    [self addSubview:self.zoomImageView];
    [self addSubview:self.percentageDoughnut];
}
#pragma mark - UIScrollViewDelegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect zoomImageFrame = self.zoomImageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    if (zoomImageFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    if (zoomImageFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    self.zoomImageView.center = centerPoint;
}
#pragma mark - UIGestureRecognizer Action
- (void)sigleTapAction:(UIGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.4 animations:^{
        [self resetZoom];
        self.superview.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview.superview removeFromSuperview];
    }];
}
- (void)doubleTapAction:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.zoomImageView];
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        //恢复
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        // 放大
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2.0);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
    }
    
}
#pragma mark - Action
- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (self.zoomImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = self.zoomImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}
- (void)setFrameToZoomImageView:(CGRect)rect
{
    self.zoomImageView.frame = rect;
    self.originalZoomScaleFrame = rect;
}
- (void)resetZoom
{
    self.zoomScale = self.minimumZoomScale;
    self.zoomImageView.frame = self.originalZoomScaleFrame;
}

- (void)showProgressView:(id)sender{
    CGFloat progress = (sender)?[sender floatValue]:0;
    self.percentageDoughnut.percentage = progress;
    self.percentageDoughnut.hidden = NO;
}
- (void)hideProgressView{
    self.percentageDoughnut.hidden = YES;
}
- (UIImage *)imageDidEndDownloadForKey:(NSString *)key{
    UIImage *image = nil;
    image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if (!image) {
       image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    }
   
    return image;
}
#pragma mark - setter/getter
- (void)setPhoto:(LYPhoto *)photo{
    _photo = photo;
    self.imageView = photo.imageView;
}
- (void)setImageView:(UIImageView *)imageView{
    _imageView = imageView;
    UIView *superView = self.superview.superview.superview;
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.superview.superview.superview];
    self.image = imageView.image;
    if (!_photo.image) {
        _photo.image = imageView.image;
    }
    if (!imageView) {
        
        CGRect frame = CGRectMake((CGRectGetWidth(superView.bounds) - 100)/2, (CGRectGetHeight(superView.bounds) - 100)/2, 100, 100);
        convertRect = [superView convertRect:frame toView:superView];
        self.image = _photo.image;
    }
    [self setFrameToZoomImageView:convertRect];
    UIImage *cacheImage = [self imageDidEndDownloadForKey:_photo.photoUrl];
    if (cacheImage) {
        self.image = cacheImage;
        _photo.image = cacheImage;
        return;
    }
    
    
    [self.zoomImageView sd_setImageWithURL:[NSURL URLWithString:_photo.photoUrl] placeholderImage:imageView.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSString *progress = [NSString stringWithFormat:@"%.2f",receivedSize * 1.0/expectedSize];
        [self performSelectorOnMainThread:@selector(showProgressView:) withObject:progress waitUntilDone:NO];
        //self.percentageDoughnut.percentage = receivedSize/expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self hideProgressView];
        if (image){
            self.image = image;
            _photo.image = image;
            self.isScroll = YES;
        }
        else{
            //TODO: 下载失败，view提示
            self.image = imageView.image;
            if (!imageView) {
                self.image = _photo.image;
            }
        }
        
    
        
    }];
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.zoomImageView.image = image;
    
    if (image)
    {
        CGSize imgSize = image.size;
        //判断缩放的值
        float scaleX = self.frame.size.width/imgSize.width;
        float scaleY = self.frame.size.height/imgSize.height;
        CGRect zoomImageViewOriginalFrame = CGRectZero;
        if (scaleX > scaleY){//以Y轴适应
            float imgViewWidth = imgSize.width*scaleY;
            self.maximumZoomScale = self.frame.size.width/imgViewWidth;
            
            zoomImageViewOriginalFrame = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        }
        else{//以X轴适应
            float imgViewHeight = imgSize.height*scaleX;
            self.maximumZoomScale = self.frame.size.height/imgViewHeight;
            
            zoomImageViewOriginalFrame = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        }
        if (!self.isScroll){//开始显示
            [UIView animateWithDuration:.4 animations:^{
                self.superview.superview.alpha = 1.0;
                self.zoomImageView.frame = zoomImageViewOriginalFrame;
            }];
        }else{//滑动显示
            self.zoomImageView.frame = zoomImageViewOriginalFrame;
        }
        self.percentageDoughnut.frame = CGRectMake((self.frame.size.width - 60)/2, (self.frame.size.height - 60)/2, 60, 60);
        
    }
}
- (UIImageView *)zoomImageView{
    if (!_zoomImageView) {
        _zoomImageView = [[UIImageView alloc] init];
        _zoomImageView.clipsToBounds = YES;
        _zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zoomImageView;
}
- (MCPercentageDoughnutView *)percentageDoughnut{
    if (!_percentageDoughnut) {
        _percentageDoughnut = [[MCPercentageDoughnutView alloc] init];
        _percentageDoughnut.percentage              = 0.5;
        _percentageDoughnut.linePercentage          = 0.15;
        _percentageDoughnut.animationDuration       = 2;
        _percentageDoughnut.decimalPlaces           = 1;
        _percentageDoughnut.showTextLabel           = YES;
        _percentageDoughnut.animatesBegining        = NO;
        _percentageDoughnut.fillColor               = [UIColor orangeColor];
        _percentageDoughnut.unfillColor             = [MCUtil iOS7DefaultGrayColorForBackground];
        _percentageDoughnut.textLabel.textColor     = [UIColor whiteColor];
        _percentageDoughnut.textLabel.font          = [UIFont systemFontOfSize:25];
        _percentageDoughnut.gradientColor1          = [UIColor greenColor];
        _percentageDoughnut.gradientColor2          = [MCUtil iOS7DefaultGrayColorForBackground];
        _percentageDoughnut.hidden = YES;
        _percentageDoughnut.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _percentageDoughnut;
}
@end
