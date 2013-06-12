//
//  WaxDataManager.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


NSString *const kCategoriesKey = @"waxDataManager_categories";


#import "WaxDataManager.h"


@interface WaxDataManager ()
@property (nonatomic, strong) NSString *lastTagID;
@property (nonatomic, strong) NSString *lastUserID; 
@end

@implementation WaxDataManager
@synthesize homeFeed = _homeFeed, myFeed = _myFeed, notifications = _notifications; 
@synthesize categories = _categories, discoverArray = _discoverArray;
@synthesize profileFeed = _profileFeed, tagFeed = _tagFeed;
@synthesize lastTagID = _lastTagID, lastUserID = _lastUserID; 

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
-(void)updateHomeFeedWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSNumber *infiniteID = infiniteScroll ? [WaxDataManager infiniteScrollingIDFromArray:self.homeFeed] : nil; 
    [[WaxAPIClient sharedClient] fetchHomeFeedWithInfiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingArray:self.homeFeed withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateMyFeedWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSNumber *infiniteID = infiniteScroll ? [WaxDataManager infiniteScrollingIDFromArray:self.myFeed] : nil;
    [[WaxAPIClient sharedClient] fetchMyFeedWithInfiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingArray:self.myFeed withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateNotificationsWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    DLog(@"notes not implemented in api client yet"); 
}

-(void)updateCategories{
    [[WaxAPIClient sharedClient] fetchCategoriesWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.categories = list;
        }
    }];
}
-(void)updateDiscoverWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    DLog(@"discover not implemented in api client yet");

}

-(void)updateProfileFeedForUserID:(NSString *)personID withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(personID);
    NSParameterAssert(infiniteScroll);
    
    NSNumber *infiniteID = [self infiniteIDFromTag:personID refresh:!infiniteScroll];
    
    [[WaxAPIClient sharedClient] fetchFeedForUser:personID infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingArray:self.profileFeed withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateFeedForTag:(NSString *)tag withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{

    NSParameterAssert(tag);
    NSParameterAssert(infiniteScroll);
        
    NSNumber *infiniteID = [self infiniteIDFromTag:tag refresh:!infiniteScroll];

    [[WaxAPIClient sharedClient] fetchFeedForTag:tag sortedBy:WaxAPIClientTagSortTypeRank infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingArray:self.tagFeed withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }]; 
}
+(NSNumber *)infiniteScrollingIDFromArray:(NSMutableArray *)feed{
    
    //NSParameterAssert(feed);
    
    NSNumber *infinite = nil;
    if (feed) {
        if ([[feed lastObject] isKindOfClass:[ModelObject class]]) {
            ModelObject *model = [feed lastObject];
            infinite = model.infiniteScrollingID;
        }
    }
    return infinite;
}
-(NSNumber *)infiniteIDFromUserID:(NSString *)userID refresh:(BOOL)refresh{
    if ((![self.lastUserID isEqualToString:userID]) || refresh) {
        self.lastUserID = userID;
        return nil;
    }else{
        return [WaxDataManager infiniteScrollingIDFromArray:self.profileFeed];
    }
}
-(NSNumber *)infiniteIDFromTag:(NSString *)tag refresh:(BOOL)refresh{
    if ((![self.lastTagID isEqualToString:tag]) || refresh) {
        self.lastTagID = tag; 
        return nil;
    }else{
        return [WaxDataManager infiniteScrollingIDFromArray:self.tagFeed]; 
    }
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
    if (!_categories) {
        _categories = [[NSUserDefaults standardUserDefaults] objectForKey:kCategoriesKey]; 
    }
    return _categories; 
}


#pragma mark - Private/Helper/Convenience Methods
-(void)handleUpdatingArray:(NSMutableArray *)array withCompletionBlock:(WaxDataManagerCompletionBlockTypeSimple)completion infiniteScrollingID:(NSNumber *)infiniteID APIResponseData:(NSMutableArray *)responseData APIResponseError:(NSError *)error{
    
//    VLog(@"response %@", responseData);
    
    if (!error) {
        if (infiniteID) {
            [array addObjectsFromArray:responseData];
        }else{
            array = responseData;
        }
    }else{
        VLog(@"error %@", error);
    }
    
    if (completion) {
        completion(error);
    }

}








@end
