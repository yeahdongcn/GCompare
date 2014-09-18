//
//  OCTExtendedUser.m
//  GCompare
//
//  Created by R0CKSTAR on 14/9/17.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "OCTExtendedUser.h"

@implementation OCTExtendedUser

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dictionary = @{@"followers": @"followers",
                                 @"following": @"following",
                                 @"publicGists": @"public_gists",
                                 @"publicRepos": @"public_repos",
                                 };
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:dictionary];
}

@end
