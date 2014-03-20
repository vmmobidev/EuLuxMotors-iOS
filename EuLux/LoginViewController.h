//
//  ViewController.h
//  EuLux
//
//  Created by Varghese Simon on 2/28/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Postman.h"

@interface LoginViewController : UIViewController <postmanDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end
