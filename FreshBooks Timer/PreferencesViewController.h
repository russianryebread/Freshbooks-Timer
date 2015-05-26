//
//  PreferencesViewController.h
//  FreshBooks Timer
//
//  Created by Ryan Hoshor on 3/9/15.
//  Copyright (c) 2015 FarmSoft Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesViewController : NSViewController <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSSecureTextField *password;
@property (strong) IBOutlet NSView *view;


- (IBAction)closeWindow:(id)sender;
- (IBAction)savePrefs:(id)sender;

@end