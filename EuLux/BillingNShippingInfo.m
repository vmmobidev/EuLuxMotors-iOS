//
//  BillingNShippingInfo.m
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "BillingNShippingInfo.h"

@implementation BillingNShippingInfo
{
    NSArray *arrayOfKeys;
}

-(id)initWithDetailedDict:(NSDictionary *)details
{
    self = [super init];
    if (self)
    {
        self.numberOfSections = 1;
        self.arrayOfTitles = @[@[@"Billing Contact", @"Shipping Contact"]];
        
        arrayOfKeys = @[@"BillingContactName", @"ShippingContactName"];
        [self getDataAndTitlesFromDict:details[@"Order"][@"BillingNShippingInfo"]];
    }
    
    return self;
}

- (void)getDataAndTitlesFromDict:(NSDictionary *)details
{
    NSMutableArray *mutableCopyOfDatas = [[NSMutableArray alloc] init];
    for (int index = 0; index < [arrayOfKeys count]; index++)
    {
        [mutableCopyOfDatas addObject:details[arrayOfKeys[index]]];
    }
    
    self.arrayOfDatas = @[mutableCopyOfDatas];
}
@end
