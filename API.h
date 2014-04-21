//
//  API.h
//  Правда.if.ua
//
//  Created by Vadim Maslov on 08.04.14.
//  Copyright (c) 2014 MDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

@property (nonatomic, getter = isUpdatedInBackground) BOOL updatedInBackground;

-(void)refreshDataFromServerWithCategory:(NSNumber *)cat andOffset:(NSNumber *)offset completionBlock:(void(^)(NSArray *response ,bool succeeded,NSError *error))completionBlock;
-(NSString *)categoryNameWithNumber:(NSNumber *)num;
+ (id)sharedInstance;
@end
