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
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:@"cookies"];
    [defaults synchronize];
}

- (void)loadCookies
{
    NSArray *cookies  = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"cookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage setCookie: cookie];
    }
}

- (void) loadSavedInfo {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    
    NSString *userName = ([[userDefaults objectForKey:@"username"] length]) ? [userDefaults objectForKey:@"username"] : @"";
    NSString *password = [[userDefaults objectForKey:@"password"] length] ? [userDefaults objectForKey:@"password"] : @"";
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value = '%@'; document.getElementById('password').value = '%@';", userName, password]];
    
//    if([userName length] && [password length])
//        [self login];
    
    // Set dock update.
    [NSTimer scheduledTimerWithTimeInterval: 1.0
                                     target: self
                                   selector: @selector(getTime)
                                   userInfo: nil
                                    repeats: YES];
}

- (void) login {
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('form_login').submit()"];
}

-(void) getTime {
    NSString *hours = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('timer-clock-hours').innerHTML"];
    NSString *minutes = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('timer-clock-minutes').innerHTML"];
    NSString *seconds = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('timer-clock-seconds').innerHTML"];
    
    NSString *dockLabel = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
    
    // Hours
    //NSString *hours = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('hours').value"];
    
    if(![dockLabel isEqualToString:_badgeContents]){
        _badgeContents = dockLabel;
        [[[NSApplication sharedApplication] dockTile]setBadgeLabel:_badgeContents];
    }
}

-(void)viewDidDisappear {
    [self saveCookies];
}

# pragma mark - WebView Delegate Methods

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    [self loadSavedInfo];
}

@end
