//
//  AddressInfo.h
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SectionHeaderProtocol <NSObject>

- (void)sectionTitleForTable:(NSString *)headerTitle;

@end

@interface AddressInfo : NSObject

@property (assign, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) NSArray *arrayOsSectionTitles;
@property (strong, nonatomic) NSArray *arrayOfDatas;
@property (strong, nonatomic) NSArray *arrayOfTitles;

- (id)initWithDetailedDict:(NSDictionary *)details;
- (NSArray *)getSectionTitles;

@end
