//
//  ServicesInfo.m
//  EuLux
//
//  Created by Varghese Simon on 3/28/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ServicesInfo.h"

@implementation ServicesInfo

{
    NSArray *arrayOfKeys;
}

-(id)initWithDetailedDict:(NSDictionary *)details
{
    self = [super init];
    if (self)
    {
        [self getDataAndTitlesFromDict:details[@"Order"][@"Services"]];
    }
    
    return self;
}

- (void)getDataAndTitlesFromDict:(NSArray *)details
{
    NSInteger numberOfSection = 0;
//    NSMutableArray *sectionTitlesArray = [[NSMutableArray alloc] init];
    NSMutableArray *mutableArrayOfTitles = [[NSMutableArray alloc] init];
    NSMutableArray *mutableArrayOfData = [[NSMutableArray alloc] init];
    
    
    for (int indexOfService = 0; indexOfService < [details count]; indexOfService++)
    {
        NSDictionary *oneService = details[indexOfService];
        numberOfSection++;
        [mutableArrayOfTitles addObject:@[@"UnitPrice", @"Total"]];
        
//        NSString *currentSectionTitle = [NSString stringWithFormat:@"%@ - %@ - %@ - %@",oneService[@"BrandName"], oneService[@"ModelName"], oneService[@"Color"], oneService[@"ModelYear"]];
//        [sectionTitlesArray addObject:currentSectionTitle];
        

        
        [mutableArrayOfData addObject:@[oneService[@"UnitPrice"],oneService[@"Total"]]];
    }
    
    self.numberOfSections = numberOfSection;
    self.arrayOfTitles = mutableArrayOfTitles;
//    self.arrayOsSectionTitles = sectionTitlesArray;
    self.arrayOfDatas = mutableArrayOfData;
}

- (NSArray *)getSectionTitlesFrom:(NSDictionary *)details
{
    NSArray *detailsArray = details[@"Order"][@"Services"];
    NSMutableArray *sectionTitleArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *oneServices in detailsArray)
    {
        [sectionTitleArray addObject:oneServices[@"Name"]];
    }
    
    return sectionTitleArray;
}

@end
