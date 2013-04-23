//
//  KWContactsManager.m
//  Kiwi
//
//  Created by Christian Hatch on 3/8/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKContactsManager.h"
#import <AddressBook/AddressBook.h>

#define KWContactsFinishedParsingNotification   @"contactsFinishedParsing"

@interface AIKContactsManager ()
@property (nonatomic) dispatch_queue_t addressBookQueue;
@property (nonatomic, strong) NSMutableArray *allContactsWithoutPictures; 
@end

@implementation AIKContactsManager
@synthesize allContacts = _allContacts, searchResults = _searchResults, addressBookQueue = _addressBookQueue, sortedContacts = _sortedContacts, matchedContacts = _matchedContacts, allContactsWithoutPictures = _allContactsWithoutPictures, noMatchedContacts = _noMatchedContacts; 

+ (AIKContactsManager *)sharedManager{
    static AIKContactsManager *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[AIKContactsManager alloc] init];
    });
    return sharedID;
}
-(dispatch_queue_t)addressBookQueue{
    if (!_addressBookQueue) {
        _addressBookQueue = dispatch_queue_create("com.acacia.addressbook.processingqueue", NULL); 
    }
    return _addressBookQueue; 
}
+(BOOL)isAuthorized{
    if (IOS_6_OR_GREATER) {
        __block BOOL authorized = NO;
//        dispatch_sync(dispatch_get_main_queue(), ^{
            ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
            switch (ABAddressBookGetAuthorizationStatus()) {
                case kABAuthorizationStatusAuthorized:{
                    authorized = YES; 
                }break;
                case kABAuthorizationStatusNotDetermined:{
                    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                        if (granted){
                            authorized = YES;
                        }else{
                            authorized = NO;
                        }
                    });
                }break;
                case kABAuthorizationStatusDenied:{
                    authorized = NO;
                    UIAlertView *errr = [[UIAlertView alloc] initWithTitle:@"Kiwi isn't authorized to access your contacts :(" message:@"Authorize Kiwi by going to Settings > Privacy > Contacts > and turn on Kiwi" cancelButtonItem:[RIButtonItem randomDismissalButton] otherButtonItems:nil, nil];
                    [errr show];
                }break;
                case kABAuthorizationStatusRestricted:{
                    authorized = NO;
                    UIAlertView *errr = [[UIAlertView alloc] initWithTitle:@"Kiwi isn't authorized to access your contacts :(" message:@"Parental Controls are restricting Kiwi from accessing your contacts. Please contact your IT manager to remove these restrictions" cancelButtonItem:[RIButtonItem randomDismissalButton] otherButtonItems:nil, nil];
                    [errr show];
                }break;
            }
