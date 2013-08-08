//
//  AppDelegate.m
//  ContactSync
//
//  Created by Jack Dubie on 8/5/13.
//  Copyright (c) 2013 Jack Dubie. All rights reserved.
//

#import "AppDelegate.h"

#import <Dropbox/Dropbox.h>
#import "ButtonViewController.h"
#import "SyncStatusViewController.h"

#define APP_KEY @"bqc1ih1bbpcboui"
#define APP_SECRET @"gwav1zwmo35cf88"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*
     * Create a DBAccountManager object. This object lets you link to a Dropbox
     * user's account which is the first step to working with data on their
     * behalf.
     */
    
    DBAccountManager* accountMgr = [[DBAccountManager alloc]
                                    initWithAppKey:APP_KEY
                                    secret:APP_SECRET];
    [DBAccountManager setSharedManager:accountMgr];
    
    
    /*
     * Skip directly to test if user has already linked their account
     */
    
    UIViewController *controller;
    if (accountMgr.linkedAccount) {
        controller = [self getSyncStatusControllerWithAccount:accountMgr.linkedAccount];
    } else {
        controller = [ButtonViewController new];
    }
    
    self.window.rootViewController = controller;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

/*
 * You'll need to handle requests sent to your app from the linking dialog
 */

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation
{
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        NSLog(@"App linked successfully!");
        
        self.window.rootViewController = [self getSyncStatusControllerWithAccount:account];        
        
        return YES;
    }
    return NO;
}

- (SyncStatusViewController *)getSyncStatusControllerWithAccount:(DBAccount *)account
{
    SyncStatusViewController *result = [SyncStatusViewController new];
    result.account = account;
    return result;
}

@end
