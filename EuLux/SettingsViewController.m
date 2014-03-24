//
//  SettingsViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/12/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UISwitch *autoSignIn;

@end

@implementation SettingsViewController

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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1];
    }else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1]];
    }
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
    
    self.autoSignIn.on = [[NSUserDefaults standardUserDefaults] boolForKey:UserAutoSignInStatus];
}
- (IBAction)autoSignInValueChanged:(UISwitch *)sender
{
    NSLog(@"Auto sign in status changed");
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:UserAutoSignInStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (sender.on)
    {
        NSString *currentUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserName];
        NSString *currentPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentPassowrd];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentUserName forKey:kSavedUserName];
        [[NSUserDefaults standardUserDefaults] setObject:currentPassword forKey:kSavedPassowrd];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"xxxxx" forKey:kSavedUserName];
        [[NSUserDefaults standardUserDefaults] setObject:@"xxxxx" forKey:kSavedPassowrd];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
