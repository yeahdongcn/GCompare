//
//  ExtendedUser.m
//  GCompare
//
//  Created by R0CKSTAR on 14/9/17.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "OCTClient+ExtendedUser.h"
#import "OCTExtendedUser.h"
#import "OCTClient+Private.h"
#import "RACSignal+OCTClientAdditions.h"

@implementation OCTClient (ExtendedUser)

- (RACSignal *)fetchExtendedUserInfo {
    return [[self enqueueUserRequestWithMethod:@"GET"
                                  relativePath:@""
                                    parameters:nil
                                   resultClass:OCTExtendedUser.class] oct_parsedResults];
}

@end
