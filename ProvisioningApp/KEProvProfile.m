//
//  KEProvProfile.m
//  ProvisioningApp
//
//  Created by Kemal Enver on 04/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import "KEProvProfile.h"


@implementation KEProvProfile


- (BOOL) updateWithURL: (NSURL *) profileURL {
    
    NSDictionary *profileDictionary = [KEProvProfile provisioningProfileAtPath: profileURL];
    
    if(profileDictionary) {
        
        NSDictionary *entitlements = profileDictionary[@"Entitlements"];
        
        self.path = profileURL;
        self.name = profileDictionary[@"Name"];
        self.expDate = profileDictionary[@"ExpirationDate"];
        self.createdDate = profileDictionary[@"CreationDate"];
        self.appID = entitlements[@"application-identifier"];
        self.teamName = profileDictionary[@"TeamName"];
        self.uuid = profileDictionary[@"UUID"];
        
        self.active = [[NSDate date] compare: self.expDate] == NSOrderedAscending;
        
        self.status = self.active ? @"Active" : @"Expired";
        
        NSArray *profileList = profileDictionary[@"ProvisionedDevices"];
        self.devices = profileList;
        
        self.ttl = profileDictionary[@"TimeToLive"];
        
        self.secondsLeft = [self.expDate timeIntervalSinceDate: [NSDate date]];
        
        return YES;
    }
    else {
        
        return NO;
    }
}


+ (NSDictionary *) provisioningProfileAtPath: (NSURL *) pathURL {
    
    // Also see security cms -D -i ...
    
    CMSDecoderRef decoder = NULL;
    CFDataRef dataRef = NULL;
    NSString *plistString = nil;
    NSDictionary *plist = nil;
    
    @try {
        
        CMSDecoderCreate(&decoder);
        NSData *fileData = [NSData dataWithContentsOfURL: pathURL];
        CMSDecoderUpdateMessage(decoder, fileData.bytes, fileData.length);
        CMSDecoderFinalizeMessage(decoder);
        CMSDecoderCopyContent(decoder, &dataRef);
        plistString = [[NSString alloc] initWithData:(__bridge NSData *)dataRef encoding: NSUTF8StringEncoding];
        NSData *plistData = [plistString dataUsingEncoding:NSUTF8StringEncoding];
        plist = [NSPropertyListSerialization propertyListFromData: plistData
                                                 mutabilityOption: NSPropertyListImmutable
                                                           format: nil
                                                 errorDescription: nil];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Could not decode file.\n");
    }
    @finally {
        
        if (decoder) CFRelease(decoder);
        if (dataRef) CFRelease(dataRef);
    }
    
    return plist;
}


@end
