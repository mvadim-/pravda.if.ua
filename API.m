//
//  API.m
//  Правда.if.ua
//
//  Created by Vadim Maslov on 08.04.14.
//  Copyright (c) 2014 MDG. All rights reserved.
//

#import "API.h"
#import "RSSParser.h"

static NSString *news_url = @"http://pravda.if.ua/rssiphone.php?";

@implementation API


-(void)refreshDataFromServerWithCategory:(NSNumber *)cat andOffset:(NSNumber *)offset completionBlock:(void(^)(NSArray *response ,bool succeeded,NSError *error))completionBlock
{
    NSURLRequest *req   = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self prepareUrlWithCategory:cat andOffset:offset]]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {

        completionBlock(feedItems,YES,nil);
    } failure:^(NSError *error) {
        
        completionBlock(nil,NO,error);
    }];
}

-(NSString *)prepareUrlWithCategory:(NSNumber *)cat andOffset:(NSNumber *)offset
{
    NSString *URL = news_url;
    if (cat) {
        //add category to url string
        URL = [URL stringByAppendingString:[NSString stringWithFormat:@"cat_id=%d",[cat intValue]]];
    }
    if (offset) {
        //add offset to url string
        URL = [URL stringByAppendingString:[NSString stringWithFormat:@"&offs=%d",[offset intValue]]];
    }
    return URL;
}

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
@end
