//
//  InventoryObject.h
//  EuLux
//
//  Created by Varghese Simon on 3/10/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryObject : NSObject

@property (assign, nonatomic) NSInteger invID;
@property (strong, nonatomic) NSString *inventoryCode;
@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *transmissionName;
@property (strong, nonatomic) NSString *colorName;
@property (strong, nonatomic) NSString *yearOfManufacture;
@property (strong, nonatomic) NSString *supplierName;
@property (strong, nonatomic) NSString *supplierURLString;
@property (assign, nonatomic) float MSRP;

@end
