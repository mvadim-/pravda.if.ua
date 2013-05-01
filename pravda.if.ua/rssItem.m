//
//  rssItem.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 30.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "rssItem.h"

@implementation rssItem

- (id)init
{
    self = [super init];
    if (self) {
        _title = [NSString new];
        _description = [NSString new];
        _url = [NSURL new];
    }
    return self;
}
@end
