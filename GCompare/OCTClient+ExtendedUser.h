//
//  ExtendedUser.h
//  GCompare
//
//  Created by R0CKSTAR on 14/9/17.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "OCTClient.h"

@interface OCTClient (ExtendedUser)

- (RACSignal *)fetchExtendedUserInfo;

@end
