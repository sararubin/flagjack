//
//  FJGlobalData.m
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJGlobalData.h"

@implementation FJGlobalData

static FJGlobalData *shared = nil;
NSString *authCode = @"&&^#guer16n";

+ (FJGlobalData *)shared {
    if (shared == nil) {
        shared = [[super allocWithZone:NULL] init];
    }
	
    return shared;
}

@end
