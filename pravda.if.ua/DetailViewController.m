//
//  DetailViewController.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *descriptionView;

@end

@implementation DetailViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *html = [NSString stringWithFormat: @"http://pravda.if.ua/print.php?id=%@",[self searchNewsNumberInLink:[self.rssItem.link absoluteString]]];
    NSLog(@"html:%@",html);

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:html]];
    [self.descriptionView loadRequest:request];
    self.descriptionView.scrollView.showsVerticalScrollIndicator = NO;
}

-(NSString*)searchNewsNumberInLink:(NSString*)link;
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d{5}"
                                                                           options:0
                                                                             error:&error];
    __block NSString *number = @"";
    [regex enumerateMatchesInString:link
                            options:0
                              range:NSMakeRange(0, [link length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             number = [number stringByAppendingString:[link substringWithRange:result.range]];
                             NSLog(@"number:%@", number);

                         }];
    NSLog(@"link:%@, return number:%@",link, number);
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
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                          280];
    [self.descriptionView stringByEvaluatingJavaScriptFromString:jsString];
    
  //  [self.descriptionView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[1].style.width = '180px'"];

}

@end