//
//  Contact.m
//  EuLux
//
//  Created by Varghese Simon on 3/19/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "Contact.h"

@implementation Contact

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
