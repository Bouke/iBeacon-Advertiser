//
//  WAAppDelegate.m
//  iBeacon Advertiser
//
//  Created by Bouke Haarsma on 01-02-14.
//  Copyright (c) 2014 Bouke Haarsma. All rights reserved.
//

#import "WAAppDelegate.h"
#import "BLCBeaconAdvertisementData.h"

@implementation WAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];

    preferences = [NSUserDefaults standardUserDefaults];
    [preferences registerDefaults:@{@"major": @0,
                                    @"minor": @0,
                                    @"power": @-60}];
    // Generate UUID and store it in the preferences
    if(![preferences objectForKey:@"uuid"]) {
        [preferences setObject:[[NSUUID UUID] UUIDString] forKey:@"uuid"];
    }

    [self.uuidField setStringValue:[preferences stringForKey:@"uuid"]];
    [self.majorField setStringValue:[preferences stringForKey:@"major"]];
    [self.minorField setStringValue:[preferences stringForKey:@"minor"]];
    [self.powerField setStringValue:[preferences stringForKey:@"power"]];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)blaAction:(NSTextField *)sender {
}

- (IBAction)stopButtonPressed:(NSButton *)sender {
    [self stopAdvertising];
}

- (IBAction)startButtonPressed:(NSButton *)sender {
    [self startAdvertising];
}

- (BLCBeaconAdvertisementData *)advertisementData {
    [preferences setObject:[self.uuidField stringValue] forKey:@"uuid"];
    [preferences setInteger:[self.majorField integerValue] forKey:@"major"];
    [preferences setInteger:[self.minorField integerValue] forKey:@"minor"];
    [preferences setInteger:[self.powerField integerValue] forKey:@"power"];

    return [[BLCBeaconAdvertisementData alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:[preferences stringForKey:@"uuid"]]
                                                               major:[preferences integerForKey:@"major"]
                                                               minor:[preferences integerForKey:@"minor"]
                                                       measuredPower:[preferences integerForKey:@"power"]];
}

- (void) startAdvertising {
    BLCBeaconAdvertisementData *beaconData = [self advertisementData];
    [peripheralManager startAdvertising:beaconData.beaconAdvertisement];

    [self.progressIndicator startAnimation:nil];
    [self.startButton setHidden:TRUE];
    [self.stopButton setHidden:FALSE];
    [self.uuidField setEnabled:FALSE];
    [self.majorField setEnabled:FALSE];
    [self.minorField setEnabled:FALSE];
    [self.powerField setEnabled:FALSE];
    [self.window makeFirstResponder:self.stopButton];
}

- (void) stopAdvertising {
    [peripheralManager stopAdvertising];

    [self.progressIndicator stopAnimation:nil];
    [self.stopButton setHidden:TRUE];
    [self.startButton setHidden:FALSE];
    [self.uuidField setEnabled:TRUE];
    [self.majorField setEnabled:TRUE];
    [self.minorField setEnabled:TRUE];
    [self.powerField setEnabled:TRUE];
}


/*
 Uses CBCentralManager to check whether the current platform/hardware supports Bluetooth LE. An alert is raised if Bluetooth LE is not enabled or is not supported.
 */
- (BOOL) isLECapableHardware {
    NSString * state = nil;

    switch ([peripheralManager state])
    {
        case CBPeripheralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBPeripheralManagerStatePoweredOn:
            return TRUE;
        case CBPeripheralManagerStateUnknown:
        default:
            return FALSE;

    }

    NSLog(@"Central manager state: %@", state);

    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:state];
    [alert addButtonWithTitle:@"OK"];
    [alert setIcon:[[NSImage alloc] initWithContentsOfFile:@"AppIcon"]];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    return FALSE;
}

#pragma mark - CBPeripheralManager

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    [self.startButton setEnabled: [self isLECapableHardware]];
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"Started advertising");
}

@end
