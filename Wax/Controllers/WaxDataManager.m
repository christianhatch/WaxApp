//
//  WaxDataManager.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

NSString *const kCategoriesKey = @"waxDataManager.categories";


#import "WaxDataManager.h"


@implementation WaxDataManager
@synthesize homeFeed = _homeFeed, myFeed = _myFeed, categories = _categories; 

#pragma mark - Alloc & Init
+ (WaxDataManager *)sharedManager {
    static WaxDataManager *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[WaxDataManager alloc] init];
    });
    return sharedID;
}
#pragma mark - Public API
-(void)updateCategories{
    [[WaxAPIClient sharedClient] fetchCategoriesWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.categories = list;
        }
    }];
}

#pragma mark - Setters
-(void)setCategories:(NSArray *)categories{
    if (categories.count > 0) {
        _categories = categories;
        [[NSUserDefaults standardUserDefaults] setObject:categories forKey:kCategoriesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark - Getters
-(NSArray *)categories{
    if (_categories) {
        _categories = [[NSUserDefaults standardUserDefaults] objectForKey:kCategoriesKey]; 
    }
    return _categories; 
}


#pragma mark - Private/Helper/Convenience Methods



@end
