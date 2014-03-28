//
//  OrderListDetailsViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/24/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"

@interface OrderListDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) OrderDetail *selectedOrderDetail;

@end
