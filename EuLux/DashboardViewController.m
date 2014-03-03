//
//  DashboardViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SWRevealViewController.h"
#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

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
- (IBAction)moveToNextView:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"slideoutSegue" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SWRevealViewController *revealVC = (SWRevealViewController *)segue.destinationViewController;
    revealVC.tagOfSender = [sender tag];
}
@end
