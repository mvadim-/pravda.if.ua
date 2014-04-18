//
//  cellImageView.h
//  Правда.if.ua
//
//  Created by Vadim Maslov on 18.04.14.
//  Copyright (c) 2014 MDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellImageView : UIImageView

- (void)setEventImage:(UIImage*)image animated:(BOOL)animated;
- (void)clearImage:(UIImage*)defaultImage;

@end
