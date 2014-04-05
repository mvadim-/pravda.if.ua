//
//  DetailViewController.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NSString+HTML.h"
#import "UIWebView+AFNetworking.h"


@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *descriptionView;

@end

@implementation DetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *html          = [NSString stringWithFormat: @"http://pravda.if.ua/print.php?id=%@",
                               [self searchNewsNumberInLink:[self.rssItem.link absoluteString]]];
    NSURLRequest *request   = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:html]];
    [self.descriptionView loadRequest:request];
    self.descriptionView.scrollView.showsVerticalScrollIndicator = NO;
    self.descriptionView.scrollView.delegate = self;
}

-(NSString*)searchNewsNumberInLink:(NSString*)link;
{
    NSError *error;
    NSRegularExpression *regex  = [NSRegularExpression regularExpressionWithPattern:@"\\d{5}"
                                                                           options:0
                                                                             error:&error];
    __block NSString *number    = @"";
    [regex enumerateMatchesInString:link
                            options:0
                              range:NSMakeRange(0, [link length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             number = [number stringByAppendingString:[link substringWithRange:result.range]];

                         }];
    return number;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    webView.scalesPageToFit = YES;//set here
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *jsBody    = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                          400];
    NSString *jsTitle   = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('h1')[0].style.webkitTextSizeAdjust= '%d%%'",
                          200];
    [self.descriptionView stringByEvaluatingJavaScriptFromString:jsBody];
    [self.descriptionView stringByEvaluatingJavaScriptFromString:jsTitle];
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];

    
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return nil;
}

- (IBAction)shareButton:(UIBarButtonItem *)sender
{
    NSString *title         = self.rssItem.title;
    NSString *description   = [self.rssItem.itemDescription stringByConvertingHTMLToPlainText] ;
    NSArray *items          = @[title,description];
    UIActivityViewController *activity  = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities: nil];
    activity.excludedActivityTypes      = @[UIActivityTypePostToWeibo,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard];
    [self presentViewController:activity animated:YES completion:nil];
}


@end