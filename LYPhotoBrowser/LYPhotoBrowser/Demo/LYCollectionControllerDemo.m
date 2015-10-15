//
//  LYCollectionControllerDemo.m
//  LYPhotoBrowser
//
//  Created by LianLeven on 15/10/15.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "LYCollectionControllerDemo.h"
#import "LYCommonCollectionView.h"
@interface LYCollectionControllerDemo ()

@property (weak, nonatomic) IBOutlet LYCommonCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;


@end

@implementation LYCollectionControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segmentView.selectedSegmentIndex = 1;
    self.collectionView.collectionDataSource = [self dataSource];
}
- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.collectionView.column = 2;
            break;
        }
        case 1:{
            self.collectionView.column = 3;
            break;
        }
        case 2:{
            self.collectionView.column = 4;
            break;
        }
            
        default:
            break;
    }
}


- (NSArray *)dataSource{
    NSArray *imageUrlArray = @[
                               @"http://img5.duitang.com/uploads/item/201509/23/20150923134837_hBV5t.jpeg",
                               @"http://img4.cache.netease.com/photo/0003/2015-09-17/B3N1RCK000AJ0003.jpg",
                               @"http://img.sc115.com/hb/yl1/15/881509521537319.jpg",
                               @"http://pic16.nipic.com/20111002/8445207_103736479150_2.jpg",
                               
                               @"http://cdn.duitang.com/uploads/item/201509/01/20150901094009_dvY4n.jpeg",
                               
                               @"http://d02.res.meilishuo.net/picdetail/a/01/9d/a38e2e65392ca58b8223eda93938_600_886_2_1.ca.jpeg",
                               
                               @"http://img5.duitang.com/uploads/item/201408/17/20140817003216_zaSjR.thumb.700_0.jpeg",
                               @"http://news.xinhuanet.com/fashion/2015-09/18/128236151_14423947201391n.jpg",
                               @"http://upload.cebnet.com.cn/2014/1217/1418776413348.jpg",
                               @"http://www.tangedu.cn/data/attachment/portal/201509/09/211725w040c4o00e6d0yp3.jpg",
                               @"http://h.hiphotos.baidu.com/image/pic/item/ac345982b2b7d0a2ab6ef529ceef76094a369adb.jpg",
                               @"http://pic3.bbzhi.com/xitongbizhi/gaoduibidujingmeigaoqingkuan/computer_kuan_281529_18.jpg",
                               @"http://d.hiphotos.baidu.com/image/pic/item/1f178a82b9014a90cd5ab709ac773912b31bee1a.jpg",
                               @"http://a.hiphotos.baidu.com/image/pic/item/94cad1c8a786c917b77e890dcc3d70cf3bc75781.jpg",
                               @"http://t1.27270.com/uploads/tu/201502/925/1.jpg",
                               @"http://a.hiphotos.baidu.com/image/pic/item/4afbfbedab64034f30575067a9c379310a551d3c.jpg",
                               @"http://pic30.nipic.com/20130624/7447430_170252095000_2.jpg",
                               @"http://img2.iqilu.com/ed/10/05/07/13/31_100507093116_1.jpg",
                               @"http://pic7.nipic.com/20100512/3017209_112312352642_2.jpg",
                               @"http://y0.ifengimg.com/news_spider/dci_2013/07/48082ba59d0bbb1213a6e1771bcea2d9.jpg",
                               @"http://p2.img.cctvpic.com/20120430/images/1335766113283_1335766113283_r.jpg",
                               @"http://fs.sese.com.cn/share/upload/20150925/f076eca6-1b8b-4b6b-ad89-2e93ab3b365a.jpg",
                               @"http://i7.topit.me/7/31/18/1134224070f8818317o.jpg",
                               
                               ];
    return imageUrlArray;
}

@end
