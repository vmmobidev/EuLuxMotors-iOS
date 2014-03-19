//
//  SlideOutViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SlideOutViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface SlideOutViewController ()

@end

@implementation SlideOutViewController
{
    NSArray *arrayOfComponents, *arrayOfSegueID;
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
    self.revealViewController.rightViewRevealWidth = 160;
    [self.revealViewController tapGestureRecognizer];
    arrayOfComponents = @[@"Order", @"Customer", @"Inventory", @"Contacts", @"Employee", @"Setting", @"Log Out"];
    arrayOfSegueID = @[@"ordersListSegue",@"customersListSegue", @"inventoryListSegue",@"contactsListSegue", @"employeesListSegue", @"settingsSegue"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* swReaveal = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController *swController = self.revealViewController;
        
        swReaveal.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
//            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
//            nc.navigationBarHidden = NO;
            [swController setFrontViewController:dvc animated:YES];
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < [arrayOfSegueID count])
    {
        [self performSegueWithIdentifier:arrayOfSegueID[indexPath.row] sender:self];
    }else
    {
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        UINavigationController *nav =(UINavigationController *) appDel.window.rootViewController;
        [nav popToRootViewControllerAnimated:NO];
    }
}

@end
