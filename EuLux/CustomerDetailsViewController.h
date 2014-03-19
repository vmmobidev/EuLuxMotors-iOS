//
//  CustomerDetailsViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/17/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Postman.h"


@interface CustomerDetailsViewController : UIViewController <postmanDelegate>

@property (assign, nonatomic) NSInteger userID;

@end
