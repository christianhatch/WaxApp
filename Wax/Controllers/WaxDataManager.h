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

//universal feeds
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

//overwriteable
@property (nonatomic, strong) NSMutableArray *profileFeed;
-(void)updateProfileFeedForUserID:(NSString *)personID
              withInfiniteScroll:(BOOL)infiniteScroll
                       completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

@property (nonatomic, strong) NSMutableArray *tagFeed;
-(void)updateFeedForTag:(NSString *)tag
    withInfiniteScroll:(BOOL)infiniteScroll
             completion:(WaxDataManagerCompletionBlockTypeSimple)completion;

//data and stuff
@property (nonatomic, readonly) NSArray *categories;
-(void)updateCategories;



#pragma mark - Convenience Methods
+(NSNumber *)infiniteScrollingIDFromArray:(NSMutableArray *)feed;



@end
