//
//  WaxDataManager.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef void(^WaxDataManagerCompletionBlockTypeSimple)(NSError *error);

#import <Foundation/Foundation.h>

@interface WaxDataManager : NSObject

+ (WaxDataManager *)sharedManager;

//universal
@property (nonatomic, strong) NSMutableArray *homeFeed;
-(void)updateHomeFeedWithInfiniteScroll:(BOOL)infiniteScroll
                             completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSMutableArray *myFeed;
-(void)updateMyFeedWithInfiniteScroll:(BOOL)infiniteScroll
                                completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSMutableArray *discoverArray;
-(void)updateDiscoverWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSMutableArray *notifications;
-(void)updateNotificationsWithInfiniteScroll:(BOOL)infiniteScroll
                                  completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSNumber *notificationCount;
-(void)updateNotificationCountWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion; 

@property (nonatomic, readonly) NSMutableArray *categories;
-(void)updateCategoriesWithCompletion:(WaxDataManagerCompletionBlockTypeSimple)completion;

//overwriteable
@property (nonatomic, strong) NSMutableArray *profileFeed;
-(void)updateProfileFeedForUserID:(NSString *)personID
              withInfiniteScroll:(BOOL)infiniteScroll
                       completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSMutableArray *tagFeed;
-(void)updateFeedForCategory:(NSString *)category
          withInfiniteScroll:(BOOL)infiniteScroll
                  completion:(WaxDataManagerCompletionBlockTypeSimple)completion;
-(void)updateFeedForTag:(NSString *)tag
     withInfiniteScroll:(BOOL)infiniteScroll
             completion:(WaxDataManagerCompletionBlockTypeSimple)completion;
-(void)updateFeedForVideoID:(NSString *)videoID
                 completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSMutableArray *personList;
-(void)updatePersonListForFollowingWithUserID:(NSString *)userID
                           withInfiniteScroll:(BOOL)infiniteScroll
                                   completion:(WaxDataManagerCompletionBlockTypeSimple)completion;
-(void)updatePersonListForFollowersWithUserID:(NSString *)userID
                           withInfiniteScroll:(BOOL)infiniteScroll
                                   completion:(WaxDataManagerCompletionBlockTypeSimple)completion;






@end
