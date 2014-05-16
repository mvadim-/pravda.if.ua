//
//  MenuTableViewController.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 06.04.14.
//  Copyright (c) 2014 MDG. All rights reserved.
//

#import "MenuTableViewController.h"
#import "pravdaViewController.h"

static NSInteger numberOfCategories = 8;

@interface MenuTableViewController ()

@property (strong, nonatomic)  NSNumber *category;
@property (strong, nonatomic)  NSArray *categories;

@end

@implementation MenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue        = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock                        = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            pravdaViewController *rootCtrl          = (pravdaViewController*)segue.destinationViewController;
            rootCtrl.category                       = self.category;
            UINavigationController* navController   = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return self.category ? YES : NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categories = @[@"news",@"coruption",@"politics",@"economic",@"photo",@"crime",@"ecocrime",@"finance"];
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = self.categories[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.89 green:0.94 blue:0.89 alpha:0.5]]; // set color here
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case news:
            self.category = @0;
            break;
        case coruption:
            self.category = @18;
            break;
        case politics:
            self.category = @1;
            break;
        case economic:
            self.category = @2;
            break;
        case photo:
            self.category = @15;
            break;
        case crime:
            self.category = @9;
            break;
        case ecocrime:
            self.category = @19;
            break;
        case finance:
            self.category = @7;
            break;
    }
    [self performSegueWithIdentifier:@"toRoot" sender:nil];
}

@end
