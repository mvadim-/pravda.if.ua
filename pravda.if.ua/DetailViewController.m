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
#import "MWPhotoBrowser.h"

@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate>{
MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIBarButtonItem *textSize;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTap;
@property (strong, nonatomic)  NSArray *photos;
@property (weak, nonatomic) IBOutlet UISlider *textSlider;

@end

@implementation DetailViewController

#pragma mark - ViewController life cycle

-(void)loadView
{
    [super loadView];
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hide toolbar
    self.toolbar.alpha = 0;
    self.descriptionView.alpha = 0;
    NSNumber *sliderValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"sliderValue"];
    self.textSlider.value = sliderValue ? [sliderValue floatValue] : 1.5;
    self.textSize = [[UIBarButtonItem alloc] initWithTitle:@"aA" style:UIBarButtonItemStylePlain  target:self action:@selector(showToolbar)];
    
    [self.navigationItem setRightBarButtonItems:@[self.shareButton,self.textSize] animated:YES ];
    
    [self webViewSetup];
}

-(void)webViewSetup
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
    HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Завантаження...";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSlider)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    NSString *html          = [NSString stringWithFormat: @"http://pravda.if.ua/print.php?id=%@",
                               [self searchNewsNumberInLink:[self.rssItem.link absoluteString]]];
    NSURLRequest *request   = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:html]];
    [self.descriptionView addGestureRecognizer:tap];
    [self.descriptionView loadRequest:request progress:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {

    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [HUD hide:YES];

        return HTML;
    } failure:^(NSError *error) {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = [NSString stringWithFormat:@"%@",[error localizedDescription]];
    }];
    self.descriptionView.scrollView.showsVerticalScrollIndicator = NO;
    self.descriptionView.scrollView.delegate = self;
}

-(void)showToolbar
{
    if (self.toolbar.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.toolbar.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.toolbar.alpha = 0;
        }];
    }
}

-(void)hideSlider
{
    if (!self.toolbar.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.toolbar.alpha = 0;
        }];
        
    }
}

- (IBAction)changeTextSize:(UISlider *)sender
{
    NSNumber *textsize = [NSNumber numberWithInt:sender.value * 267];
    NSNumber *value = [NSNumber numberWithFloat:sender.value ];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:textsize forKey:@"textSize"];
    [userDefaults setObject:value forKey:@"sliderValue"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *jsBody    = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                           [textsize intValue]];
    [self.descriptionView stringByEvaluatingJavaScriptFromString:jsBody];
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

#pragma mark - webView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    webView.scalesPageToFit = YES;//set here
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSNumber *textSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"textSize"];
    if (!textSize) {
        textSize = @400;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  //  [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *jsBody    = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                            [textSize intValue]];
    NSString *jsTitle   = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('h1')[0].style.webkitTextSizeAdjust= '%d%%'",
                           200];
    [self.descriptionView stringByEvaluatingJavaScriptFromString:jsBody];
    [self.descriptionView stringByEvaluatingJavaScriptFromString:jsTitle];
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
  //  [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [UIView animateWithDuration:0.2 animations:^{
        self.descriptionView.alpha = 1;
    }];
}

- (IBAction)boubleTap:(UITapGestureRecognizer *)sender
{
    //java script for detecting images in html code
    NSString *script = @"var names = []; var a = document.getElementsByTagName(\"IMG\");for (var i=0, len=a.length; i<len; i++){names.push(document.images[i].src);}String(names);";
    NSString *urls   = [self.descriptionView stringByEvaluatingJavaScriptFromString:script];
    NSArray *imageUrlArray = [urls componentsSeparatedByString:@","];
    [self removeLogoInArrayOfImages:imageUrlArray];
}

-(void)removeLogoInArrayOfImages:(NSArray*)array
{
    __block NSMutableArray *images = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[obj lastPathComponent]isEqualToString:@"pravda.png"]) {
            [images addObject:obj];
        }
    }];
    if ([images count]) {
        [self loadPhotoBrowserWithArray:images];
    }
}

#pragma mark - MWPhotoBrowser

-(void)loadPhotoBrowserWithArray:(NSMutableArray*)array
{
    // Create array of MWPhoto objects
    __block NSMutableArray *photos = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:obj]];
        photo.caption = [NSString stringWithFormat:@"%@ \n %@",self.rssItem.title,self.rssItem.link];
        [photos addObject:photo];
    }];
    self.photos = photos;
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton     = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows        = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill        = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls      = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid              = YES;   // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid             = [photos count] > 1 ? YES : NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:[photos count]];
    
    // Modal
    UINavigationController *nc  = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle     = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < [self.photos count])
        return [self.photos objectAtIndex:index];
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return nil;//disable zooming in webview
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideSlider];
}

- (IBAction)shareButton:(UIBarButtonItem *)sender
{
    NSString *title         = self.rssItem.title;
    NSString *description   = [self.rssItem.itemDescription stringByConvertingHTMLToPlainText] ;
    NSString *link          = [self.rssItem.link  absoluteString];
    NSArray *items          = @[title,description,link];
    UIActivityViewController *activity  = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities: nil];
    activity.excludedActivityTypes      = @[UIActivityTypePostToWeibo,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard];
    [self presentViewController:activity animated:YES completion:nil];
}


@end