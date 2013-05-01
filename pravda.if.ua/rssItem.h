//
//  rssItem.h
//  pravda.if.ua
//
//  Created by Vadim Maslov on 30.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rssItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSURL *url;
@end
