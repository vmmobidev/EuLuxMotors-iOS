//
//  Contact.h
//  EuLux
//
//  Created by Varghese Simon on 3/19/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *categoryCode;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *moblie;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *address;

@end
