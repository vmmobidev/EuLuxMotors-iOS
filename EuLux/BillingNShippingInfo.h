//
//  BillingNShippingInfo.h
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingNShippingInfo : NSObject

@property (assign, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) NSArray *arrayOsSectionTitles;
@property (strong, nonatomic) NSArray *arrayOfDatas;
@property (strong, nonatomic) NSArray *arrayOfTitles;


-(id)initWithDetailedDict:(NSDictionary *)details;
@end
