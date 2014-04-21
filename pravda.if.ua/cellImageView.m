//
//  cellImageView.m
//  Правда.if.ua
//
//  Created by Vadim Maslov on 18.04.14.
//  Copyright (c) 2014 MDG. All rights reserved.
//

#import "cellImageView.h"

@implementation cellImageView

- (void)setEventImage:(UIImage*)image animated:(BOOL)animated
{
    UIActivityIndicatorView *indicator = [[self subviews] lastObject];
    [indicator stopAnimating];
    
    if (animated) {
        [self animateFade];
    }
	
    self.image = image;
}

- (void)animateFade
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75;
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}

- (void)clearImage:(UIImage*)defaultImage
{
    self.image = defaultImage;
    
    UIActivityIndicatorView *indicator = [[self subviews] lastObject];
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        indicator.hidesWhenStopped = YES;
        indicator.center = self.center;
        [self addSubview:indicator];
    }
    [indicator startAnimating];
}

@end
