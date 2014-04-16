//
//  KEIncludedDevicesDelegate.h
//  ProvisioningApp
//
//  Created by Kemal Enver on 08/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KEIncludedDevicesDelegate : NSObject <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NSArray *devices;

@end
