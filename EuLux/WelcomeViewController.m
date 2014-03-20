//
//  WelcomeViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/19/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *rippleImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rippleVrtCentrConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vmokshaBottomConst;
@end

@implementation WelcomeViewController
{
    Postman *postman;
    CATransform3D transform;
    
    BOOL animationCompleted, logInCompleted;
    NSString *segueIdentifer;
    
    int numberOfRipplesleft;
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
    
    animationCompleted = NO;
    logInCompleted = NO;
    
    self.rippleImage.transform = CGAffineTransformMakeTranslation(0, 100);

    [self animateRipple];
    [self startRippleEffect];
    
    self.logOut = NO;
    [self checkForAutoLogIn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.logOut)
    {
        self.logOut = NO;
        [self performSegueWithIdentifier:@"autoSignInFailureSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)checkForAutoLogIn
{
    BOOL autoSignIn = [[NSUserDefaults standardUserDefaults] boolForKey:UserAutoSignInStatus];
    
    if (autoSignIn)
    {
        [self signInAutomatically];
    } else
    {
        NSLog(@"Manual");

        segueIdentifer = @"autoSignInFailureSegue";
//        [self performSegueWithIdentifier:@"autoSignInFailureSegue" sender:self];
        
        logInCompleted = YES;
        [self tryToPerformSegue];
    }
}

- (void)signInAutomatically
{
    NSString *userName =[[NSUserDefaults standardUserDefaults] objectForKey:kSavedUserName];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedPassowrd];
    
    NSString *stringJSON =[NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\",\"Password\":\"%@\"}}",userName,password];
    
    postman = [[Postman alloc] init];
    postman.delegate = self;
    [postman post:@"http://ripple-io.in/Account/Authenticate" withParameters:stringJSON];
    
    NSLog(@"Automatic");
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response
{
    [self postRequestSuccessfulWithObject:response];
}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error
{
    NSLog(@"postman failure : %@",[error userInfo]);
    
    segueIdentifer = @"autoSignInFailureSegue";
    
//    [self performSegueWithIdentifier:@"autoSignInFailureSegue" sender:self];
    
    logInCompleted = YES;
    [self tryToPerformSegue];
}

- (void)postRequestSuccessfulWithObject:(NSData *)responseData
{
    
    NSDictionary *JSONResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    NSDictionary *aaDataDict = JSONResponse[@"aaData"];
    
    NSLog(@"%@",aaDataDict[@"Success"]);
    
    if ([aaDataDict[@"Success"] boolValue])
    {
        NSLog(@"Authentication successful in welcome view");
        segueIdentifer = @"autoSignInSucessSegue";
//        [self performSegueWithIdentifier:@"autoSignInSucessSegue" sender:self];
        logInCompleted = YES;
        [self tryToPerformSegue];
    }else
    {
        NSLog(@"Authentication failed");
        segueIdentifer = @"autoSignInFailureSegue";
//        [self performSegueWithIdentifier:@"autoSignInFailureSegue" sender:self];
        logInCompleted = YES;
        [self tryToPerformSegue];
    }
    
}

- (void)startRippleEffect
{
    numberOfRipplesleft = 4;
    animationCompleted = NO;
    transform = CATransform3DIdentity;
    transform.m34 =  -1.0 / 300.0;
    transform = CATransform3DRotate(transform, M_PI_4, 1, 0, 0);
    transform = CATransform3DScale(transform, .01, .01, .01);
    
    CATransform3D firstTrans = CATransform3DScale(transform, 100, 50, 100);
    CATransform3D secondTrans = CATransform3DScale(transform, 120, 70, 120);
    [self animateView:self.imgView1
         WithDuration:2
                delay:0
        firstTranfrom:firstTrans
      secondTransform:secondTrans];
    
    firstTrans = CATransform3DScale(transform, 80, 45, 80);
    secondTrans = CATransform3DScale(transform, 100, 60, 100);
    [self animateView:self.imgView2
         WithDuration:2
                delay:1
        firstTranfrom:firstTrans
      secondTransform:secondTrans];
    
    firstTrans = CATransform3DScale(transform, 80, 45, 80);
    secondTrans = CATransform3DScale(transform, 90, 55, 90);
    [self animateView:self.imgView3
         WithDuration:2
                delay:2
        firstTranfrom:firstTrans
      secondTransform:secondTrans];
    
    firstTrans = CATransform3DScale(transform, 40, 25, 40);
    secondTrans = CATransform3DScale(transform, 60, 35, 60);
    [self animateView:self.imgView4
         WithDuration:1.5
                delay:3
        firstTranfrom:firstTrans
      secondTransform:secondTrans];
    
}

- (void)animateView:(UIView *)imgView WithDuration:(CGFloat)duration delay:(CGFloat)delay firstTranfrom:(CATransform3D)tran1 secondTransform:(CATransform3D)tran2
{
    imgView.alpha = 0;
    imgView.layer.transform = transform;
    
    [UIView animateWithDuration:duration delay:delay options:(UIViewAnimationOptionCurveLinear) animations:^{
        
        imgView.alpha = 1;
        imgView.layer.transform = tran1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.9 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            
            imgView.alpha = 0;
            imgView.layer.transform = tran2;
            
        } completion:^(BOOL finished) {
            numberOfRipplesleft--;
            
            if (numberOfRipplesleft <= 0)
            {
                animationCompleted = YES;
                [self tryToPerformSegue];
            }
        }];
    }];
}

- (void)animateRipple
{
    [UIView animateWithDuration:1 delay:.5 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.rippleImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tryToPerformSegue
{
    if (logInCompleted && animationCompleted)
    {
        [self animationsBeforeNavigation];
    }
}

- (void)animationsBeforeNavigation
{
//    CGRect frameOfRipple = self.rippleImage.frame;
//    frameOfRipple.origin.x = -300;
//    self.rippleImage.frame = frameOfRipple;
//    
//    
//    CGFloat distanceToMove = 200 + self.view.frame.size.width/2 - self.rippleImage.frame.size.width/2;
//    self.rippleImage.transform = CGAffineTransformMakeTranslation(distanceToMove, 0);

    
    [UIView animateWithDuration:.5 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
//        self.rippleImage.transform = CGAffineTransformIdentity;
        self.rippleVrtCentrConst.constant = 200 + self.view.frame.size.width/2 - self.rippleImage.frame.size.width/2;
        [self.rippleImage layoutIfNeeded];
        self.vmokshaBottomConst.constant = -60;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:segueIdentifer sender:self];
    }];
}

@end
