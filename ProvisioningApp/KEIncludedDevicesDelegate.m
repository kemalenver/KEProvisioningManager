//
//  KEIncludedDevicesDelegate.m
//  ProvisioningApp
//
//  Created by Kemal Enver on 08/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import "KEIncludedDevicesDelegate.h"

#import "KEUSBDevices.h"

@implementation KEIncludedDevicesDelegate

- (id) init {
    
    self = [super init];
    
    if(self) {
        
        self.devices = nil;
        
        //list_devices();
    }
    
    return self;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    
    if(self.devices) {
        
        return self.devices.count;
    }
    
    return 0;
}


- (id) tableView: (NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if([tableColumn.identifier isEqualToString: @"devname"]) {
        
        return @"Device Name";
    }
    else {
        
        return self.devices[row];
    }
}


@end
