//
//  LYSofaProviderCollectionCell.h
//  LYTravellerPro
//
//  Created by LianLeven on 15/9/28.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCommonCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  这里是为了排序
 */
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
