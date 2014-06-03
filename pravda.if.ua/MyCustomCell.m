//
//  MyCustomCell.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "MyCustomCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyCustomCell

-(void)awakeFromNib
{
    self.imageInCell.clipsToBounds = YES;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowOpacity = 0.15f;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowPath = shadowPath.CGPath;
    
}


@end
