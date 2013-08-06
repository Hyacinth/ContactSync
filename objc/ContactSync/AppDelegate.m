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
#import "AddressBook/AddressBook.h"

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

  ButtonViewController *controller = [ButtonViewController new];

  self.window.rootViewController = controller;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  /*
   * Skip directly to test if user has already linked their account
   */

  if (accountMgr.linkedAccount) {
    [self doDropboxTestWithAccount:accountMgr.linkedAccount];
  }

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

    [self doDropboxTestWithAccount:account];

    return YES;
  }
  return NO;
}

- (void)doDropboxTestWithAccount:(DBAccount *)account
{
  DBDatastore *store = [DBDatastore openDefaultStoreForAccount:account error:nil];
  DBTable *contactsTable = [store getTable:@"contacts"];

  NSLog(@"starting test");

  ABAddressBookRef addressBook = ABAddressBookCreate();

  CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
  CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);

  for (CFIndex personIndex = 0; personIndex < nPeople; personIndex++) {
    ABRecordRef person = CFArrayGetValueAtIndex(allPeople, personIndex);
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

    NSLog(@"%@ %@", firstName, lastName);

    /*
     * Iterate over phone numbers
     */
    NSMutableArray *numbers = [[NSMutableArray alloc] initWithCapacity:ABMultiValueGetCount(phones)];
    for (CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
      NSString *number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
      [numbers addObject:number];
      NSLog(@"%@", number);
    }

    [contactsTable insert:@{ @"firstName": firstName, @"lastName": lastName, @"numbers": numbers }];

    CFRelease(phones);
  }
  CFRelease(allPeople);
  CFRelease(addressBook);

  DBError *error;
  if (![store sync:&error]) {
    NSLog(@"error: %@", [error description]);
  }

  NSLog(@"Done");

  /*
   * Print out contents of Datastore
   */
  // NSArray *results = [contactsTable query:@{ } error:nil];
  // for (DBRecord *elem in results){
  //   NSLog(elem[@"firstName"]);
  // }
}

//- (void)startSignificantChangeUpdates
//{
//  // Create the location manager if this object does not
//  // already have one.
//  if (nil == locationManager)
//    locationManager = [[CLLocationManager alloc] init];
//
//  locationManager.delegate = self;
//  [locationManager startMonitoringSignificantLocationChanges];
//}
//
//// Delegate method from the CLLocationManagerDelegate protocol.
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//  // TODO get account
//  [self syncContactsWithAccount:account];
//}

@end
