//
//  LYSofaProviderCollectionView.h
//  LYTravellerPro
//
//  Created by LianLeven on 15/9/28.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LYCommonCollectionView : UICollectionView<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *collectionDataSource;/**< 数据源 */
@property (nonatomic, assign) NSInteger column;/**< 列数 */
@end
