//
//  OrderDetailsViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"

@interface OrderDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) OrderDetail *selectedOrder;
@property (assign, nonatomic) NSInteger sectionOfDetail;

@end
