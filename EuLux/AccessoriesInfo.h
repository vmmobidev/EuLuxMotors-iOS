//
//  AccessoriesInfo.h
//  EuLux
//
//  Created by Varghese Simon on 3/28/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessoriesInfo : NSObject

@property (assign, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) NSArray *arrayOsSectionTitles;
@property (strong, nonatomic) NSArray *arrayOfDatas;
@property (strong, nonatomic) NSArray *arrayOfTitles;


-(id)initWithDetailedDict:(NSDictionary *)details;

- (NSArray *)getSectionTitlesFrom:(NSDictionary *)details;

@end
