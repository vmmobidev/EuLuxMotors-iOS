//
//  InventoryItemViewController.h
//  EuLux
//
//  Created by Varghese Simon on 3/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *itemsToShow;

@end
