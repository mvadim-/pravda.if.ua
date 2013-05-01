#import "RSSFetchOperation.h"
#import "rssItem.h"

enum ItemField {
    ItemFieldNone,
    ItemFieldTitle,
    ItemFieldDescription,
    ItemFieldUrl,
};

@interface RSSFetchOperation () <NSXMLParserDelegate>
@end

@implementation RSSFetchOperation



- (void)main
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    NSURLResponse *response = NULL;
    NSError *error = NULL;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSObject<RSSFetchOperationDelegate> *d = self.delegate;
    if (data == NULL && d != NULL && ![self isCancelled]) {
        [d performSelectorOnMainThread:@selector(rssFetchOperationDidFailedWithError:) withObject:error waitUntilDone:NO];
    } else {
        processingItems = [NSMutableArray array];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        
        if ([parser parse]) {
            [d performSelectorOnMainThread:@selector(rssFetchOperationDidFinishWithItems:) withObject:[processingItems copy] waitUntilDone:NO];
        } else {
            [d performSelectorOnMainThread:@selector(rssFetchOperationDidFailedWithError:) withObject:[parser parserError] waitUntilDone:NO];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        [processingItems addObject:[rssItem new]];
        itemField = ItemFieldNone;
        return;
    }
    if ([elementName isEqualToString:@"title"]) {
        itemField = ItemFieldTitle;
        return;
    }
    if ([elementName isEqualToString:@"description"]) {
        itemField = ItemFieldDescription;
        return;
    }
    if ([elementName isEqualToString:@"link"]) {
        itemField = ItemFieldUrl;
        return;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    itemField = ItemFieldNone;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    rssItem *item = [processingItems lastObject];
    NSLog(@"current string of xml items is %@", string);
    switch (itemField) {
        case ItemFieldTitle:
            item.title = string;
            break;
        case ItemFieldDescription:
            item.description = string;
            break;
        case ItemFieldUrl:
            item.url = [NSURL URLWithString:string];
            break;
    }
}



@end
