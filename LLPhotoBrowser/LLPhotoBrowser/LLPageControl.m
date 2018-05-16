//
//  LLPageControl.m
//  LLPhotosBrowser
//
//  Created by LianLeven on 2018/1/31.
//  Copyright © 2018年 LianLeven. All rights reserved.
//

#import "LLPageControl.h"
#import "UIView+LLAdd.h"

@interface LLPageControl ()

@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, strong) UILabel *pagerLabel;

@end

@implementation LLPageControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self addSubview:self.pager];
        [self addSubview:self.pagerLabel];
        
        _pageTypeDefaultNumber = 15;
        _pageType = LLPageControlTypeDefault;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.pager.frame = self.bounds;
    self.pagerLabel.frame = self.bounds;
}
- (void)setPagerCurrentNumber{
    self.pagerLabel.text = [NSString stringWithFormat:@"%zd/%zd",(self.currentPage+1),self.numberOfPages];
}

#pragma mark - Getters and Setters
- (void)setPageTypeDefaultNumber:(NSInteger)pageTypeDefaultNumber{
    _pageTypeDefaultNumber = pageTypeDefaultNumber;
    [self setPageType:_pageType];
}
- (void)setPageType:(LLPageControlType)pageType{
    _pageType = pageType;
    BOOL isNumberType = NO;
    if (pageType == LLPageControlTypeDefault) {
        isNumberType = (_numberOfPages > _pageTypeDefaultNumber);
    }else if (pageType == LLPageControlTypeNumber){
        isNumberType = YES;
    }else{
        isNumberType = NO;
    }
    self.pager.hidden = isNumberType;
    self.pagerLabel.hidden = !isNumberType;
}
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    self.pager.numberOfPages = numberOfPages;
    [self setPagerCurrentNumber];
    [self setPageType:_pageType];
}
- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    self.pager.currentPage = currentPage;
    [self setPagerCurrentNumber];
}
- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    _hidesForSinglePage = hidesForSinglePage;
    self.pager.hidesForSinglePage = hidesForSinglePage;
}

- (UIPageControl *)pager{
    if (!_pager) {
        _pager = [[UIPageControl alloc] init];
        _pager.hidesForSinglePage = YES;
        _pager.userInteractionEnabled = NO;
        _pager.frame = self.bounds;
        _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _pager;
}
- (UILabel *)pagerLabel{
    if (!_pagerLabel) {
        _pagerLabel = [UILabel new];
        _pagerLabel.textColor = [UIColor whiteColor];
        _pagerLabel.textAlignment = NSTextAlignmentCenter;
        _pagerLabel.font = [UIFont systemFontOfSize:12];
    }
    return _pagerLabel;
}
@end
