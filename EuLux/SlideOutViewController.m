//
//  SlideOutViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SlideOutViewController.h"
#import "SWRevealViewController.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"

#import "OrdersViewController.h"
#import "EmployeeViewController.h"
#import "CustomerViewController.h"
#import "InventoryViewController.h"
#import "ContactsViewController.h"
#import "SettingsViewController.h"


@interface SlideOutViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SlideOutViewController
{
    NSArray *arrayOfComponents, *arrayOfSegueID;
    CATransform3D initialTransfrom;
    NSInteger indexOfSlectedCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.revealViewController.rightViewRevealWidth = 150;
    [self.revealViewController tapGestureRecognizer];
    arrayOfComponents = @[@"Order", @"Customer", @"Inventory", @"Contacts", @"Employee", @"Setting", @"Log Out"];
    arrayOfSegueID = @[@"ordersListSegue",@"customersListSegue", @"inventoryListSegue",@"contactsListSegue", @"employeesListSegue", @"settingsSegue"];
    
//    initialTransfrom.m34 = 1/500;
    initialTransfrom = CATransform3DMakeTranslation(-200, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationController *navController = (UINavigationController *)self.revealViewController.frontViewController;
    if ([navController.viewControllers[0] isKindOfClass:[OrdersViewController class]])
    {
        indexOfSlectedCell = 0;
        NSLog(@"Order class");
    }else if ([navController.viewControllers[0] isKindOfClass:[CustomerViewController class]])
    {
        indexOfSlectedCell = 1;
        NSLog(@"Customer class");
    }else if ([navController.viewControllers[0] isKindOfClass:[InventoryViewController class]])
    {
        indexOfSlectedCell = 2;
        NSLog(@"Inventory class");
    }else if ([navController.viewControllers[0] isKindOfClass:[ContactsViewController class]])
    {
        indexOfSlectedCell = 3;
        NSLog(@"Contacts class");
    }else if ([navController.viewControllers[0] isKindOfClass:[EmployeeViewController class]])
    {
        indexOfSlectedCell = 4;
        NSLog(@"Employee class");
    }else if ([navController.viewControllers[0] isKindOfClass:[SettingsViewController class]])
    {
        indexOfSlectedCell = 5;
        NSLog(@"Settings class");
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfComponents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    UILabel *nameLable = (UILabel *)[cell viewWithTag:10];
    nameLable.text = arrayOfComponents[indexPath.row];
    
    UIView *cellView = (UIView *)[cell viewWithTag:125];
    if (indexPath.row == indexOfSlectedCell)
    {
        cellView.backgroundColor = [UIColor colorWithRed:.49 green:.56 blue:.98 alpha:1];
        nameLable.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:21];
        
    }else
    {
        cellView.backgroundColor = [UIColor darkGrayColor];
        nameLable.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:18];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* swReaveal = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController *swController = self.revealViewController;
        
        swReaveal.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
            [swController setFrontViewController:dvc animated:YES];
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < [arrayOfSegueID count])
    {
        if (indexPath.row != indexOfSlectedCell)
        {
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *cellView = (UIView *)[selectedCell viewWithTag:125];
            cellView.backgroundColor = [UIColor colorWithRed:.49 green:.56 blue:.98 alpha:1];
            UILabel *nameLable = (UILabel *)[selectedCell viewWithTag:10];
            nameLable.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:21];
            
            
            
            
            NSIndexPath *indexPathOfPastCell = [NSIndexPath indexPathForRow:indexOfSlectedCell inSection:0];
            UITableViewCell *pastCell = [tableView cellForRowAtIndexPath:indexPathOfPastCell];
            UIView *pastCellView = (UIView *)[pastCell viewWithTag:125];
            pastCellView.backgroundColor = [UIColor darkGrayColor];
            nameLable = (UILabel *)[pastCell viewWithTag:10];
            nameLable.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:18];
            
            [self performSegueWithIdentifier:arrayOfSegueID[indexPath.row] sender:self];
        }else
        {
            [self.revealViewController rightRevealToggleAnimated:YES];
        }
    }else
    {
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        UINavigationController *nav =(UINavigationController *) appDel.window.rootViewController;
        
        WelcomeViewController *welcome = (WelcomeViewController *)nav.viewControllers[0];
        
        welcome.logOut = YES;
        
        NSLog(@"Auto sign in status changed");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UserAutoSignInStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [nav popToRootViewControllerAnimated:NO];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cellView = (UIView *)[cell viewWithTag:125];
    cellView.layer.transform = initialTransfrom;
    cellView.layer.opacity = 0.8;

    
    CGFloat delay = (CGFloat)indexPath.row;
    delay = delay/25.0;
    
    [UIView animateWithDuration:.5 delay:delay options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        cellView.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
