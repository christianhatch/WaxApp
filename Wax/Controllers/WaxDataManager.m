//
//  WaxDataManager.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


NSString *const kCategoriesKey = @"waxDataManager.categories";

#define kHomeFeedKey        @"homeFeed"
#define kMyFeedKey          @"myFeed"
#define kProfileFeedKey     @"profileFeed"
#define kTagFeedKey         @"tagFeed"

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
        [self handleUpdatingValueForKey:kHomeFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateMyFeedWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSNumber *infiniteID = infiniteScroll ? [WaxDataManager infiniteScrollingIDFromArray:self.myFeed] : nil;
    [[WaxAPIClient sharedClient] fetchMyFeedWithInfiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kMyFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateNotificationsWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    DLog(@"notes not implemented in api client yet"); 
}

-(void)updateCategoriesWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    [[WaxAPIClient sharedClient] fetchCategoriesWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.categories = list;
        }else{
//            VLog(@"error updating categories %@", error);
        }
        if (completion) {
            completion(error);
        }
    }];
}
-(void)updateDiscoverWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    [[WaxAPIClient sharedClient] fetchDiscoverWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.discoverArray = list;
        }else{
            VLog(@"error updating discover %@", error);
        }
        if (completion) {
            completion(error); 
        }
    }];
}

-(void)updateProfileFeedForUserID:(NSString *)personID withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(personID);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);
    
    NSNumber *infiniteID = [self infiniteIDFromTag:personID refresh:!infiniteScroll];
    
    [[WaxAPIClient sharedClient] fetchFeedForUserID:personID infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kProfileFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateFeedForCategory:(NSString *)category withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(category);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);
    
    NSNumber *infiniteID = [self infiniteIDFromTag:category refresh:!infiniteScroll];

    [[WaxAPIClient sharedClient] fetchFeedForCategory:category infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kTagFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateFeedForTag:(NSString *)tag withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{

    NSParameterAssert(tag);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);
    
    NSNumber *infiniteID = [self infiniteIDFromTag:tag refresh:!infiniteScroll];

    [[WaxAPIClient sharedClient] fetchFeedForTag:tag sortedBy:WaxAPIClientTagSortTypeRank infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kTagFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }]; 
}

+(NSNumber *)infiniteScrollingIDFromArray:(NSMutableArray *)feed{
        
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
    self.lastUserID = userID;
    if ((![self.lastUserID isEqualToString:userID]) || refresh) {
        return nil;
    }else{
        return [WaxDataManager infiniteScrollingIDFromArray:self.profileFeed];
    }
}
-(NSNumber *)infiniteIDFromTag:(NSString *)tag refresh:(BOOL)refresh{
    self.lastTagID = tag;
    if ((![self.lastTagID isEqualToString:tag]) || refresh) {
        return nil;
    }else{
        return [WaxDataManager infiniteScrollingIDFromArray:self.tagFeed]; 
    }
}


#pragma mark - Setters
-(void)setCategories:(NSMutableArray *)categories{
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
-(void)handleUpdatingValueForKey:(NSString *)key withCompletionBlock:(WaxDataManagerCompletionBlockTypeSimple)completion infiniteScrollingID:(NSNumber *)infiniteID APIResponseData:(NSMutableArray *)responseData APIResponseError:(NSError *)error{
    
//    VLog(@"response %@", responseData);
    
    NSMutableArray *array = [self valueForKeyPath:key];
    
    if (!error) {
        if (infiniteID) {
            [array addObjectsFromArray:responseData];
        }else{
            array = responseData;
        }
        
        [self setValue:array forKeyPath:key];
        
    }else{
        VLog(@"error %@", error);
    }
        
    if (completion) {
        completion(error);
    }
}







@end
