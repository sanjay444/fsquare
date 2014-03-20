//
//  POI.m
//  fsquare
//
//  Created by Sanjay Kumar Mahalingam on 3/20/14.
//  Copyright (c) 2014 Sanjay. All rights reserved.
//

#import "POI.h"

@implementation POI

- (id)init
{
    self = [super init];
    
    return self;
}

- (NSString *)getName
{
    return [NSString stringWithFormat:@"%@ ", self.name];
}

- (NSString *)getAddress
{
    return [NSString stringWithFormat:@"%@ ", self.address];
}


@end
