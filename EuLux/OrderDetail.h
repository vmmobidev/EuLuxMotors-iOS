//
//  OrderDetail.h
//  EuLux
//
//  Created by Varghese Simon on 3/24/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetail : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *orderDate;
@property (strong, nonatomic) NSDictionary *detailsInJSON;

@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *status;

@end
