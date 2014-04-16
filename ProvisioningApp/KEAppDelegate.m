//
//  KEAppDelegate.m
//  ProvisioningApp
//
//  Created by Kemal Enver on 03/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import "KEAppDelegate.h"
#import "KEMainWindowController.h"

@implementation KEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.mainWindowController = [[KEMainWindowController alloc] initWithWindowNibName: @"KEMainWindowController"];
    
    [self.mainWindowController showWindow: self];
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    
    return YES;
}

@end
