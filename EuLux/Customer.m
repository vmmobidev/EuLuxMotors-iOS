//
//  User.m
//  EuLux
//
//  Created by Varghese Simon on 3/17/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "Customer.h"

@implementation Customer

- (void)setWebsite:(NSString *)website
{
    if ([website isKindOfClass:[NSString class]])
    {
        NSRange rangeOfHTTPSubStirng = [website rangeOfString:@"http://"];
        if (rangeOfHTTPSubStirng.location == NSNotFound )
        {
            website = [NSString stringWithFormat:@"http://%@",website];
        }
        
        _website = website;
    }
}

@end
