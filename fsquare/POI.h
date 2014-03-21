//
//  POI.h
//  fsquare
//
//  Created by Sanjay Kumar Mahalingam on 3/20/14.
//  Copyright (c) 2014 Sanjay. All rights reserved.
//  Object for storing the places of interest details

#import <Foundation/Foundation.h>

@interface POI : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (assign, nonatomic) NSInteger zipCode;
@property (assign, nonatomic) NSInteger numberOfPeopleHereNow;
@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger checkInCount;
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) CGFloat longitude;
@property (strong, nonatomic) NSString *foursquareId;
@property (strong, nonatomic) UIImage *image;

- (NSString *)getAddress;
- (NSString *)getName;

@end
