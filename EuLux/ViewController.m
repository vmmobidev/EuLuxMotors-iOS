//
//  ViewController.m
//  EuLux
//
//  Created by Varghese Simon on 2/28/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ViewController.h"
//#import "AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation ViewController
{
    Postman *postman;
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
    
    postman = [[Postman alloc] init];
    
    
    
    self.userNameField.text = @"surajm@vmokshagroup.com";
    self.passwordField.text = @"suraj";
    
//    NSMutableArray *namesArray =[NSMutableArray new];
//
//    for (int i = 1; i < 15; i++)
//    {
//        NSString *fileName = [NSString stringWithFormat:@"%i.png",i];
//        UIImage *image = [UIImage imageNamed:fileName];
//        [namesArray addObject:image];
//    }
//    
//    self.testImageView.animationDuration = 2;
//    self.testImageView.animationImages = namesArray;
//    self.testImageView.animationRepeatCount = 100;
//    
//    [self.testImageView startAnimating];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)returnKeyPressed:(id)sender
{
    [(UITextField *)sender resignFirstResponder];
}

- (IBAction)signIn:(id)sender
{
    
    if ((self.userNameField.text.length && self.passwordField.text.length) ==0)
    {
        self.userNameLable.alpha = 0.0f;
        self.userNameLable.hidden = NO;
        
        [UIView animateWithDuration:.5 animations:^{
            self.userNameLable.alpha = 1.0f;
        } completion:^(BOOL finished) {
            NSTimer *hideWarnigTimer;
            hideWarnigTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideuserNameLable:) userInfo:Nil repeats:NO];
        }];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = requestSerializer;
    
    NSString *stringJSON =[NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\",\"Password\":\"%@\"}}",self.userNameField.text,self.passwordField.text];
    
    NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:[stringJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:Nil];

    [self.activityindicator startAnimating];
    self.signInButton.enabled = NO;
    [manager POST:@"http://ripple-io.in/Account/Authenticate"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self.activityindicator stopAnimating];
              
             // NSLog(@"%@",responseObject);
              NSData *responseData = [operation responseData];
              [self postRequestSuccessfulWithObject:responseData];
              self.signInButton.enabled = YES;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",error);
        [self.activityindicator stopAnimating];
        self.signInButton.enabled = YES;

    }];
//    NSString *stringJSON =[NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\",\"Password\":\"%@\"}}",self.userNameField.text,self.passwordField.text];
//
//    [self.activityindicator startAnimating];
//    [postman post:@"http://ripple-io.in/Account/Authenticate" withParameters:stringJSON];
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

@end
