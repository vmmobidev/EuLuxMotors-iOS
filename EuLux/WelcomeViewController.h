//
//  WelcomeViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/19/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Postman.h"

@interface WelcomeViewController : UIViewController <postmanDelegate>

@property (assign, nonatomic) BOOL logOut;

@end
