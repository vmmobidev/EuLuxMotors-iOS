//
//  AnEmployeeViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnEmployeeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSNumber *employeeID;

@end
