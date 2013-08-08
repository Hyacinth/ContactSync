//
//  SyncStatusViewController.m
//  ContactSync
//
//  Created by Jack Dubie on 8/7/13.
//  Copyright (c) 2013 Jack Dubie. All rights reserved.
//

#import "SyncStatusViewController.h"
#import "AddressBook/AddressBook.h"

@interface SyncStatusViewController ()

@end

@implementation SyncStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doDropboxTestWithAccount:self.account];
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
