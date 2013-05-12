//
//  WaxAPIClient.h
//  Wax
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

enum{
    AIKProfilePictureRequestTypeFacebook = 1, //currently does the same thing as 'initial signup', but reserved for future use
    AIKProfilePictureRequestTypeInitialSignup, //do NOT show any progress/success/failure callbacks
    AIKProfilePictureRequestTypeChange, //show progress/success/failure callbacks to the user
};
typedef NSInteger AIKProfilePictureRequestType;


@interface WaxAPIClient : AFHTTPClient //<AmazonServiceRequestDelegate>

+ (WaxAPIClient *)sharedClient;
/*
-(void)loadTrendsFeedWithLastTimeStamp:(NSNumber *)lastTimeStamp;
-(void)loadFriendsFeedWithLastTimeStamp:(NSNumber *)lastTimeStamp;
-(void)loadMyFeedWithLastTimeStamp:(NSNumber *)lastTimeStamp;
-(void)loadNotificationsWithLastTimeStamp:(NSNumber *)lastTimeStamp;

-(void)uploadProfilePicture:(UIImage *)profilePicture uploadType:(KWProfilePictureRequestType)requestType;
//-(void)matchContacts:(NSArray *)contacts sender:(id <WaxAPIClientDelegate>)sender; 

-(void)searchUsersWithUsername:(NSString *)username sender:(id)sender;
-(void)searchTagsWithTag:(NSString *)tag sender:(id)sender;

-(void)loadFeedWithPath:(NSString *)path
                 userid:(NSString *)userid
          lastTimeStamp:(NSNumber *)lastTimeStamp;

//-(void)loadFeedWithPath:(NSString *)path
//                 userid:(NSString *)userid
//          lastTimeStamp:(NSNumber *)lastTimeStamp
//                 sender:(id <WaxAPIClientDelegate>)sender;

//-(void)loadPeopleListWithPath:(NSString *)path
//                     personid:(NSString *)personid
//                lastTimeStamp:(NSNumber *)lastTimeStamp
//                       sender:(id <WaxAPIClientDelegate>)sender;


-(void)loadPeopleListWithpath:(NSString *)path
                     personid:(NSString *)personid
                lastTimeStamp:(NSNumber *)lastTimeStamp;

-(void)loadProfileInfoWithPersonid:(NSString *)personid;

-(void)loadVideoCommentsWithVidId:(NSString *)vidId
             lastCommentTimeStamp:(NSNumber *)lastCommentTimeStamp;

-(void)loadVideoInfoWithVidId:(NSString *)vidId;

-(void)sendCommentWithText:(NSString *)commentText
                     vidId:(NSString *)vidId
                  personid:(NSString *)personid
                  username:(NSString *)username; 


-(void)deleteCommentWithCommentId:(NSString *)commentId vidId:(NSString *)vidId;
-(void)flagVideoWithVidId:(NSString *)vidId personId:(NSString *)personId;
-(void)likeVideoWithVidId:(NSString *)vidId personId:(NSString *)personId;
-(void)deleteVideoWithFeedItem:(FeedObject *)feedItem;

-(void)markNotificationsAsRead;
-(void)loadNoteCount;

-(void)videoWasViewedWithVidId:(NSString *)vidId
                      personid:(NSString *)personid;
-(void)getSettings;

-(void)loadDiscoverWithTagCount:(NSNumber *)tagCount;
-(void)searchTagWithTag:(NSString *)tag; 

-(void)sendSilentTweetWithShareID:(NSString *)shareID
                          caption:(NSString *)caption;

-(void)sendSilentFBPostWithShareID:(NSString *)shareID
                           caption:(NSString *)caption;

//-(void)toggleServerURLSOrSwitchToDevServer:(BOOL)switchToDev; 


#ifndef RELEASE
-(void)deleteVideoWithFeedItem:(FeedObject *)feedItem andSuperUserPrivelages:(BOOL)admin; 
#endif
*/
@end
