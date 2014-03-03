//
//  EmployeeViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "EmployeeViewController.h"


@interface EmployeeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation EmployeeViewController

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
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
