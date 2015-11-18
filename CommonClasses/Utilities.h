//
//  Utilities.h
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReachabilityApple.h"

@interface Utilities : NSObject

+ (NSString *)checknull :(NSString *)value;
+(float) calculte_height: (float)width :(NSString *)str_desc;
+(BOOL)CheckReachability;

@end
