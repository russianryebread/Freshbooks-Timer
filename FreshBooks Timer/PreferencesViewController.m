//
//  PreferencesViewController.m
//  FreshBooks Timer
//
//  Created by Ryan Hoshor on 3/9/15.
//  Copyright (c) 2015 FarmSoft Studios. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()

@end

NSUserDefaults *userDefaults;

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    userDefaults = [[NSUserDefaults alloc] init];
    
    NSString *userName = ([[userDefaults objectForKey:@"username"] length]) ? [userDefaults objectForKey:@"username"] : @"";
    NSString *password = [[userDefaults objectForKey:@"password"] length] ? [userDefaults objectForKey:@"password"] : @"";
    
    _userName.stringValue = userName;
    _password.stringValue = password;
}

- (IBAction)closeWindow:(id)sender {
    [self savePrefs:nil];
    [self.view.window orderOut:self];
}

- (IBAction)savePrefs:(id)sender {
    
    [userDefaults setObject:[_userName stringValue] forKey:@"username"];
    [userDefaults setObject:[_password stringValue] forKey:@"password"];
}

#pragma mark - NSTextFieldDelegate Methods

- (void)textDidEndEditing:(NSNotification *)notification {
    [self savePrefs:nil];
}


- (void)textDidChange:(NSNotification *)notification{
    [self savePrefs:nil];
}

@end