//
//  MenuTableViewController.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 06.04.14.
//  Copyright (c) 2014 MDG. All rights reserved.
//

#import "MenuTableViewController.h"
#import "pravdaViewController.h"
@interface MenuTableViewController ()

@property (strong, nonatomic)  NSNumber *category;

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
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            pravdaViewController *rootCtrl = (pravdaViewController*)segue.destinationViewController;
            rootCtrl.category = self.category;
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (!self.category){return NO;}
    else return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // This will remove extra separators from tableview
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"news";
            break;
            
        case 1:
            CellIdentifier = @"coruption";
            break;
            
        case 2:
            CellIdentifier = @"politics";
            break;
            
        case 3:
            CellIdentifier = @"economic";
            break;
            
        case 4:
            CellIdentifier = @"photo";
            break;
            
        case 5:
            CellIdentifier = @"crime";
            break;
            
        case 6:
            CellIdentifier = @"ecocrime";
            break;
            
        case 7:
            CellIdentifier = @"finince";
            break;
   
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.89 green:0.94 blue:0.89 alpha:0.5]]; // set color here
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"news"]) {
        self.category = @0;
    }else if ([cell.reuseIdentifier isEqualToString:@"coruption"]) {
        self.category = @18;
    }else if ([cell.reuseIdentifier isEqualToString:@"politics"]) {
        self.category = @1;
    }else if ([cell.reuseIdentifier isEqualToString:@"economic"]) {
        self.category = @2;
    }else if ([cell.reuseIdentifier isEqualToString:@"photo"]) {
        self.category = @15;
    }else if ([cell.reuseIdentifier isEqualToString:@"crime"]) {
        self.category = @9;
    }else if ([cell.reuseIdentifier isEqualToString:@"ecocrime"]) {
        self.category = @19;
    }else if ([cell.reuseIdentifier isEqualToString:@"finince"]) {
        self.category = @7;
    }

    [self performSegueWithIdentifier:@"toRoot" sender:nil];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
