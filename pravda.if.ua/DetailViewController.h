//
//  DetailViewController.h
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSItem.h"

@interface DetailViewController : UIViewController

@property (nonatomic,strong) RSSItem *rssItem;

@end
