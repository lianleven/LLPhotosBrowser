//
//  LLPageControl.h
//  LLPhotoBrowser
//
//  Created by LianLeven on 2018/1/31.
//  Copyright © 2018年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LLPageControlTypeDefault,// if numberOfPages > pageTypeDefaultNumber is LLPageControlTypeNumber else LLPageControlTypeSystem
    LLPageControlTypeNumber, // such as 1/20
    LLPageControlTypeSystem, 
} LLPageControlType;

@interface LLPageControl : UIView

@property (nonatomic, strong, readonly) UIPageControl *pager;
@property (nonatomic, strong, readonly) UILabel *pagerLabel;

@property(nonatomic) NSInteger pageTypeDefaultNumber;          // default is 15.
@property(nonatomic) LLPageControlType pageType;          // default is LLPageControlTypeDefault.
@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property(nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@end
