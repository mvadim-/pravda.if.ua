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
@interface pravdaViewController ()

{
    NSArray *arrayOfImages;
    NSArray *arrayOfDecriptions;
}

@end

@implementation pravdaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    //flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    // flowLayout.itemSize=CGSizeMake(100,140);
    //   [self.myCollectionView setCollectionViewLayout:flowLayout animated:YES];
    self.myCollectionView.dataSource=self;
    self.myCollectionView.delegate=self;
    
    arrayOfImages=[[NSArray alloc]initWithObjects:@"pravda.png",@"pravda.png",@"pravda.png",@"pravda.png",@"image.jpg",@"image.jpg",@"pravda.png",@"image.jpg",@"pravda.png",@"image.jpg", nil];
    arrayOfDecriptions=[[NSArray alloc] initWithObjects:@"В області вшанували пам’ять жертв Чорнобильської катастрофи",@"Новий рекорд силач Назар Павлів присвятить Івано-Франківську",@"На Прикарпатті відібрано кращі мікропроекти з використання альтернативної та відновлювальної енергії",@"Бермейн Стіверн - претендент на бій із Кличком-старшим",@"\"Сучасне виховання\"",@"\"Сучасне виховання\"",@"\"Сучасне виховання\"",@"\"Сучасне виховання\"",@"\"Сучасне виховання\"",@"\"Сучасне виховання\"", nil];
	// Do any additional setup after loading the view, typically from a nib.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayOfDecriptions count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdent=@"cellid";
    MyCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
    [[cell imageInCell]setImage:[UIImage imageNamed:[arrayOfImages objectAtIndex:indexPath.item]]];
    [[cell lableInCell]setText:[arrayOfDecriptions objectAtIndex:indexPath.item]];
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *selectedIndexPath = [[self.myCollectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
        // NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
        // NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
        UIImage *image = [UIImage imageNamed:[arrayOfImages objectAtIndex:selectedIndexPath.row]];
        DetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.image = image;
        detailViewController.lable=[arrayOfDecriptions objectAtIndex:selectedIndexPath.row];
        NSLog(@"%@",detailViewController.lable);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
