//
//  LYPhotoBrowser.h
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/13.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYPhoto.h"

typedef NS_ENUM(NSUInteger, LYPhotoBrowserCountType){
    LYPhotoBrowserCountTypeNone        = 0,
    LYPhotoBrowserCountTypePageControl = 1,/**< 显示PageControl */
    LYPhotoBrowserCountTypeCountLabel  = 2,/**< 显示计数Label */
};
@interface LYPhotoBrowser : UIView

+ (LYPhotoBrowser *)showPhotos:(NSArray *)photos currentPhotoIndex:(NSInteger)currentIndex countType:(LYPhotoBrowserCountType)countType;

- (void)showPhotos:(NSArray *)photos currentPhotoIndex:(NSInteger)currentPhotoIndex countType:(LYPhotoBrowserCountType)countType;
@end
