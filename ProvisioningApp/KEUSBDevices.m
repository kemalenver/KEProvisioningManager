//
//  KEUSBDevices.m
//  ProvisioningApp
//
//  Created by Kemal Enver on 09/04/2014.
//  Copyright (c) 2014 Kemal Enver. All rights reserved.
//

#import "KEUSBDevices.h"

#include <CoreFoundation/CoreFoundation.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/IOMessage.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>

@implementation KEUSBDevices

#define kAppleVendorID 1452


int list_devices(void){
    
    
    CFMutableDictionaryRef matchingDict;
    io_iterator_t iter;
    kern_return_t kr;
    io_service_t device;
    CFNumberRef numberRef;
    long usbVendor = kMyVendorID;
    
    /* set up a matching dictionary for the class */
    matchingDict = IOServiceMatching(kIOUSBDeviceClassName);    // Interested in instances of class
    // IOUSBDevice and its subclasses
    if (matchingDict == NULL) {
        fprintf(stderr, "IOServiceMatching returned NULL.\n");
        return -1;
    }
    
    // We are interested in all USB devices (as opposed to USB interfaces).  The Common Class Specification
    // tells us that we need to specify the idVendor, idProduct, and bcdDevice fields, or, if we're not interested
    // in particular bcdDevices, just the idVendor and idProduct.  Note that if we were trying to match an
    // IOUSBInterface, we would need to set more values in the matching dictionary (e.g. idVendor, idProduct,
    // bInterfaceNumber and bConfigurationValue.
    
    // Create a CFNumber for the idVendor and set the value in the dictionary
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &usbVendor);
    CFDictionarySetValue(matchingDict,
                         CFSTR(kUSBVendorID),
                         numberRef);
    CFRelease(numberRef);
    numberRef = NULL;
    
    
    // NEW STUFF
    long vid = 1452; //Apple vendor ID
    CFNumberRef refVendorId = CFNumberCreate (kCFAllocatorDefault, kCFNumberIntType, &vid);
    CFDictionarySetValue (matchingDict, CFSTR ("idVendor"), refVendorId);
    CFRelease(refVendorId);
    //all product by same vendor
    CFDictionarySetValue (matchingDict, CFSTR ("idProduct"), CFSTR("*"));
    
    
    
    /* Now we have a dictionary, get an iterator.*/
    kr = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iter);
    if (kr != KERN_SUCCESS)
        return -1;
    
    /* iterate */
    while ((device = IOIteratorNext(iter))) {
        
        io_name_t       deviceName;
        CFStringRef     deviceNameAsCFString;
        
        
        io_name_t       deviceID;
        CFStringRef     deviceIDAsCFString;
        
        /* do something with device, eg. check properties */
        /* ... */
        /* And free the reference taken before continuing to the next item */
        
        // Get the USB device's name.
        kr = IORegistryEntryGetName(device, deviceName);
        if (KERN_SUCCESS != kr) {
            
            deviceName[0] = '\0';
        }
        
        deviceNameAsCFString = CFStringCreateWithCString(kCFAllocatorDefault, deviceName,
                                                         kCFStringEncodingASCII);
        
        

        
        device->get
        
        // Dump our data to stderr just to see what it looks like.
        fprintf(stderr, "deviceName: ");
        CFShow(deviceNameAsCFString);
        
        IOObjectRelease(device);
    }
    
    /* Done, release the iterator */
    IOObjectRelease(iter);
    
    return 1;
}

@end
