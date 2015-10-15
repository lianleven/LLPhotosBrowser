//
//  LYSofaProviderCollectionView.m
//  LYTravellerPro
//
//  Created by LianLeven on 15/9/28.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "LYCommonCollectionView.h"
#import "LYCommonCollectionCell.h"
#import "LYPhotoBrowser.h"

@interface LYCommonCollectionView()

@end
@implementation LYCommonCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // init by storyboard or xib
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    self.column = 3;
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerNib:[UINib nibWithNibName:@"LYCommonCollectionCell" bundle:nil]
     forCellWithReuseIdentifier:@"LYCommonCollectionIdentifier"];
    LYCommonCollectionCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYCommonCollectionIdentifier"
                                                                                          forIndexPath:indexPath];
    imageCell.indexPath = indexPath;
    return imageCell;
}

#pragma mark - UICollectionView Delegate
static const CGFloat lYItemMargin = 10;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(lYItemMargin, lYItemMargin, lYItemMargin, lYItemMargin);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return lYItemMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return lYItemMargin;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    
    //一行显示n个item
    CGFloat kItem_width_height = ((width - (self.column + 1) * 10) * 1.0 - 1)/self.column;
    return CGSizeMake(kItem_width_height, kItem_width_height);
}

/**
 *  数据处理应该用代理或者block传给controller
 *
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //LYCommonCollectionCell *cell = (LYCommonCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *imageViews = [NSMutableArray array];
    
    NSArray *visibleCells = [collectionView visibleCells];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"indexPath" ascending:YES];
    visibleCells = [visibleCells sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSInteger first_index_path_row = [[collectionView indexPathForCell:[visibleCells firstObject]] row];
    
    LYPhoto *photo;
    //添加imageView的目的是从哪来，回哪去，如果不添加默认从屏幕中show和hide
    for (NSInteger i = 0; i < self.collectionDataSource.count; i++) {
        if ((i - first_index_path_row) >= first_index_path_row && (i - first_index_path_row) < visibleCells.count) {//有可用cell
            LYCommonCollectionCell *cell = visibleCells[i - first_index_path_row];
            photo = [LYPhoto photoWithImageView:cell.imageView placeHold:cell.imageView.image photoUrl:self.collectionDataSource[i]];
            [imageViews addObject:photo];
            
        }else{//无可用cell
            photo = [LYPhoto photoWithImageView:nil placeHold:[UIImage imageNamed:@"placeholder"] photoUrl:self.collectionDataSource[i]];
            [imageViews addObject:photo];
        }
    }
    
    [LYPhotoBrowser showPhotos:imageViews currentPhotoIndex:indexPath.row countType:LYPhotoBrowserCountTypeCountLabel];
    
    
    
}
#pragma mark - getter/setter
- (void)setCollectionDataSource:(NSArray *)collectionDataSource{
    _collectionDataSource = collectionDataSource;
    [self reloadData];
}
- (void)setColumn:(NSInteger)column{
    _column = column;
    [self reloadData];
}
@end
