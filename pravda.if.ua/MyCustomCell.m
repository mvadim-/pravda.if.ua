//
//  MyCustomCell.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "MyCustomCell.h"

@interface MyCustomCell()

@property (weak, nonatomic) IBOutlet UIView *imageContainer;

@end

@implementation MyCustomCell

-(void)awakeFromNib
{
    self.imageInCell.clipsToBounds = YES;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.imageInCell.bounds];
    self.imageContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageContainer.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.imageContainer.layer.shadowOpacity = 0.5f;
    self.imageContainer.layer.shadowRadius = 1.0f;
    self.imageContainer.layer.shadowPath = shadowPath.CGPath;
}


@end
