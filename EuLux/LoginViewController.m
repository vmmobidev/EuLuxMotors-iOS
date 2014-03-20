//
//  ViewController.m
//  EuLux
//
//  Created by Varghese Simon on 2/28/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "LoginViewController.h"
#import "Animator.h"
//#import "AFNetworking.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIView *userNameContainer;
@property (weak, nonatomic) IBOutlet UIView *passwordContainer;
@end

@implementation LoginViewController
{
    Postman *postman;
    BOOL shouldSave;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
    
    self.userNameField.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userNameField.layer.shadowOffset = CGSizeMake(0, 0);
    self.userNameField.layer.shadowOpacity = .2f;
    self.userNameField.layer.shadowRadius = 5.0f;
    self.userNameField.layer.masksToBounds = NO;
    
    self.passwordField.layer.shadowColor = [UIColor blackColor].CGColor;
    self.passwordField.layer.shadowOffset = CGSizeMake(0, 0);
    self.passwordField.layer.shadowOpacity = .2f;
    self.passwordField.layer.shadowRadius = 5.0f;
    self.passwordField.layer.masksToBounds = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    shouldSave = YES;
//    [self checkForAutoLogIn];
    
    self.userNameContainer.layer.cornerRadius = 4;
    self.passwordContainer.layer.cornerRadius = 4;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self animateSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)returnKeyPressed:(id)sender
{
//    [self signIn:sender];
    [(UITextField *)sender resignFirstResponder];
}

- (IBAction)signIn:(id)sender
{
    if ((self.userNameField.text.length && self.passwordField.text.length) == 0)
    {
        self.userNameLable.alpha = 0.0f;
        self.userNameLable.hidden = NO;
        
        [UIView animateWithDuration:.5 animations:^{
            self.userNameLable.alpha = 1.0f;
        } completion:^(BOOL finished) {
            NSTimer *hideWarnigTimer;
            hideWarnigTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideuserNameLable:) userInfo:Nil repeats:NO];
        }];
    } else
    {
        [self.activityindicator startAnimating];
        self.signInButton.enabled = NO;
        
        NSString *stringJSON =[NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\",\"Password\":\"%@\"}}",self.userNameField.text,self.passwordField.text];

        postman = [[Postman alloc] init];
        postman.delegate = self;
        [postman post:@"http://ripple-io.in/Account/Authenticate" withParameters:stringJSON];
        
    }
}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error
{
    NSLog(@"Error : %@",error);
    [self.activityindicator stopAnimating];
    self.signInButton.enabled = YES;
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response
{
    [self.activityindicator stopAnimating];

    [self postRequestSuccessfulWithObject:response];
    self.signInButton.enabled = YES;
}

- (void)postRequestSuccessfulWithObject:(NSData *)responseData
{
    
    NSDictionary *JSONResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    NSDictionary *aaDataDict = JSONResponse[@"aaData"];
    
    NSLog(@"%@",aaDataDict[@"Success"]);
    
    if ([aaDataDict[@"Success"] boolValue])
    {
        NSLog(@"Authentication successful");
        [self sucessfulAuthentication];
    }else
    {
        NSLog(@"Authentication failed");
        [self failedAuthentication];

    }

}
- (void)hideWarningLabel:(NSTimer *)timer
{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.warningLabel.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.warningLabel.hidden = YES;
                     }];
}
- (void)hideuserNameLable:(NSTimer *)timer
{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.userNameLable.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.userNameLable.hidden = YES;
                     }];
}

- (void)sucessfulAuthentication
{
//    if (shouldSave)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:kSavedUserName];
//        [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:kSavedPassowrd];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:kCurrentPassowrd];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedUserName];
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedPassowrd];
    
    if ([savedUserName isEqualToString:self.userNameField.text] && [savedPassword isEqualToString:self.passwordField.text])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserAutoSignInStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self hideKeyboard:Nil];
    self.passwordField.text = @"";
    [self performSegueWithIdentifier:@"signInSuccessful" sender:@"SignIn"];

}

- (void)failedAuthentication
{
    self.warningLabel.alpha = 0.0f;
    self.warningLabel.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        self.warningLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        NSTimer *hideWarnigTimer;
        hideWarnigTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(hideWarningLabel:)
                                                         userInfo:Nil
                                                          repeats:NO];
    }];
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (BOOL)checkForGoodSting:(NSString *)string
{
    return NO;
}



//- (void)checkForAutoLogIn
//{
//    BOOL autoSignIn = [[NSUserDefaults standardUserDefaults] boolForKey:UserAutoSignInStatus];
//    
//    if (autoSignIn)
//    {
//        [self signInAutomatically];
//    } else
//    {
//        NSLog(@"Manual");
//    }
//}
//
//- (void)signInAutomatically
//{
//    NSString *userName =[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserName];
//    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentPassowrd];
//    
//    self.userNameField.text = userName;
//    self.passwordField.text = password;
//    
//    shouldSave = NO;
//    
//    [self.activityindicator startAnimating];
//    self.signInButton.enabled = NO;
//    
//    NSString *stringJSON =[NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\",\"Password\":\"%@\"}}",userName,password];
//    
//    postman = [[Postman alloc] init];
//    postman.delegate = self;
//    [postman post:@"http://ripple-io.in/Account/Authenticate" withParameters:stringJSON];
//    
//    NSLog(@"Automatic");
//}

- (void)animateSubviews
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    self.userNameContainer.transform = CGAffineTransformTranslate(transform, 600, 0);
    self.passwordContainer.transform = CGAffineTransformTranslate(transform, 600, 0);
    self.signInButton.transform = CGAffineTransformTranslate(transform, 0, 480);
    
    [UIView animateWithDuration:1 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.userNameContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1 delay:0.5 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.passwordContainer.transform = CGAffineTransformIdentity;
        self.signInButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

@end
