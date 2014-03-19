//
//  User.m
//  EuLux
//
//  Created by Varghese Simon on 3/17/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "Customer.h"

@implementation Customer

//- (NSString *)website
//{
//    if (_website)
//    {
//        NSRange rangeOfHTTPSubStirng = [_website rangeOfString:@"http://"];
//        if (rangeOfHTTPSubStirng.location == NSNotFound )
//        {
//            _website = [NSString stringWithFormat:@"http://%@",_website];
//        }
//    }
//    return _website;
//}

- (void)setWebsite:(NSString *)website
{
    if (website)
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