//        });
        return authorized;
    }else{
        return YES; 
    }
}
+(BOOL)checkAuthorization{
    return ABAddressBookGetAuthorizationStatus();
}
-(void)parseAndSortContacts{
    [self parseContacts];
}
-(void)parseContacts{
    dispatch_async(self.addressBookQueue, ^{
        NSMutableArray *contacts = [NSMutableArray array];
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        
        
        for (int i = 0; i < nPeople; i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            if (person != nil) {
                NSMutableDictionary *personDict = [NSMutableDictionary dictionary];
                
                NSString *firstname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                if (!firstname) {
                    firstname = @" ";
                }
                [personDict setObject:firstname forKey:@"firstname"];
                
                NSString *lastname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
                if (!lastname) {
                    lastname = @" ";
                }
                [personDict setObject:lastname forKey:@"lastname"];

                if (ABPersonHasImageData(person)) {
                    CFDataRef pic = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
                    UIImage *picture = [UIImage imageWithData:CFBridgingRelease(pic)];
                    [personDict setObject:picture forKey:@"pic"];
                }
                
                
                ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                NSMutableArray *emailsArray = [NSMutableArray array];
                for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
                    CFStringRef eAddress = ABMultiValueCopyValueAtIndex(emails, i);
                    NSString *emailAddress = CFBridgingRelease(eAddress);
                    [emailsArray addObject:emailAddress];
                }
                if (emailsArray.count > 0) {
                    [personDict setObject:emailsArray forKey:@"emails"]; 
                }
                
                
                ABMultiValueRef urls = ABRecordCopyValue(person, kABPersonURLProperty);
                if (ABMultiValueGetCount(urls) > 0) {
                    for (int i = 0; i < ABMultiValueGetCount(urls); i++) {
                        CFStringRef label = ABMultiValueCopyLabelAtIndex(urls, i);
                        if (label) {
                            if (CFStringCompare(label, kABPersonHomePageLabel, 0) == 0) {
                                CFStringRef homePage = ABMultiValueCopyValueAtIndex(urls, i);
                                NSString *fbid = CFBridgingRelease(homePage);
                                if ([fbid hasPrefix:@"fb://profile/"]) {
                                    fbid = [fbid stringByReplacingOccurrencesOfString:@"fb://profile/" withString:@""];
                                    [personDict setObject:fbid forKey:@"facebookid"];
                                    break;
                                }
                            }
                        }
                    }
                }
                [contacts addObject:personDict];
            }
        }

//    DLog(@"contacts %@", contacts);
        
        NSMutableArray *nonDupes = [NSMutableArray arrayWithCapacity:contacts.count];
        for (NSDictionary *dict in contacts) {
            if (dict.count > 0) {
                [nonDupes addObject:dict];
            }
        }
        self.allContacts = nonDupes;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWContactsFinishedParsingNotification object:self];
        [self sortContactsIntoSections]; 
    });
}
-(void)sortContactsIntoSections{
    dispatch_async(self.addressBookQueue, ^{
        NSMutableDictionary *sorted = [NSMutableDictionary dictionaryWithCapacity:[NSArray alphabet].count];
        NSMutableArray *nonLetters = [NSMutableArray array];
        for (NSString *letter in [NSArray alphabet]) {
            NSMutableArray *section = [NSMutableArray array]; 
            for (NSDictionary *personDict in self.allContacts) {
                NSString *firstname = [personDict objectForKeyNotNull:@"firstname"];
                if (![firstname startsWithAlphabeticalLetter]){
                    [nonLetters addObject:personDict];
                }else if ([firstname hasPrefix:letter]) {
                    [section addObject:personDict];
                }
            }
            [sorted setObject:section forKey:letter];
        }
        [sorted setObject:nonLetters forKey:@"#"];
        self.sortedContacts = sorted;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWContactsAvailableNotification object:self];
    });
}
-(void)searchContactsWithString:(NSString *)searchTerm{
    if (searchTerm == nil) {
        [self.searchResults removeAllObjects];
    }else{
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"(firstname BEGINSWITH[cd] $SEARCH_TERM) OR (lastname BEGINSWITH[cd] $SEARCH_TERM)"];
        
        NSPredicate *predicate = [predicateTemplate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:searchTerm forKey:@"SEARCH_TERM"]];
        
        self.searchResults = [NSMutableArray arrayWithArray:[self.allContacts filteredArrayUsingPredicate:predicate]];
        
        DLog(@"search results %@", self.searchResults);
    }
}
-(void)removeAllPictures{
    dispatch_async(self.addressBookQueue, ^{
        NSMutableArray *noPics = [NSMutableArray arrayWithCapacity:self.allContacts.count];
        for (NSDictionary *person in self.allContacts) {
            if ([person objectForKeyNotNull:@"pic"]) {
                NSMutableDictionary *muPerson = [NSMutableDictionary dictionaryWithDictionary:person];
                [muPerson removeObjectForKey:@"pic"];
                [noPics addObject:muPerson];
            }else{
                [noPics addObject:person]; 
            }
        }
        self.allContactsWithoutPictures = noPics;
        [self prefetchKiwiFriends]; 
    });
}
-(void)prefetchKiwiFriends{
    if (self.allContactsWithoutPictures.count == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prefetchKiwiFriends) name:KWContactsFinishedParsingNotification object:self];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:KWContactsFinishedParsingNotification object:self
         ];
        if (IOS_6_OR_GREATER) {
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
//                [[WaxAPIClient sharedClient] matchContacts:self.allContactsWithoutPictures sender:self];
            }
        }else{
//            [[WaxAPIClient sharedClient] matchContacts:self.allContactsWithoutPictures sender:self];
        }
    }
}
-(void)connectionSuccess:(id)response forPath:(NSString *)path{
    self.matchedContacts = response;
    
    if ([self.matchedContacts isEmptyOrNull]) {
        self.noMatchedContacts = YES; 
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWContactsKiwiFriendsAvailableNotification object:self];
}
-(void)connectionError:(NSError *)error forPath:(NSString *)path{
    self.matchedContacts = nil; 
    [SVProgressHUD showErrorWithStatus:@"Error loading friends from contacts :( Please try again!"];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWContactsKiwiFriendsAvailableNotification object:self];
}
-(void)setNoMatchedContacts:(BOOL)noMatchedContacts{
    _noMatchedContacts = noMatchedContacts;

    DLog(@"no matched contacts");
}






@end
