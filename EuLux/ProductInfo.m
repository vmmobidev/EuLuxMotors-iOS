//
//  ProductInfo.m
//  EuLux
//
//  Created by Varghese Simon on 3/27/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ProductInfo.h"

@implementation ProductInfo
{
    NSArray *arrayOfKeys;
}

-(id)initWithDetailedDict:(NSDictionary *)details
{
    self = [super init];
    if (self)
    {
        [self getDataAndTitlesFromDict:details[@"Order"][@"Products"]];
    }
    
    return self;
}

- (void)getDataAndTitlesFromDict:(NSArray *)details
{
    NSInteger numberOfSection = 0;
//    NSMutableArray *sectionTitlesArray = [[NSMutableArray alloc] init];
    NSMutableArray *mutableArrayOfTitles = [[NSMutableArray alloc] init];
    NSMutableArray *mutableArrayOfData = [[NSMutableArray alloc] init];
    
    
    for (int indexOfProduct = 0; indexOfProduct < [details count]; indexOfProduct++)
    {
        NSDictionary *oneProduct = details[indexOfProduct];
        numberOfSection++;
        [mutableArrayOfTitles addObject:@[@"VIN", @"MSRP", @"Comm.", @"Discount", @"Sales Tax", @"Total"]];
        
//        NSString *currentSectionTitle = [NSString stringWithFormat:@"%@ - %@ - %@ - %@",oneProduct[@"BrandName"], oneProduct[@"ModelName"], oneProduct[@"Color"], oneProduct[@"ModelYear"]];
//        [sectionTitlesArray addObject:currentSectionTitle];

        
        [mutableArrayOfData addObject:@[oneProduct[@"VIN"],oneProduct[@"MSRP"], oneProduct[@"Commission"], oneProduct[@"Discount"], oneProduct[@"SalesTax"], oneProduct[@"Total"]]];
    }
    
    self.numberOfSections = numberOfSection;
    self.arrayOfTitles = mutableArrayOfTitles;
//    self.arrayOsSectionTitles = sectionTitlesArray;
    self.arrayOfDatas = mutableArrayOfData;
}

- (NSArray *)getSectionTitlesFrom:(NSDictionary *)details
{
    NSArray *detailsArray = details[@"Order"][@"Products"];
    NSMutableArray *sectionTitleArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *oneProduct in detailsArray)
    {
        NSString *currentSectionTitle = [NSString stringWithFormat:@"%@ - %@ - %@ - %@",oneProduct[@"BrandName"], oneProduct[@"ModelName"], oneProduct[@"Color"], oneProduct[@"ModelYear"]];
        [sectionTitleArray addObject:currentSectionTitle];
    }
    
    return sectionTitleArray;
}
@end
