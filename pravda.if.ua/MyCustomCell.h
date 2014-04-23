//
//  MyCustomCell.h
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cellImageView.h"

@interface MyCustomCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableInCell;
@property (weak, nonatomic) IBOutlet cellImageView *imageInCell;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@end
