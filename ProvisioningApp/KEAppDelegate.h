//
//  KEAppDelegate.h
//  ProvisioningApp
//
//  Created by Kemal Enver on 03/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KEMainWindowController.h"

@interface KEAppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) KEMainWindowController *mainWindowController;

@end
