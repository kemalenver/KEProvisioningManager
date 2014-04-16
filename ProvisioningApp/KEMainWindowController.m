//
//  KEMainWindowController.m
//  ProvisioningApp
//
//  Created by Kemal Enver on 03/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//


#import "KEMainWindowController.h"
#import "KEProvProfile.h"
#import "KEHelpers.h"


@interface KEMainWindowController ()

@end


@implementation KEMainWindowController


- (id) initWithWindow: (NSWindow *) window {
    
    self = [super initWithWindow: window];
    
    if (self) {
    }
    return self;
}


- (void) windowDidLoad {
    
    [super windowDidLoad];
    
    self.tableView.headerView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsEmptySelection = YES;
    
    self.tableView.sortDescriptors = @[
                                       
                                       [NSSortDescriptor sortDescriptorWithKey: @"status" ascending: YES selector: @selector(compare:)],
                                       [NSSortDescriptor sortDescriptorWithKey: @"expDate" ascending: YES selector: @selector(compare:)]
                                       ];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.includedDevicesDelegate = [[KEIncludedDevicesDelegate alloc] init];
    self.devicesTableView.dataSource = self.includedDevicesDelegate;
    self.devicesTableView.delegate = self.includedDevicesDelegate;
    
    [self updateLabels];
    
    [self reloadProfiles];
}


- (void) reloadProfiles {
    
    NSArray *docsPath = [[NSFileManager defaultManager] URLsForDirectory: NSLibraryDirectory inDomains:NSUserDomainMask];
    
    NSURL *libraryPath = docsPath[0];
    
    NSURL *mobilePath = [libraryPath URLByAppendingPathComponent: @"MobileDevice/Provisioning Profiles"];
    
    NSError *error = nil;
    
    NSArray *profileUrls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL: mobilePath
                                                         includingPropertiesForKeys: nil
                                                                            options: NSDirectoryEnumerationSkipsHiddenFiles
                                                                              error: &error];
    if(error) {
        
        NSLog(@"Error: %@", error);
    }
    
    NSMutableArray *profileObjects = [NSMutableArray arrayWithCapacity: profileUrls.count];
    
    for(NSURL *profileURL in profileUrls ) {
        
        KEProvProfile *profileObject = [KEProvProfile new];
        BOOL status = [profileObject updateWithURL: profileURL];
        
        if(status) {
            
            [profileObjects addObject: profileObject];
        }
    }
    
    self.profileList = profileObjects;
    
    [self.tableView reloadData];
}


- (void) delete: (id) sender {
    
    NSIndexSet *indexSet = self.tableView.selectedRowIndexes;
    
    NSArray *stuffToDelete = [self.profileList objectsAtIndexes: indexSet];
    
    for(KEProvProfile *profile in stuffToDelete) {
        
        NSLog(@"Deleting %@", profile.name);
        
        NSError *error = nil;
        //[[NSFileManager defaultManager] removeItemAtURL: profile.path error: &error];
        
        if(error) {
            
            NSLog(@"Error deleting %@", profile.name);
        }
    }
    
    [self.profileList removeObjectsAtIndexes: indexSet];
    
    [self.tableView reloadData];
    
    [self.tableView deselectAll: nil];
}


// Also see security cms -D -i ...


- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.profileList.count;
}


- (id) tableView: (NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    KEProvProfile *currentProfile = self.profileList[row];
    
    if([tableColumn.identifier isEqualToString: @"name"]) {
        
        return currentProfile.name;
    }
    else if([tableColumn.identifier isEqualToString: @"appid"]) {
        
        return currentProfile.appID;
    }
    else if([tableColumn.identifier isEqualToString: @"expdate"]) {
        
        return [dateFormatter stringFromDate: currentProfile.expDate];
    }
    else if([tableColumn.identifier isEqualToString: @"team"]) {
        
        return currentProfile.teamName;
    }
    else if([tableColumn.identifier isEqualToString: @"status"]) {
        
        return currentProfile.status;
    }
    
    return  @"";
}


- (void) tableView: (NSTableView *) tableView sortDescriptorsDidChange: (NSArray *) oldDescriptors {
    
    [self.profileList sortUsingDescriptors: tableView.sortDescriptors];
    
    [tableView reloadData];
}


- (void) tableViewSelectionDidChange: (NSNotification *) aNotification; {
    
    [self updateLabels];
    [self updateDevices];
}


- (void) updateDevices {
    
    KEProvProfile *currentProfile = nil;
    if(self.tableView.selectedRow < self.profileList.count) {
        
        currentProfile = self.profileList[self.tableView.selectedRow];
    }
    
    self.includedDevicesDelegate.devices = currentProfile.devices;
    
    [self.devicesTableView reloadData];
    
    self.deviceCountLabel.stringValue = [NSString stringWithFormat: @"(%lu)", (unsigned long)currentProfile.devices.count];
}


- (void) updateLabels {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    KEProvProfile *currentProfile = nil;
    if(self.tableView.selectedRow < self.profileList.count) {
        
        currentProfile = self.profileList[self.tableView.selectedRow];
    }
    
    if(currentProfile) {
        
        double daysLeft = currentProfile.secondsLeft/(3600*24);
        
        NSString *ttlString = nil;
        
        if(currentProfile.active) {
            
            ttlString = [NSString stringWithFormat: @" (%.0f days until expiry)", daysLeft];

            self.statusLabel.textColor = (daysLeft < 31.0f) ? [NSColor orangeColor] : [KEHelpers colorWithHexValue: 0x34b301];
        }
        else {
            
            daysLeft *= -1;
            ttlString = [NSString stringWithFormat: @" (expired %.0f days ago)", daysLeft];

            self.statusLabel.textColor = [NSColor redColor];
        }
        
        ttlString = [[dateFormatter stringFromDate: currentProfile.expDate] stringByAppendingString: ttlString];
        
        self.nameLabel.stringValue = currentProfile.name;
        self.appIDLabel.stringValue = currentProfile.appID;
        self.expirationLabel.stringValue = ttlString;
        self.creationLabel.stringValue = [dateFormatter stringFromDate: currentProfile.createdDate];
        self.profileIDLabel.stringValue = currentProfile.uuid;
        self.statusLabel.stringValue = currentProfile.active ? @"Active" : @"Expired";
    }
    else {
        
        self.nameLabel.stringValue = @"";
        self.appIDLabel.stringValue = @"";
        self.expirationLabel.stringValue = @"";
        self.creationLabel.stringValue = @"";
        self.profileIDLabel.stringValue = @"";
        self.statusLabel.stringValue = @"";
    }
}


- (IBAction) reloadButtonAction: (id) sender {
    
    [self reloadProfiles];
}


- (IBAction) deleteButtonAction: (id) sender {
    
    [self delete: sender];
}


- (IBAction) exportButtonAction: (id) sender {

}


- (IBAction) showButtonAction: (id) sender {
    
}


- (IBAction) settingsButtonAction: (id) sender {
    
}


- (IBAction) viewCertificateAction: (id) sender {
    
}


@end
