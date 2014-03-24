//
//  DashboardViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SWRevealViewController.h"
#import "DashboardViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "WelcomeViewController.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UIControl *order;
@property (weak, nonatomic) IBOutlet UIControl *customer;
@property (weak, nonatomic) IBOutlet UIControl *inventoryBtn;
@property (weak, nonatomic) IBOutlet UIControl *contactBtn;
@property (weak, nonatomic) IBOutlet UIControl *employeeBtn;
@property (weak, nonatomic) IBOutlet UIControl *settingsBtn;
@property (weak, nonatomic) IBOutlet UIControl *logoutBtn;

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customerTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signOutBottomConst;

@end

@implementation DashboardViewController
{
    UIButton *selectedButton;
    BOOL logOutKeyIsPressed;
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
    
    if ([UIScreen mainScreen].bounds.size.height != 568)
    {
        self.orderTopConst.constant = 40;
        self.customerTopConst.constant = 40;
        self.signOutBottomConst.constant = 10;
    }else
    {
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.whiteView.alpha = 0;
    [self animateAllSubviews];
    
    logOutKeyIsPressed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moveToNextView:(UIButton *)sender
{
    selectedButton = sender;
    [self removeAllSubviews];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SWRevealViewController *revealVC = (SWRevealViewController *)segue.destinationViewController;
    revealVC.tagOfSender = [sender tag];
}
- (IBAction)logOut:(UIButton *)sender
{
    
    logOutKeyIsPressed = YES;
    [self removeAllSubviews];
}

- (void)animateAllSubviews
{
    [self animateSubView:self.order wtihDelay:0];
    [self animateSubView:self.customer wtihDelay:.25];
    [self animateSubView:self.inventoryBtn wtihDelay:.25];
    [self animateSubView:self.contactBtn wtihDelay:.5];
    [self animateSubView:self.employeeBtn wtihDelay:.5];
    [self animateSubView:self.settingsBtn wtihDelay:.75];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 240);
    self.logoutBtn.transform = transform;
    [UIView animateWithDuration:.75 delay:.5 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.logoutBtn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateSubView:(UIView *)subView wtihDelay:(CGFloat)delay
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(300, 0);
    subView.transform = transform;
    [UIView animateWithDuration:.75 delay:delay options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        subView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAllSubviews
{
    [self removeView:self.order withDelay:.75];
    [self removeView:self.customer withDelay:.50];
    [self removeView:self.inventoryBtn withDelay:.5];
    [self removeView:self.contactBtn withDelay:.25];
    [self removeView:self.employeeBtn withDelay:.25];
    [self removeView:self.settingsBtn withDelay:0];

    
    self.logoutBtn.translatesAutoresizingMaskIntoConstraints = YES;
    [UIView animateWithDuration:.75 delay:.75 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.logoutBtn.transform = CGAffineTransformMakeTranslation(0, 240);
        if (!logOutKeyIsPressed)
        {
            self.whiteView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if (logOutKeyIsPressed)
        {
            UINavigationController *nav = self.navigationController;
            
            WelcomeViewController *welcome = (WelcomeViewController *)nav.viewControllers[0];
            welcome.logOut = YES;
            
            NSLog(@"Auto sign in status changed");
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UserAutoSignInStatus];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [nav popToRootViewControllerAnimated:NO];
        }else
        {
        [self performSegueWithIdentifier:@"slideoutSegue" sender:selectedButton];
        }
    }];
    
//    [UIView animateWithDuration:1.25 animations:^{
//        self.whiteView.alpha = 1;
//    }];
}

- (void)removeView:(UIView *)subView withDelay:(CGFloat)delay
{
    subView.translatesAutoresizingMaskIntoConstraints = YES;
    [UIView animateWithDuration:.75 delay:delay options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        subView.transform = CGAffineTransformMakeTranslation(300, 0);
    } completion:^(BOOL finished) {
        
    }];
}

@end
