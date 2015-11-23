//
//  Utilities.m
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//

#import "Utilities.h"

@implementation Utilities


+ (NSString *)checknull :(NSString *)value
{
    if(value==(id)[NSNull null])
    {
        return @"";
    }
    else if(value==nil||[value isEqualToString:@""]||[value isEqualToString:@"(null)"]||[value length]==0||(value == (id)[NSNull null])||[value isEqualToString:@"null"] || [value isEqualToString:@"<null>"])
    {
        return @"";
    }
    else
    {
        return value;
    }
}

+(BOOL)CheckReachability
{
    // check the network Staus
    NetworkStatusApple status;
    ReachabilityApple *reachability=[ReachabilityApple reachabilityForInternetConnection];
    status=[reachability currentReachabilityStatus];
    
    if (status==NotReachable)
    {
        return NO;
    }
    
    return YES;
    
}

@end
