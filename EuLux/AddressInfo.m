//
//  AddressInfo.m
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo
{
    NSArray *arrayOfKeys;
}

-(id)initWithDetailedDict:(NSDictionary *)details
{
    self = [super init];
    if (self)
    {
        self.numberOfSections = 2;
        self.arrayOfTitles = @[@[@"Street Line 1",@"Street Line 2", @"City", @"Postal Code", @"State", @"Country"],@[@"Street Line 1",@"Street Line 2", @"City", @"Postal Code", @"State", @"Country"]];
        
        arrayOfKeys = @[@"StreeLine1", @"StreeLine2", @"City", @"PostalCode", @"State", @"Country"];
        
        self.arrayOsSectionTitles = @[@"Billing Address", @"Shipping Address"];
        [self getDataAndTitlesFromDict:details[@"Order"][@"AddressInfo"]];
    }
    
    return self;
}

- (void)getDataAndTitlesFromDict:(NSDictionary *)details
{
    NSDictionary *billingAddress = details[@"BillingAddress"];
    NSMutableArray *mutableCopyOfBilling = [[NSMutableArray alloc] init];
    for (int index = 0; index < [arrayOfKeys count]; index++)
    {
        [mutableCopyOfBilling addObject:billingAddress[arrayOfKeys[index]]];
    }
    
    NSDictionary *shippingAddress = details[@"ShippingAddress"];
    NSMutableArray *mutableCopyOfShipping = [[NSMutableArray alloc] init];
    for (int index = 0; index < [arrayOfKeys count]; index++)
    {
        [mutableCopyOfShipping addObject:shippingAddress[arrayOfKeys[index]]];
    }
    
    self.arrayOfDatas = @[mutableCopyOfBilling, mutableCopyOfShipping];
}

- (NSArray *)getSectionTitles
{
    NSArray *arrayOfSectionTitles = @[@"Billing Address", @"Shipping Address"];
    
    return arrayOfSectionTitles;
}
@end
