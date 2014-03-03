//
//  SlideOutViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SlideOutViewController.h"
#import "SWRevealViewController.h"

@interface SlideOutViewController ()

@end

@implementation SlideOutViewController
{
    NSArray *arrayOfComponents;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"cell1";
            break;
            
        case 1:
            CellIdentifier = @"cell2";
            break;
            
        case 2:
            CellIdentifier = @"cell3";
            break;
            
        case 3:
            CellIdentifier = @"signout";
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
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

@end
