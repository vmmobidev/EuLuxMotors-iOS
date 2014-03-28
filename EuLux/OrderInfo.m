//
//  OrderInfo.m
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo
{
    NSArray *arrayOfKeys;
}

-(id)initWithDetailedDict:(NSDictionary *)details
{
    self = [super init];
    if (self)
    {
        self.numberOfSections = 1;
        self.arrayOfTitles = @[@[@"Order No", @"Order Date", @"Need by Date", @"Status", @"Sales Rep.", @"Broker"]];
        
        arrayOfKeys = @[@"OrderNumber", @"OrderDate", @"NeedByDate", @"StatusName", @"SalesRepName", @"BrokerName"];
        [self getDataAndTitlesFromDict:details[@"Order"][@"OrderInfo"]];
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
