//
//  ViewController.m
//  FreshBooks Timer
//
//  Created by Ryan Hoshor on 2/26/15.
//  Copyright (c) 2015 FarmSoft Studios. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCookies];
    
    // Get custom URL
    NSString *urlFromSettings;
    NSString *commonDictionaryPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    if (commonDictionaryPath)  {
        urlFromSettings = [[[NSDictionary alloc] initWithContentsOfFile:commonDictionaryPath] objectForKey:@"URL"];
    }
    
    
    [_webView setMainFrameURL:[NSString stringWithFormat:@"https://%@.freshbooks.com/internal/timesheet/timer", urlFromSettings]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)saveCookies
{
    NSData         *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:@"cookies"];
    [defaults synchronize];
}

- (void)loadCookies
{
    NSArray             *cookies       = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"cookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage setCookie: cookie];
    }
}

-(void)viewDidDisappear {
    [self saveCookies];
}

@end
