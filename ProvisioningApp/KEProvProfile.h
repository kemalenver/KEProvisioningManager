//
//  KEProvProfile.h
//  ProvisioningApp
//
//  Created by Kemal Enver on 04/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KEProvProfile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *expDate;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSURL *path;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, strong) NSNumber *ttl;
@property (nonatomic, assign) NSTimeInterval secondsLeft;

- (BOOL) updateWithURL: (NSURL *) profileURL;

+ (NSDictionary *) provisioningProfileAtPath: (NSURL *) pathURL;

@end
