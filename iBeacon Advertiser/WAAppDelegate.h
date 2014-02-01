//
//  WAAppDelegate.h
//  iBeacon Advertiser
//
//  Created by Bouke Haarsma on 01-02-14.
//  Copyright (c) 2014 Bouke Haarsma. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

@interface WAAppDelegate : NSObject <NSApplicationDelegate, CBPeripheralManagerDelegate>
{
    CBPeripheralManager *peripheralManager;
    NSUserDefaults *preferences;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *uuidField;
@property (weak) IBOutlet NSTextField *majorField;
@property (weak) IBOutlet NSTextField *minorField;
@property (weak) IBOutlet NSTextField *powerField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *startButton;

- (IBAction)stopButtonPressed:(NSButton *)sender;
- (IBAction)startButtonPressed:(NSButton *)sender;

@end
