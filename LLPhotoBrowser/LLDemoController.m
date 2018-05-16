//
//  LLDemoController.m
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/27.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import "LLDemoController.h"
#import "UIView+LLWebCache.h"
#import "FLAnimatedImage.h"
#import "LLPhotosBrowser.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)
#define kiOS7Later ([UIDevice currentDevice].systemVersion.doubleValue > 7.0)
#define kiOS8Later ([UIDevice currentDevice].systemVersion.doubleValue > 8.0)
@class LLDemoControllerCell;
typedef void(^LLDemoControllerCellDidSelectedBlcok)(LLDemoControllerCell *cell);
@interface LLDemoControllerCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, strong) FLAnimatedImageView *webImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) LLDemoControllerCellDidSelectedBlcok didSelectedBlock;
@end

@implementation LLDemoControllerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.size = CGSizeMake(kScreenWidth, kCellHeight);
    self.contentView.size = self.size;
    _webImageView = [FLAnimatedImageView new];
    _webImageView.size = self.size;
    _webImageView.clipsToBounds = YES;
    _webImageView.contentMode = UIViewContentModeScaleAspectFill;
    _webImageView.backgroundColor = [UIColor whiteColor];
    _webImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_webImageView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = CGPointMake(self.width / 2, self.height / 2);
    _indicator.hidden = YES;
    //[self.contentView addSubview:_indicator]; //use progress bar instead..
    
    _button = [UIButton new];
    _button.size = self.size;
    [_button setTitle:@"Load fail, tap to reload." forState:0];
    [_button setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.0] forState:0];
    _button.hidden = YES;
    _button.userInteractionEnabled = YES;
    _button.restorationIdentifier = [[_webImageView ll_imageURL] absoluteString];
    [_button addTarget:self action:@selector(setImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
    
    CGFloat lineHeight = 4;
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(_webImageView.width, lineHeight);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _progressLayer.height / 2)];
    [path addLineToPoint:CGPointMake(_webImageView.width, _progressLayer.height / 2)];
    _progressLayer.lineWidth = lineHeight;
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeColor = [UIColor colorWithRed:0.000 green:0.640 blue:1.000 alpha:0.720].CGColor;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    [_webImageView.layer addSublayer:_progressLayer];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_webImageView addGestureRecognizer:g];
    
    return self;
}
- (void)tapAction{
    if (self.didSelectedBlock) {
        self.didSelectedBlock(self);
    }
}
- (void)setImageButtonAction:(UIButton *)button {
    NSURL *url = [NSURL URLWithString:button.restorationIdentifier];
    [self setImageURL:url];
}
- (void)setImageURL:(NSURL *)url{
    _button.hidden = YES;
    _indicator.hidden = NO;
    [_indicator startAnimating];
    __weak typeof(self) _self = self;
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.progressLayer.hidden = YES;
    self.progressLayer.strokeEnd = 0;
    [CATransaction commit];
    [_webImageView ll_setImageWithURL:url placeholder:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (expectedSize > 0 && receivedSize > 0) {
            CGFloat progress = (CGFloat)receivedSize / expectedSize;
            progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
            if (_self.progressLayer.hidden) _self.progressLayer.hidden = NO;
            _self.progressLayer.strokeEnd = progress;
        }
    } completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _self.progressLayer.hidden = YES;
        [_self.indicator stopAnimating];
        _self.indicator.hidden = YES;
        if (!image) _self.button.hidden = NO;
    }];
}
@end

@interface LLDemoController ()

@end

@implementation LLDemoController
{
    NSArray *_imageLinks;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = button;
    self.view.backgroundColor = [UIColor colorWithWhite:0.217 alpha:1.000];
    
    NSArray *links = @[
                       
                       // animated gif: http://cinemagraphs.com/
                       @"http://i.imgur.com/uoBwCLj.gif",
                       @"http://i.imgur.com/8KHKhxI.gif",
                       @"http://i.imgur.com/WXJaqof.gif",
                       
                       // animated gif: https://dribbble.com/markpear
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
                       
                       // animaged gif: https://dribbble.com/jonadinges
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
                       
                       // jpg: https://dribbble.com/snootyfox
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
                       
                       // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
                       @"http://littlesvr.ca/apng/images/BladeRunner.png",
                       @"http://littlesvr.ca/apng/images/Contact.webp",
                       ];
    
    _imageLinks = links;
    [self.tableView reloadData];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (kiOS7Later) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (kiOS7Later) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.tintColor = nil;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)reload {
    [UIView removeAllCacheImage];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageLinks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLDemoControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[LLDemoControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setImageURL:[NSURL URLWithString:_imageLinks[indexPath.row % _imageLinks.count]]];
    __weak typeof(self) _self = self;
    cell.didSelectedBlock = ^(LLDemoControllerCell *cell) {
        [_self tableView:tableView didSelectCell:cell];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectCell:(LLDemoControllerCell *)cell{
    UIView *fromView = cell.webImageView;
    NSMutableArray *items = [NSMutableArray new];
    for (NSInteger i = 0,max = _imageLinks.count;i < max;i++) {
        LLDemoControllerCell *ce = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIView *view = ce.webImageView;
        LLPhotoItem *item = [LLPhotoItem photoItemWithThumbView:view
                                                       imageURL:[NSURL URLWithString:_imageLinks[i % _imageLinks.count]]];
        
       
        [items addObject:item];
    }
    
    LLPhotosBrowser *v = [[LLPhotosBrowser alloc] initWithPhotoItems:items];
//    v.pager.pageType = LLPageControlTypeSystem;
    v.pager.pageType = LLPageControlTypeNumber;
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
    for (LLDemoControllerCell *cell in [self.tableView visibleCells]) {
        CGFloat y = cell.centerY - scrollView.contentOffset.y;
        CGFloat p = y - viewHeight / 2;
        CGFloat scale = cos(p / viewHeight * 0.8) * 0.95;
        if (kiOS8Later) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                cell.webImageView.transform = CGAffineTransformMakeScale(scale, scale);
            } completion:NULL];
        } else {
            cell.webImageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

@end
