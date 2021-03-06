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
#define kPersonListKey      @"personList"
#define kNotificationsKey   @"notifications"

#import "WaxDataManager.h"


@interface WaxDataManager ()
@property (nonatomic, strong) NSString *lastTagID;
@property (nonatomic, strong) NSString *lastFeedUserID;
@property (nonatomic, strong) NSString *lastPersonListUserID; 
@end

@implementation WaxDataManager
@synthesize homeFeed = _homeFeed, myFeed = _myFeed, notifications = _notifications; 
@synthesize categories = _categories, discoverArray = _discoverArray;
@synthesize profileFeed = _profileFeed, tagFeed = _tagFeed, personList = _personList; 
@synthesize lastTagID = _lastTagID, lastFeedUserID = _lastFeedUserID, lastPersonListUserID = _lastPersonListUserID;
@synthesize launchInfo = _launchInfo;

#pragma mark - Alloc & Init
+ (WaxDataManager *)sharedManager {
    static WaxDataManager *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[WaxDataManager alloc] init];
    });
    return sharedID;
}
-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllData) name:WaxUserDidLogOutNotification object:nil];
    }
    return self; 
}

#pragma mark - Public API
-(void)updateHomeFeedWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSNumber *infiniteID = infiniteScroll ? [WaxDataManager infiniteScrollingIDFromArray:self.homeFeed] : nil; 
    
    [[WaxAPIClient sharedClient] fetchHomeFeedWithInfiniteScrollingID:infiniteID feedInfiniteScrollingID:nil completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kHomeFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateMyFeedWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSNumber *infiniteID = infiniteScroll ? [WaxDataManager infiniteScrollingIDFromArray:self.myFeed] : nil;
   
    [[WaxAPIClient sharedClient] fetchMyFeedWithInfiniteScrollingID:infiniteID feedInfiniteScrollingID:nil completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kMyFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateNotificationsWithInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{

    NSNumber *infiniteID = infiniteScroll ? [WaxDataManager infiniteScrollingIDFromArray:self.notifications] : nil;
    
    [[WaxAPIClient sharedClient] fetchNotificationsWithInfiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kNotificationsKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateNotificationCountWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    [[WaxAPIClient sharedClient] fetchNoteCountWithCompletion:^(NSNumber *noteCount, NSError *error) {
        if (!error) {
            self.notificationCount = noteCount;
        }else{
            
        }
        if (completion) {
            completion(error); 
        }
    }];
}
-(void)updateCategoriesWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    [[WaxAPIClient sharedClient] fetchCategoriesWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.categories = list;
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
            DDLogError(@"error updating discover %@", error);
        }
        if (completion) {
            completion(error); 
        }
    }];
}

-(void)updateProfileFeedForUserID:(NSString *)personID withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(personID);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);
    
    NSNumber *infiniteID = [self infiniteIDForFeedFromUserID:personID refresh:!infiniteScroll];
    
    [[WaxAPIClient sharedClient] fetchFeedForUserID:personID feedInfiniteScrollingID:nil infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kProfileFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateFeedForCategory:(NSString *)category withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(category);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);
    
    NSNumber *infiniteID = [self infiniteIDFromTag:category refresh:!infiniteScroll];

    [[WaxAPIClient sharedClient] fetchFeedForCategory:category feedInfiniteScrollingID:nil infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kTagFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)updateFeedForTag:(NSString *)tag withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{

    NSParameterAssert(tag);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);
    
    NSNumber *infiniteID = [self infiniteIDFromTag:tag refresh:!infiniteScroll];

    [[WaxAPIClient sharedClient] fetchFeedForTag:tag sortedBy:WaxAPIClientTagSortTypeRank feedInfiniteScrollingID:nil infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kTagFeedKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }]; 
}
-(void)updateFeedForVideoID:(NSString *)videoID completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    NSParameterAssert(videoID);
    
    [[WaxAPIClient sharedClient] fetchMetadataForVideoID:videoID completion:^(VideoObject *video, NSError *error) {
        [self handleUpdatingValueForKey:kTagFeedKey withCompletionBlock:completion infiniteScrollingID:nil APIResponseData:[NSMutableArray arrayWithObject:video] APIResponseError:error];
    }];
}
-(void)updatePersonListForFollowersWithUserID:(NSString *)userID withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(userID);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);

    NSNumber *infiniteID = [self infiniteIDForPersonListFromUserID:userID refresh:!infiniteScroll];
    [[WaxAPIClient sharedClient] fetchFollowersForUserID:userID infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kPersonListKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error]; 
    }];
}
-(void)updatePersonListForFollowingWithUserID:(NSString *)userID withInfiniteScroll:(BOOL)infiniteScroll completion:(WaxDataManagerCompletionBlockTypeSimple)completion{
    
    NSParameterAssert(userID);
    NSParameterAssert(!infiniteScroll || infiniteScroll == YES);

    NSNumber *infiniteID = [self infiniteIDForPersonListFromUserID:userID refresh:!infiniteScroll];
    [[WaxAPIClient sharedClient] fetchFollowingForUserID:userID infiniteScrollingID:infiniteID completion:^(NSMutableArray *list, NSError *error) {
        [self handleUpdatingValueForKey:kPersonListKey withCompletionBlock:completion infiniteScrollingID:infiniteID APIResponseData:list APIResponseError:error];
    }];
}
-(void)clearAllData{
    self.homeFeed = nil;
    self.myFeed = nil;
    self.discoverArray = nil;
    self.notifications = nil;
    self.notificationCount = nil;
    self.categories = nil;
    self.profileFeed = nil;
    self.tagFeed = nil;
    self.personList = nil; 
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
+(NSNumber *)infiniteScrollingIDFromArray:(NSMutableArray *)feed{
    if (feed && feed.count > 0) {
        if ([[feed lastObject] isKindOfClass:[ModelObject class]]) {
            ModelObject *model = [feed lastObject];
            return model.infiniteScrollingID;
        }
    }
    return nil;
}
-(NSNumber *)infiniteIDForFeedFromUserID:(NSString *)userID refresh:(BOOL)refresh{
    self.lastFeedUserID = userID;
    if ((![self.lastFeedUserID isEqualToString:userID]) || refresh) {
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
-(NSNumber *)infiniteIDForPersonListFromUserID:(NSString *)userID refresh:(BOOL)refresh{
    self.lastPersonListUserID = userID;
    if ((![self.lastPersonListUserID isEqualToString:userID]) || refresh) {
        return nil;
    }else{
        return [WaxDataManager infiniteScrollingIDFromArray:self.personList];
    }
}
-(void)handleUpdatingValueForKey:(NSString *)key withCompletionBlock:(WaxDataManagerCompletionBlockTypeSimple)completion infiniteScrollingID:(NSNumber *)infiniteID APIResponseData:(NSMutableArray *)responseData APIResponseError:(NSError *)error{
    
//    DDLogVerbose(@"\n\n response = %@ \n\n", responseData);
    
    NSMutableArray *array = [self valueForKeyPath:key];
    
//    DDLogVerbose(@"\n\n original array = %@ \n\n", array); 
    
    if (!error) {
        if (infiniteID) {
            [array addObjectsFromArray:responseData];
        }else{
            array = responseData;
        }
        
//        DDLogVerbose(@"\n\n new array = %@ \n\n", array);
        
        [self setValue:array forKeyPath:key];
        
    }else{
        DDLogError(@"error %@", error);
    }
        
    if (completion) {
        completion(error);
    }
}






@end
