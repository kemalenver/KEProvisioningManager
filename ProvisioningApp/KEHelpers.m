//
//  KEHelpers.m
//  ProvisioningApp
//
//  Created by Kemal Enver on 04/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import "KEHelpers.h"

@implementation KEHelpers

+ (NSColor *) colorWithHexValue: (NSInteger) rgbValue {
    
    return [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];
    
}

@end
