#import <Foundation/Foundation.h>

@class RSSFetchOperation;

@protocol RSSFetchOperationDelegate
- (void)rssFetchOperationDidFinishWithItems:(NSArray*)items;
- (void)rssFetchOperationDidFailedWithError:(NSError*)error;
@end


@interface RSSFetchOperation : NSOperation {
    NSMutableArray *processingItems;
    int itemField;
}
@property (nonatomic, unsafe_unretained) NSObject<RSSFetchOperationDelegate> *delegate;
@property (nonatomic, strong) NSURL *url;

@end
