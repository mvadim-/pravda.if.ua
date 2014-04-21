//
//  MyCustomCell.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "MyCustomCell.h"

@interface MyCustomCell()

@end

@implementation MyCustomCell

-(void)awakeFromNib
{
    self.imageInCell.clipsToBounds = YES;
}


@end
