//
//  KiwiNetClient.m
//  Kiwi
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "WaxAPIClient.h"
//#import "KiwiModel.h"
//#import "FeedObject.h"
//#import "PersonObject.h"
//#import "NotificationObject.h"
//#import "AFNetworking.h"
//#import "Constants.h"
//#import "CommentObject.h"
//#import "TestFlight.h"
//#import "DiscoverObject.h"
//#import <Accounts/Accounts.h>
//#import <Twitter/Twitter.h>
//#import "CHKit.h"
//#import "UploadManager.h"
//#import "PDKeychainBindings.h"
//#import "CHAutoCompleter.h"
//#import "SVProgressHUD.h"
//#import "WaxUser.h"
//#import "UIButton+AFNetworking.h"
//#import "UIImage+KWKit.h"
//#import "KWFacebookConnect.h"

@interface WaxAPIClient ()

@property (nonatomic) dispatch_queue_t jsonProcessingQueue;

@end

@implementation WaxAPIClient
@synthesize jsonProcessingQueue;

+ (WaxAPIClient *)sharedClient{
    static WaxAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ 
        _sharedClient = [[WaxAPIClient alloc] initWithBaseURL:KWKiwiBaseURL];
    }); 
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.jsonProcessingQueue = dispatch_queue_create("com.acaciainteractive.kiwi.jsonprocessingqueue", NULL);
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    /* [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
//                UIAlertView *noNets = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Kiwi is having trouble connecting to the Kiwi cloud :( \n Please ensure that your device is connected to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [noNets show];
            }break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{

            }break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{

            }break;
            case AFNetworkReachabilityStatusUnknown:{
                
            }break;
        }
    }];
     */
    return self;
}
-(void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{

//    DLog(@"Post Path: \n Path: %@, Params %@", path, parameters);
    
    NSDictionary *requestParams = nil;
    if (parameters) {
        //   NSMutableDictionary *authentication = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userid]}];
        // [authentication addEntriesFromDictionary:parameters];
        // requestParams = [NSDictionary dictionaryWithDictionary:authentication];
    }else{
        //  requestParams = @{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userid]};
    }
        
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:requestParams];
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}
/*
-(void)searchUsersWithUsername:(NSString *)username sender:(id)sender{
    [self postPath:kPeopleSearchURL parameters:@{@"personid":username} success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
        //        DLog(@"userame search response %@", responseObject);
            
            NSArray *usersArray = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *userObjects = [NSMutableArray arrayWithCapacity:usersArray.count];
            for(NSDictionary *dictionary in usersArray) {
                PersonObject *cellItem = [[PersonObject alloc] initWithDictionary:dictionary];
                [userObjects addObject:cellItem];
            }
          
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setValue:userObjects forKeyPath:kUsersArray];
            });
        }); 
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kPeopleSearchURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kPeopleSearchURL userInfo:userInfo];
    }];
}
-(void)searchTagsWithTag:(NSString *)tag sender:(id)sender{
    [self postPath:kSearchTagsURL parameters:@{@"search":tag} success:^(AFHTTPRequestOperation *operation, id responseObject){
     
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
//        DLog(@"tag search response %@", responseObject);
            
            NSMutableArray *response = [NSMutableArray arrayWithArray:[validated objectForKeyNotNull:kKeyForJSON]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setValue:response forKeyPath:kHashTagsArray];
            }); 
        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kSearchTagsURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kSearchTagsURL userInfo:userInfo];
    }];
}
-(void)loadFriendsFeedWithLastTimeStamp:(NSNumber *)lastTimeStamp{
    BOOL refresh = lastTimeStamp == nil; 
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[[WaxUser currentUser] token], @"personid", lastTimeStamp, @"lastitem", nil];
    [self postPath:kFriendsFeedURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //       DLog(@"%@", responseObject);
            
            NSArray *rawFeedJSON = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *feedArray = [NSMutableArray arrayWithCapacity:rawFeedJSON.count];
            for(NSDictionary *dictionary in rawFeedJSON) {
                FeedObject *feedItem = [[FeedObject alloc] initWithDictionary:dictionary];
                [feedArray addObject:feedItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (refresh) {
                    [[KiwiModel sharedModel] setFriendsFeed:[NSMutableArray array]];
                }
                NSMutableArray *old = [[KiwiModel sharedModel] friendsFeed];
                [old addObjectsFromArray:feedArray];
                [[KiwiModel sharedModel] setFriendsFeed:old];
            }); 
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kFriendsFeedURL]; 
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kFriendsFeedURL] error:error];
        [SVProgressHUD showErrorWithStatus:@"There was a connection issue loading your Friends Feed :("];
        [[KiwiModel sharedModel] setFriendsFeed:[NSMutableArray array]]; 
    }];
}
-(void)loadTrendsFeedWithLastTimeStamp:(NSNumber *)lastTimeStamp{
    BOOL refresh = lastTimeStamp == nil;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[[WaxUser currentUser] token], @"personid", lastTimeStamp, @"lastitem", nil];
    [self postPath:kTrendsFeedURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //       DLog(@"%@", responseObject);
            
            NSArray *rawFeedJSON = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *feedArray = [NSMutableArray arrayWithCapacity:rawFeedJSON.count];
            for(NSDictionary *dictionary in rawFeedJSON) {
                FeedObject *feedItem = [[FeedObject alloc] initWithDictionary:dictionary];
                [feedArray addObject:feedItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (refresh) {
                    [[KiwiModel sharedModel] setTrendsFeed:[NSMutableArray array]];
                }
                NSMutableArray *old = [[KiwiModel sharedModel] trendsFeed];
                [old addObjectsFromArray:feedArray];
                [[KiwiModel sharedModel] setTrendsFeed:old];
            }); 
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kTrendsFeedURL];
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kTrendsFeedURL] error:error];
        [SVProgressHUD showErrorWithStatus:@"There was a connection issue loading your Trends Feed :("];
        [[KiwiModel sharedModel] setTrendsFeed:[NSMutableArray array]];
    }];
}
-(void)loadMyFeedWithLastTimeStamp:(NSNumber *)lastTimeStamp{
    BOOL refresh = lastTimeStamp == nil;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[[WaxUser currentUser] userid], @"personid", lastTimeStamp, @"lastitem", nil];
    [self postPath:kPeopleFeedURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //       DLog(@"%@", responseObject);
            
            NSArray *rawFeedJSON = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *feedArray = [NSMutableArray arrayWithCapacity:rawFeedJSON.count];
            for(NSDictionary *dictionary in rawFeedJSON) {
                FeedObject *feedItem = [[FeedObject alloc] initWithDictionary:dictionary];
                [feedArray addObject:feedItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (refresh) {
                    [[KiwiModel sharedModel] setMyFeed:[NSMutableArray array]];
                }
                NSMutableArray *old = [[KiwiModel sharedModel] myFeed];
                [old addObjectsFromArray:feedArray];
                [[KiwiModel sharedModel] setMyFeed:old];
            }); 
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kPeopleFeedURL] error:error];
        [SVProgressHUD showErrorWithStatus:@"There was a connection issue loading your Kiwis :("];
        [[KiwiModel sharedModel] setMyFeed:[NSMutableArray array]];
    }];
}
-(void)loadNotificationsWithLastTimeStamp:(NSNumber *)lastTimeStamp{
    BOOL refresh = lastTimeStamp == nil;

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:lastTimeStamp, @"lastitem", nil];
    [self postPath:kNotificationsURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            NSArray *rawJSON = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *notes = [NSMutableArray arrayWithCapacity:rawJSON.count];
            for(NSDictionary *dictionary in rawJSON) {
                NotificationObject *noteItem = [[NotificationObject alloc] initWithDictionary:dictionary];
                [notes addObject:noteItem];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (refresh) {
                    [[KiwiModel sharedModel] setNotifications:[NSMutableArray array]];
                }
                
                NSMutableArray *old = [[KiwiModel sharedModel] notifications];
                [old addObjectsFromArray:notes];
                [[KiwiModel sharedModel] setNotifications:old];
            }); 
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kNotificationsURL] error:error];
        [SVProgressHUD showErrorWithStatus:@"There was a connection issue loading your notifications :("];
        [[KiwiModel sharedModel] setNotifications:[NSMutableArray array]];
    }];
}
//-(void)matchContacts:(NSArray *)contacts sender:(id<WaxAPIClientDelegate>)sender{
//    [self loadPeopleListWithPath:kContactsOnKiwiURL params:@{@"contacts":contacts} sender:sender];
//}
-(void)loadNoteCount{
    DLog(@"notecount is deprecated. we now load it from the notifications array");
    
    [self postPath:kNoteCountURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
        
//        DLog(@"notecount response %@", validated);
        
        NSNumber *noteCount = [[[validated objectForKeyNotNull:kKeyForJSON] firstObject] objectForKeyNotNull:@"notecount"];
        
        [[KiwiModel sharedModel] setNotificationCount:noteCount];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kNoteCountURL] error:error];
    }];
     
}





































-(void)markNotificationsAsRead{
    [self postPath:kMarkNotesReadURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kMarkNotesReadURL] error:error];
    }];
}
-(void)loadFeedWithPath:(NSString *)path userid:(NSString *)userid lastTimeStamp:(NSNumber *)lastTimeStamp{
    NSDictionary *feedParam = [NSDictionary dictionaryWithObjectsAndKeys:userid, [path isEqualToString:kTagFeedURL] ? @"tag" : @"personid", lastTimeStamp, @"lastitem", nil];
    
    [self postPath:path parameters:feedParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //       DLog(@"%@", responseObject);
            
            NSArray *feedJSONArray = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *feedArray = [NSMutableArray arrayWithCapacity: feedJSONArray.count];
            for(NSDictionary *dictionary in feedJSONArray) {
                FeedObject *feedItem = [[FeedObject alloc] initWithDictionary:dictionary];
                [feedArray addObject:feedItem];
            }
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:feedArray forKey:path];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:path object:self userInfo:userInfo];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", path] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:path userInfo:userInfo];
    }]; 
}
-(void)loadFeedWithPath:(NSString *)path userid:(NSString *)userid lastTimeStamp:(NSNumber *)lastTimeStamp sender:(id<WaxAPIClientDelegate>)sender{
    NSDictionary *feedParam = [NSDictionary dictionaryWithObjectsAndKeys:userid, [path isEqualToString:kTagFeedURL] ? @"tag" : @"personid", lastTimeStamp, @"lastitem", nil];
    
    [self postPath:path parameters:feedParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
//       DLog(@"%@", responseObject);
            
            NSArray *feedJSONArray = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *feedArray = [NSMutableArray arrayWithCapacity: feedJSONArray.count];
            for(NSDictionary *dictionary in feedJSONArray) {
                FeedObject *feedItem = [[FeedObject alloc] initWithDictionary:dictionary];
                [feedArray addObject:feedItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (sender != nil) {
                    if ([sender respondsToSelector:@selector(connectionSuccess:forPath:)]) {
                        [sender connectionSuccess:feedArray forPath:path];
                    }
                }
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (sender != nil) {
            if ([sender respondsToSelector:@selector(connectionError:forPath:)]) {
                [sender connectionError:error forPath:path];
            }
        }
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", path] error:error];
    }];
}
-(void)loadPeopleListWithPath:(NSString *)path personid:(NSString *)personid lastTimeStamp:(NSNumber *)lastTimeStamp sender:(id<WaxAPIClientDelegate>)sender{
   
    NSDictionary *peopleListParam = [NSDictionary dictionaryWithObjectsAndKeys:personid, @"personid", lastTimeStamp, @"lastitem", nil];
    if ([path isEqualToString:kFacebookFriendsURL]) {
        peopleListParam = [NSDictionary dictionaryWithObjectsAndKeys:personid, @"personid", [[WaxUser currentUser] facebookAccountId], @"facebookid", [[KWFacebookConnect sharedFB] accessToken], @"facebooktoken", nil];
    }
    
//    DLog(@"people list paramaters %@", peopleListParam);
    
    [self loadPeopleListWithPath:path params:peopleListParam sender:sender]; 
//    [self postPath:path parameters:peopleListParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        dispatch_async(self.jsonProcessingQueue, ^{
//            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
//            
//            //        DLog(@"response object %@", responseObject);
//            
//            NSArray *peopleJSON = [validated objectForKeyNotNull:kKeyForJSON];
//            NSMutableArray *peopleList = [NSMutableArray arrayWithCapacity:peopleJSON.count];
//            for(NSDictionary *dictionary in peopleJSON) {
//                PersonObject *cellItem = [[PersonObject alloc] initWithDictionary:dictionary];
//                [peopleList addObject:cellItem];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (sender != nil) {
//                    if ([sender respondsToSelector:@selector(connectionSuccess:forPath:)]) {
//                        [sender connectionSuccess:peopleList forPath:path];
//                    }
//                }
//            });
//        });
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", path] error:error];
//        if (sender != nil) {
//            if ([sender respondsToSelector:@selector(connectionError:forPath:)]) {
//                [sender connectionError:error forPath:path];
//            }
//        }
//    }];
}
-(void)loadPeopleListWithPath:(NSString *)path params:(NSDictionary *)params sender:(id<WaxAPIClientDelegate>)sender{
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //        DLog(@"response object %@", responseObject);
            
            NSArray *peopleJSON = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *peopleList = [NSMutableArray arrayWithCapacity:peopleJSON.count];
            for(NSDictionary *dictionary in peopleJSON) {
                PersonObject *cellItem = [[PersonObject alloc] initWithDictionary:dictionary];
                [peopleList addObject:cellItem];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (sender != nil) {
                    if ([sender respondsToSelector:@selector(connectionSuccess:forPath:)]) {
                        [sender connectionSuccess:peopleList forPath:path];
                    }
                }
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", path] error:error];
        if (sender != nil) {
            if ([sender respondsToSelector:@selector(connectionError:forPath:)]) {
                [sender connectionError:error forPath:path];
            }
        }
    }];
}
-(void)loadPeopleListWithpath:(NSString *)path personid:(NSString *)personid lastTimeStamp:(NSNumber *)lastTimeStamp{
    NSDictionary *peopleListParam = [NSDictionary dictionaryWithObjectsAndKeys:personid, @"personid", lastTimeStamp, @"lastitem", nil];
    
    //    DLog(@"people list paramaters %@", peopleListParam);
    
    [self postPath:path parameters:peopleListParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //        DLog(@"response object %@", responseObject);
            
            NSArray *peopleTableJSONArray = [validated objectForKeyNotNull:kKeyForJSON];
            NSMutableArray *peopleTableArray = [NSMutableArray arrayWithCapacity: peopleTableJSONArray.count];
            for(NSDictionary *dictionary in peopleTableJSONArray) {
                PersonObject *cellItem = [[PersonObject alloc] initWithDictionary:dictionary];
                [peopleTableArray addObject:cellItem];
            }
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:peopleTableArray forKey:path];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:path object:self userInfo:userInfo];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", path] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:path userInfo:userInfo];
    }];
}

-(void)loadVideoCommentsWithVidId:(NSString *)vidId lastCommentTimeStamp:(NSNumber *)lastCommentTimeStamp{
    NSDictionary *videoCommentsParam = [NSDictionary dictionaryWithObjectsAndKeys:vidId, @"videoid", lastCommentTimeStamp, @"lastitem", nil];
    [self postPath:kVideoCommentsURL parameters:videoCommentsParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            
            //        DLog(@"%@", responseObject);
            
            NSArray *videoCommentsJSONArray = [validated objectForKeyNotNull: kKeyForJSON];
            NSMutableArray *commentArray = [NSMutableArray arrayWithCapacity: videoCommentsJSONArray.count];
            for(NSDictionary *dictionary in videoCommentsJSONArray) {
                CommentObject *commentItem = [[CommentObject alloc] initWithDictionary:dictionary];
                [commentArray addObject:commentItem]; }
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:commentArray forKey:kVideoCommentsURL];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kVideoCommentsURL object:self userInfo:userInfo];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kVideoCommentsURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kVideoCommentsURL userInfo:userInfo];
    }]; 
}
-(void)loadVideoInfoWithVidId:(NSString *)vidId{
    NSDictionary *vInfoParam = [NSDictionary dictionaryWithObjectsAndKeys:vidId, @"videoid", nil];
    [self postPath:kVideoInfoURL parameters:vInfoParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            //        DLog(@"%@", responseObject);
            
            NSArray *videoResponse = [validated objectForKeyNotNull: kKeyForJSON];
            FeedObject *videoItem = [[FeedObject alloc] initWithDictionary:[videoResponse firstObject]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:videoItem forKey:kVideoInfoURL];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kVideoInfoURL object:self userInfo:userInfo];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kVideoInfoURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kVideoInfoURL userInfo:userInfo];
    }];
}
-(void)sendCommentWithText:(NSString *)commentText vidId:(NSString *)vidId personid:(NSString *)personid username:(NSString *)username{
    NSDictionary *commentParam = [NSDictionary dictionaryWithObjectsAndKeys:commentText, @"comment", vidId, @"videoid", personid, @"personid", username, @"personusername", nil];
    
//    DLog(@"comment params %@", commentParam);
    
    [self postPath:kSendCommentURL parameters:commentParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            NSArray *commentSuccess = [validated objectForKeyNotNull:kKeyForJSON];
            CommentObject *comment = [[CommentObject alloc] initWithDictionary:[commentSuccess objectAtIndexNotNull:0]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:comment forKey:kSendCommentURL];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kSendCommentURL object:self userInfo:userInfo];
        }); 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kSendCommentURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kSendCommentURL userInfo:userInfo];
    }]; 
}
-(void)deleteCommentWithCommentId:(NSString *)commentId vidId:(NSString *)vidId{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:commentId, @"commentid", vidId, @"videoid", nil];
//    DLog(@"paramaters %@", itemParam);
    [self postPath:kDeleteCommentURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
        
        //        NSArray *requestSuccess = [responseObject objectForKeyNotNull: objectForKey];
        //        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:requestSuccess forKey:path];
        //        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:path object:self userInfo:userInfo];
        
        //        DLog(@"response %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kDeleteCommentURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kDeleteCommentURL userInfo:userInfo];
    }]; 
}
-(void)flagVideoWithVidId:(NSString *)vidId personId:(NSString *)personId{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:vidId, @"videoid", personId, @"personid", nil];
//    DLog(@"paramaters %@", itemParam);
    [self postPath:kFlagVideoURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
        
        //        NSArray *requestSuccess = [responseObject objectForKeyNotNull: objectForKey];
        //        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:requestSuccess forKey:path];
        //        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:path object:self userInfo:userInfo];
        
        //        DLog(@"response %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kFlagVideoURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kFlagVideoURL userInfo:userInfo];
    }]; 
}
-(void)likeVideoWithVidId:(NSString *)vidId personId:(NSString *)personId{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:personId, @"personid", vidId, @"videoid", nil];
//    DLog(@"paramaters %@", itemParam);
    [self postPath:kLikeVideoURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
        
        //        NSArray *requestSuccess = [responseObject objectForKeyNotNull: objectForKey];
        //        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:requestSuccess forKey:path];
        //        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:path object:self userInfo:userInfo];
        
        //        DLog(@"response %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kLikeVideoURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kLikeVideoURL userInfo:userInfo];
    }]; 
}
-(void)deleteVideoWithFeedItem:(FeedObject *)feedItem{
    NSDictionary *itemParam = [NSDictionary dictionaryWithObjectsAndKeys:feedItem.vidId, @"videoid", nil];
    [self postPath:kDeleteVideoURL parameters:itemParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
        [[UploadManager sharedManager] deleteKiwiWithFeedItem:feedItem];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kDeleteVideoURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kDeleteVideoURL userInfo:userInfo];
    }];
}
#ifndef RELEASE
-(void)deleteVideoWithFeedItem:(FeedObject *)feedItem andSuperUserPrivelages:(BOOL)admin{

    NSDictionary *params = nil;
    if (admin) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:feedItem.vidId, @"videoid", @"tpanaed", @"admin", nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:feedItem.vidId, @"videoid", nil];
    }
    [self postPath:kDeleteVideoURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
        [[UploadManager sharedManager] deleteKiwiWithFeedItem:feedItem];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kDeleteVideoURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kDeleteVideoURL userInfo:userInfo];
    }];
}
#endif

-(void)loadProfileInfoWithPersonid:(NSString *)personid{
    NSDictionary *profileInfoParam = [NSDictionary dictionaryWithObjectsAndKeys:personid, @"personid", nil];
    [self postPath:kProfileInfoURL parameters:profileInfoParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            NSArray *response = [validated objectForKeyNotNull:kKeyForJSON];
            PersonObject *person = [[PersonObject alloc] initWithDictionary:[response firstObject]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:person forKey:kProfileInfoURL];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kProfileInfoURL object:self userInfo:userInfo];
        }); 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kProfileInfoURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kProfileInfoURL userInfo:userInfo];
    }];
}
-(void)videoWasViewedWithVidId:(NSString *)vidId personid:(NSString *)personid{
    NSDictionary *viewedDict = [[NSDictionary alloc] initWithObjectsAndKeys:vidId, @"videoid", personid, @"personid", nil];
    [self postPath:kVideoViewedURL parameters:viewedDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KiwiModel sharedModel] validateResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kVideoViewedURL] error:error];
    }];
}
-(void)getSettings{
    [self postPath:kGetSettingsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            NSArray *settings = [[validated objectForKeyNotNull:kKeyForJSON] firstObject];
            if (!settings) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"error" forKey:kConnectionErrorNotify];
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kGetSettingsURL userInfo:userInfo];
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:settings forKey:kGetSettingsURL];
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kGetSettingsURL object:self userInfo:userInfo];
            }
        }); 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kGetSettingsURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kGetSettingsURL userInfo:userInfo];
    }];
}
-(void)loadDiscoverWithTagCount:(NSNumber *)tagCount{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:tagCount, @"lastitem", nil];
    [self postPath:kDiscoverURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            NSMutableArray *discoverJSON = [NSMutableArray arrayWithArray:[validated objectForKeyNotNull:kKeyForJSON]];
            discoverJSON.count & 1 ? [discoverJSON removeLastObject] : nil;
            NSMutableArray *discoverArray = [NSMutableArray arrayWithCapacity:discoverJSON.count/2];
            for (int count = 0; count < discoverJSON.count; count +=2) {
                int county = count +1;
                DiscoverObject *cellItem = [[DiscoverObject alloc] initWithDictionaries:[discoverJSON objectAtIndex:count] dictionaryR:[discoverJSON objectAtIndex:county]];
                [discoverArray addObject:cellItem];
            }
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:discoverArray forKey:kDiscoverURL];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kDiscoverURL object:self userInfo:userInfo];
        }); 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kDiscoverURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kDiscoverURL userInfo:userInfo];
    }];
}
-(void)searchTagWithTag:(NSString *)tag{
    NSDictionary *tagSearchParam = [NSDictionary dictionaryWithObjectsAndKeys:tag, @"search", nil];
    [self postPath:kSearchTagsURL parameters:tagSearchParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        dispatch_async(self.jsonProcessingQueue, ^{
            id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
            //        DLog(@"tag search response %@", responseObject);
            
            NSMutableArray *response = [NSMutableArray arrayWithArray:[validated objectForKeyNotNull:kKeyForJSON]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response forKey:kSearchTagsURL];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kSearchTagsURL object:self userInfo:userInfo];
        }); 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:[NSString stringWithFormat:@"Connection error for path: %@", kSearchTagsURL] error:error];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:kConnectionErrorNotify];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kConnectionErrorNotify object:kSearchTagsURL userInfo:userInfo];
    }];
}
-(void)sendSilentTweetWithShareID:(NSString *)shareID caption:(NSString *)caption{
    if ([caption isEmptyOrNull]) {
        caption = @"Check out my Kiwi!";
    }    
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:[[WaxUser currentUser] twitterAccountId]];

    NSString *status = [NSString stringWithFormat:@"%@ %@", caption, [NSURL shareURLFromShareId:shareID]];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:status forKey:@"status"];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:kTwitterStatusUpdateURL parameters:params requestMethod:TWRequestMethodPOST];
    [postRequest setAccount:twitterAccount];
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:nil];
        if (error) {
            [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Silent Twitter Post Error" error:error];
        }else{
            [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:@"Shared Via Twitter from Share Page"];
        }
    }];
}
-(void)sendSilentFBPostWithShareID:(NSString *)shareID caption:(NSString *)caption{
    if ([caption isEmptyOrNull]) {
        caption = @"Check out my Kiwi!";
    }
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//    ACAccount *fB = [accountStore accountWithIdentifier:[[WaxUser currentUser] facebookAccountId]];

    NSString *status = [NSString stringWithFormat:@"%@ %@", caption, [NSURL shareURLFromShareId:shareID]];
    
    [[KWFacebookConnect sharedFB] postStatus:status]; 
//
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObject:status forKey:@"message"];
//    
//    SLRequest *post = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:kFacebookStatusUpdateURL parameters:params];
//    [post setAccount:fB]; 
//    [post performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
////        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:nil];
////        DLog(@"response %@ http status code %i error %@", response, urlResponse.statusCode, error);
//        if (error) {
//            [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Silent Facebook Post Error" error:error];
//        }
//    }];
}
//-(void)toggleServerURLSOrSwitchToDevServer:(BOOL)switchToDev{
//    PDKeychainBindings *userDefaults = [PDKeychainBindings sharedKeychainBindings];
//    if (switchToDev) {
//        [userDefaults setObject:kDevBaseURL forKey:kServerBaseURLKey];
//    }else{
//        if ([[userDefaults objectForKey:kServerBaseURLKey] isEqualToString:kLiveBaseURL]) {
//            [userDefaults setObject:kDevBaseURL forKey:kServerBaseURLKey];
//        }else if ([[userDefaults objectForKey:kServerBaseURLKey] isEqualToString:kDevBaseURL]) {
//            [userDefaults setObject:kLiveBaseURL forKey:kServerBaseURLKey];
//        }
//    }
//    
//    [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:[NSString stringWithFormat:@"%@ switched server to %@", [[WaxUser currentUser] username], [[NSUserDefaults standardUserDefaults] objectForKey:kServerBaseURLKey]]];
//    RIButtonItem *okay = [RIButtonItem itemWithLabel:@"OK Thanks"];
//    UIAlertView *pleaseQuit = [[UIAlertView alloc] initWithTitle:@"Please quit Kiwi to switch servers." message:@"Press the home button, then double click the home button, then tap and hold the Kiwi icon in your app switcher until it wobbles. Then tap the red circular icon in the top left corner to quit Kiwi. \nThen open Kiwi and you will have switched servers!" cancelButtonItem:okay otherButtonItems:nil, nil];
//    [pleaseQuit show];
//}
-(void)uploadProfilePicture:(UIImage *)profilePicture uploadType:(KWProfilePictureRequestType)requestType{
    NSData *picData = UIImageJPEGRepresentation([UIImage squareCropImage:profilePicture], 0.01);
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:kAWSAccessKey withSecretKey:kAWSSecretKey];
    @try {
        if (profilePicture) {
            S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:[NSString s3ProfilePictureKeyFromUserid:[[WaxUser currentUser] userid]] inBucket:kAWSBucket];
            por.contentType = @"image/jpeg";
            por.data = picData;
            por.delegate = self; 
            switch (requestType) {
                case KWProfilePictureRequestTypeInitialSignup:{
                    por.requestTag = @"signup";
                }break;
                case KWProfilePictureRequestTypeFacebook:{
                    por.requestTag = @"facebook";
                }break;
                case KWProfilePictureRequestTypeChange:{
                    por.requestTag = @"change";
                }break;
            }
            [s3 putObject:por];
        }
    }
    @catch (AmazonClientException *exception) {
        [SVProgressHUD showErrorWithStatus:@"Error setting profile picture :( Please try again!"];
        [[AIKErrorUtilities sharedUtilities] logExceptionWithMessage:@"Exception uploading Profile Picture" exception:exception];
    }
}
-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if ([request.requestTag isEqualToString:@"change"]) {
        [SVProgressHUD showWithStatus:@"Setting Profile Picture..." maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response{
    [[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:KWProfilePictureChangeDateKey];
    [UIImageView clearAFImageCache];
    [UIButton clearAFImageCache];
    if ([request.requestTag isEqualToString:@"change"]) {
        [SVProgressHUD showSuccessWithStatus:@"Profile Picture Set Successfully!"];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWProfilePictureChangedNotification object:self];
    }
}
-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error{
    if ([request.requestTag isEqualToString:@"change"]) {
        [SVProgressHUD showErrorWithStatus:@"Error setting profile picture :( Please try again!"];
    }
    [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error uploading profile picture" error:error];
}

*/

@end