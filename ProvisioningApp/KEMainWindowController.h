//
//  KEMainWindowController.h
//  ProvisioningApp
//
//  Created by Kemal Enver on 03/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KEMainWindowController.h"
#import "KEIncludedDevicesDelegate.h"

@interface KEMainWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, NSToolbarDelegate>

@property (nonatomic, strong) IBOutlet NSTableView *tableView;

@property (nonatomic, strong) NSMutableArray *profileList;

@property (nonatomic, strong) IBOutlet NSToolbarItem *refreshItem;

@property (nonatomic, strong) IBOutlet NSTableView *devicesTableView;


@property (nonatomic, strong) KEIncludedDevicesDelegate *includedDevicesDelegate;

@property (nonatomic, strong) IBOutlet NSTextField *deviceCountLabel;

@property (nonatomic, strong) IBOutlet NSTextField *statusLabel;
@property (nonatomic, strong) IBOutlet NSTextField *nameLabel;
@property (nonatomic, strong) IBOutlet NSTextField *creationLabel;
@property (nonatomic, strong) IBOutlet NSTextField *expirationLabel;
@property (nonatomic, strong) IBOutlet NSTextField *profileIDLabel;
@property (nonatomic, strong) IBOutlet NSTextField *appIDLabel;

@end
