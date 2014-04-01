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
#import "RSSParser.h"
#import "RSSItem.h"
#import "MBProgressHUD.h"

@interface pravdaViewController ()
{
    NSArray *arrayOfImages;
    NSArray *arrayOfDecriptions;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;

@end

@implementation pravdaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Loading..."];
    [self refresh:nil];
}

- (IBAction)refresh:(UIBarButtonItem *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://pravda.if.ua/rss_new.php"]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        [self setTitle:@"Правда.if.ua"];
        self.dataSource=feedItems;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.myCollectionView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self setTitle:@"Error"];
        NSLog(@"Error: %@",error);
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item               = [self.dataSource objectAtIndex:indexPath.row];
    static NSString *cellIdent  = @"cellid";
    MyCustomCell *cell          = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
    cell.imageInCell.image      = nil;
    
    if([item.title length]) cell.lableInCell.text       = item.title;
    if([item.category length]) cell.categoryLabel.text  = item.category;
    if (item.pubDate)
    {
        NSDateFormatter * date_format = [[NSDateFormatter alloc] init];
        [date_format setDateFormat:@"MMM dd, HH:mm"];
        NSString * date_string = [date_format stringFromDate: item.pubDate];
        cell.dateLable.text = date_string;
    }
    
    if ([[item imagesFromItemDescription] count]) {
        [cell.imageInCell setImageWithURL:[NSURL URLWithString:[item.imagesFromItemDescription objectAtIndex:0]]
                         placeholderImage:[UIImage imageNamed:@"pravda.png"]];
    }   else cell.imageInCell.image=[UIImage imageNamed:@"pravda.png"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *selectedIndexPath = [[self.myCollectionView indexPathsForSelectedItems] objectAtIndex:0];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.rssItem=[self.dataSource objectAtIndex:selectedIndexPath.row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
