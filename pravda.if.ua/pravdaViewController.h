//
//  pravdaViewController.h
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pravdaViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) NSArray *dataSource;

- (IBAction)refresh:(UIBarButtonItem *)sender;

@end
