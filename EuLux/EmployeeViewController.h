//
//  EmployeeViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeViewController : UIViewController<UITableViewDataSource>

@property (strong,nonatomic)NSMutableArray *arrayOfEmpNames;
@property (strong,nonatomic)NSMutableArray *arrayOfEmpId;

@end
