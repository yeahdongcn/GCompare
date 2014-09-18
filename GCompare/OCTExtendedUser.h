//
//  OCTExtendedUser.h
//  GCompare
//
//  Created by R0CKSTAR on 14/9/17.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "OCTUser.h"

@interface OCTExtendedUser : OCTUser

@property (nonatomic, assign, readonly) NSUInteger followers;

@property (nonatomic, assign, readonly) NSUInteger following;

@property (nonatomic, assign, readonly) NSUInteger publicGists;

@property (nonatomic, assign, readonly) NSUInteger publicRepos;

@end
