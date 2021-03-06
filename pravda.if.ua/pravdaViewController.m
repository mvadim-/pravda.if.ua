//
//  pravdaViewController.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//


#import "pravdaViewController.h"
#import "MyCustomCell.h"
#import "DetailViewController.h"
#include "UIImageView+AFNetworking.h"
#import "API.h"
#import "RSSItem.h"
#import "MBProgressHUD.h"

@interface pravdaViewController ()
{
    NSArray *arrayOfImages;
    NSArray *arrayOfDecriptions;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) UIActivityIndicatorView *downloadActivityIndicator;

@end

@implementation pravdaViewController

#pragma mark - Lazy instantiation
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(UIActivityIndicatorView *)downloadActivityIndicator
{
    if (!_downloadActivityIndicator) {
        _downloadActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _downloadActivityIndicator.activityIndicatorViewStyle   = UIActivityIndicatorViewStyleGray;
        _downloadActivityIndicator.hidesWhenStopped             = YES;
    }
    return _downloadActivityIndicator;
}

-(UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Потягніть для оновлення..."];
    }
    return _refreshControl;
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Завантаження..."];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    [self.myCollectionView addSubview:self.refreshControl];
    self.myCollectionView.alwaysBounceVertical = YES;
    [self refresh:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector( appActivated: )
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

- (void)appActivated:(NSNotification *)note
{
    if ([[API sharedInstance] isUpdatedInBackground]) {
        [self refresh:nil];
    }
}
#pragma mark -
#pragma mark Interface Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)refresh:(UIBarButtonItem *)sender
{
    //reset offset if refreshing from pull to refresh or refresh button
    self.offset = nil;
    
    //show refresh hud if refresh buuton taped only
    if (!self.refreshControl.isRefreshing)
    {
        //Collection view scroll to top
        if ([self.dataSource count])[self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                                  atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self downloadDataWithCompletion:^(bool succeeded)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(void)downloadDataWithCompletion:(void(^)(bool succeeded))completion
{
    [[API sharedInstance] refreshDataFromServerWithCategory:self.category
                                                  andOffset:self.offset
                                            completionBlock:^(NSArray *response, bool succeeded, NSError *error) {
                                                [self.refreshControl endRefreshing];
                                                if (succeeded) {
                                                    [[API sharedInstance] setUpdatedInBackground:NO];
                                                    if (!self.offset){
                                                        [self.dataSource removeAllObjects];
                                                    }
                                                    //reset last background update time
                                                    [self setTitle:[[API sharedInstance] categoryNameWithNumber:self.category ? self.category :@0]];
                                                    [self.dataSource addObjectsFromArray: response];
                                                    [self lastNewsDate:[(RSSItem *)[self.dataSource firstObject] pubDate]];
                                                    if (!self.offset) {[self.myCollectionView reloadData];}
                                                    completion(YES);
                                                } else{
                                                    [self setTitle:@"Помилка"];
                                                    NSString *errorString   = [NSString stringWithFormat:@"%@.\nСпробуйте оновити данні.",[error localizedDescription]];
                                                    UIAlertView* alert      = [[UIAlertView alloc] initWithTitle:@"Щось трапилось:" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                    [alert show];
                                                    completion(NO);
                                                }
                                            }];
}

-(void)lastNewsDate:(NSDate *)date
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:date forKey:@"lastUpdateTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Collection View

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *defaultImage = [UIImage imageNamed:@"pravda"];
    
    RSSItem *item               = self.dataSource[indexPath.row];
    static NSString *cellIdent  = @"cellid";
    
    MyCustomCell *cell          = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent
                                                                            forIndexPath:indexPath];
    [cell.imageInCell clearImage:defaultImage];
    
    if([item.title length])
    {
        cell.lableInCell.text = item.title;
        if ([item.isTopNews boolValue]) {
            cell.lableInCell.textColor = [UIColor colorWithRed:0.67 green:0.29 blue:0.29 alpha:1];
        } else  cell.lableInCell.textColor = [UIColor blackColor];
        
        cell.lableInCell.text = item.title;
    }
    
    if (item.pubDate)
    {
        NSDateFormatter * date_format   = [[NSDateFormatter alloc] init];
        [date_format setDateFormat:@"MMM dd, HH:mm"];
        NSString * date_string          = [date_format stringFromDate: item.pubDate];
        cell.dateLable.text             = date_string;
    }
    if (item.enclosure)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:item.enclosure]];
        [cell.imageInCell setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             [cell.imageInCell setEventImage:image animated:(BOOL)response];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             [cell.imageInCell setEventImage:defaultImage animated:NO];
                                         }];
        
    }   else [cell.imageInCell setEventImage:defaultImage animated:NO];
    //check for last item in collection and insert new value
    if (indexPath.row == ([self.dataSource count]-1))
    {
        [self performSelector:@selector(addMoreNewsAfterLastRowWithIndexPath:) withObject:indexPath];
    }
    return cell;
}

-(void)addMoreNewsAfterLastRowWithIndexPath:(NSIndexPath *)indexPath
{
    //download nex 20 news
    NSOperationQueue *myQueue = [NSOperationQueue new];
    [myQueue addOperationWithBlock:^{
        int offset  = [self.offset intValue];
        self.offset = @(offset+=20);
        [self.downloadActivityIndicator startAnimating];
        [self downloadDataWithCompletion:^(bool succeeded)  {
            if (succeeded) {
                [self.downloadActivityIndicator stopAnimating];
                [self.downloadActivityIndicator removeFromSuperview];
                //update collection view with new news
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.myCollectionView performBatchUpdates:^{
                        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                        NSUInteger resultsSize              = [self.dataSource count];
                        NSInteger numberOfNewsInList        = 20;
                        for (int i = resultsSize - numberOfNewsInList; i < resultsSize ; i++){
                            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        }
                        [self.myCollectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
                    } completion:nil];
                }];
            }
        }];
    }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    // add spiner to footer
    UICollectionReusableView *theView;
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:theIndexPath];
    } else
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:theIndexPath];
        self.downloadActivityIndicator.frame = CGRectMake(theView.frame.size.width/2-10, theView.frame.size.height/2-10, 20, 20);
        [theView addSubview:self.downloadActivityIndicator];
    }
    return theView;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        DetailViewController *detailViewController  = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"showDetail"])
        {
            NSIndexPath *selectedIndexPath  = [self.myCollectionView indexPathsForSelectedItems][0];
            detailViewController.rssItem    = (self.dataSource)[selectedIndexPath.row];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
