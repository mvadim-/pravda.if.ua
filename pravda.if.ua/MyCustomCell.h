//
//  MyCustomCell.h
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageInCell;
@property (weak, nonatomic) IBOutlet UILabel *lableInCell;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@end
