//
//  YZFlowLayout.m
//  YZDisplayViewControllerDemo
//
//  Created by yz on 15/12/20.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "YZFlowLayout.h"

@implementation YZFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    if (self.collectionView.bounds.size.height) {
        //一个itemSize是collectionView的size
        self.itemSize = self.collectionView.bounds.size;
    }

    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

@end
