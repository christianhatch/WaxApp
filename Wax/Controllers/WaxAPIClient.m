//
//  KiwiNetClient.m
//  Kiwi
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

static inline BOOL SimpleReturnFromAPIResponse(id response) {
    return [[[response objectAtIndexOrNil:0] objectForKeyOrNil:@"complete"] boolValue];
}
static inline BOOL PathRequiresArray(NSString *path){
    BOOL forceArray = NO;
    if ([path containsString:@"feeds"] || [path isEqualToString:@"users/following"] || [path isEqualToString:@"users/followers"] || [path isEqualToString:@"users/search"] || [path isEqualToString:@"tags/search"]|| [path containsString:@"find_friends"] || [path containsString:@"categories"]) {
        forceArray = YES; 
    }
    return forceArray;
}

#import "WaxAPIClient.h"

@interface WaxAPIClient ()
@property (nonatomic) dispatch_queue_t jsonProcessingQueue;
@end

@implementation WaxAPIClient
@synthesize jsonProcessingQueue; 

#pragma mark - Alloc & Init
+ (WaxAPIClient *)sharedClient{
    static WaxAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ 
        _sharedClient = [[WaxAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWaxAPIBaseURL]];
    }); 
    return _sharedClient;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.jsonProcessingQueue = dispatch_queue_create("com.wax.api.jsonprocessingqueue", NULL);
    self.allowsInvalidSSLCertificate = NO;
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}
-(NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters{

    NSDictionary *finalParameters = nil;
    if (parameters) {
        NSMutableDictionary *authentication = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userID]}];
        [authentication addEntriesFromDictionary:parameters];
        finalParameters = [NSDictionary dictionaryWithDictionary:authentication];
    }else{
        finalParameters = @{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userID]};
    }
    
    return [super requestWithMethod:method path:path parameters:finalParameters];
}
-(NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block{
    
    NSDictionary *finalParameters = nil;
    if (parameters) {
        NSMutableDictionary *authentication = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userID]}];
        [authentication addEntriesFromDictionary:parameters];
        finalParameters = [NSDictionary dictionaryWithDictionary:authentication];
    }else{
        finalParameters = @{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userID]};
    }
    
    return [super multipartFormRequestWithMethod:method path:path parameters:finalParameters constructingBodyWithBlock:block];
}

#pragma mark - Public API -

#pragma mark - Logins
-(void)createAccountWithUsername:(NSString *)username fullName:(NSString *)fullName email:(NSString *)email passwordOrFacebookID:(NSString *)passwordOrFacebookID completion:(WaxAPIClientBlockTypeCompletionLogin)completion{
        
    NSParameterAssert(username);
    NSParameterAssert(fullName);
    NSParameterAssert(email);
    NSParameterAssert(passwordOrFacebookID);
        
    [self postPath:@"logins/signup" parameters:@{@"username":username, @"name":fullName, @"email":email, ([[AIKFacebookManager sharedManager] sessionIsActive] ? @"facebookid" : @"password"):passwordOrFacebookID} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}
-(void)loginWithFacebookID:(NSString *)facebookID fullName:(NSString *)fullName email:(NSString *)email completion:(WaxAPIClientBlockTypeCompletionLogin)completion{
        
    NSParameterAssert(facebookID);
    NSParameterAssert(fullName);
    NSParameterAssert(email);
    
    [self postPath:@"logins/facebook" parameters:@{@"name":fullName, @"email":email, @"facebookid":facebookID} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(WaxAPIClientBlockTypeCompletionLogin)completion{
        
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    [self postPath:@"logins/login" parameters:@{@"username":username, @"password":password} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

#pragma mark - Feeds
-(void)fetchFeedForUserID:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(personID);
    
    [self fetchFeedFromPath:@"feeds/user" tagOrPersonID:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
        if (completion) {
            completion(list, error); 
        }
    }];
}
-(void)fetchHomeFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    if ([[WaxUser currentUser] isLoggedIn]) {
        [self fetchFeedFromPath:@"feeds/home" tagOrPersonID:[[WaxUser currentUser] userID] infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            
            if (!error) {
                [WaxDataManager sharedManager].homeFeed = list;
            }
            
            if (completion) {
                completion(list, error);
            }
        }];
    }
}
-(void)fetchMyFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    if ([[WaxUser currentUser] isLoggedIn]) {
        [self fetchFeedForUserID:[[WaxUser currentUser] userID] infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            
            if (!error) {
                [WaxDataManager sharedManager].myFeed = list;
            }
            
            if (completion) {
                completion(list, error); 
            }
        }];
    }
}
-(void)fetchFeedForTag:(NSString *)tag sortedBy:(WaxAPIClientTagSortType)sortedBy infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(tag);
    NSParameterAssert(sortedBy);
    
    switch (sortedBy) {
        case WaxAPIClientTagSortTypeRank:{
            [self fetchFeedFromPath:@"feeds/tag" tagOrPersonID:tag infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
                if (completion) {
                    completion(list, error);
                }
            }];
        }break;
        case WaxAPIClientTagSortTypeRecent:{
            [self fetchFeedFromPath:@"feeds/tag_recent" tagOrPersonID:tag infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
                if (completion) {
                    completion(list, error);
                }
            }];
        }break;
    }
}
-(void)fetchFeedForCategory:(NSString *)category infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    [self fetchFeedFromPath:@"feeds/discover" tagOrPersonID:category infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
        if (completion) {
            completion(list, error); 
        }
    }];
}

#pragma mark - Users
-(void)toggleFollowUserID:(NSString *)personID completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
        
    NSParameterAssert(personID);

    [self postPath:@"users/put" parameters:@{@"personid":personID} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];
}
-(void)fetchProfileInformationForUserID:(NSString *)personID completion:(WaxAPIClientBlockTypeCompletionUser)completion{
    
    NSParameterAssert(personID);
    
    [self postPath:@"users/profile" parameters:@{@"personid": personID} modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}
-(void)fetchFollowersForUserID:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(personID);
    
    [self fetchPeopleFromPath:@"users/followers" personId:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
        if (completion) {
            completion(list, error);
        }
    }];
}
-(void)fetchFollowingForUserID:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(personID);
    
    [self fetchPeopleFromPath:@"users/following" personId:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
        if (completion) {
            completion(list, error);
        }
    }];
}
-(void)searchForUsersWithSearchTerm:(NSString *)searchTerm infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(searchTerm);
    
    [self fetchPeopleFromPath:@"users/search" personId:searchTerm infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
        if (completion) {
            completion(list, error);
        }
    }];
}
-(void)uploadProfilePicture:(UIImage *)profilePicture progress:(WaxAPIClientBlockTypeProgressUpload)progress completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
        
    NSParameterAssert(profilePicture);
    
    UIImage *square = [UIImage cropImageToSquare:profilePicture];
    UIImage *small = [UIImage resizeImage:square toSize:CGSizeMake(100, 100)]; 
    NSData *picData = UIImageJPEGRepresentation(small, 0.5);
    
    [self postMultiPartPath:@"settings/update_picture" parameters:@{@"facebook": @0} constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:picData name:@"profile_picture" fileName:@"profile_picture.jpg" mimeType:@"image/jpeg"];
    } progress:progress completion:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];

}
-(void)syncFacebookProfilePictureWithCompletion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    [self postPath:@"settings/update_picture" parameters:@{@"facebook": @1} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];
}


#pragma mark - Videos
-(void)uploadVideoAtFileURL:(NSURL *)fileURL videoID:(NSString *)videoID progress:(WaxAPIClientBlockTypeProgressUpload)progress completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    
    NSParameterAssert(fileURL);
    NSParameterAssert(videoID);
    
    [self postMultiPartPath:@"videos/put_video" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:fileURL name:@"video" fileName:videoID mimeType:@"video/mp4" error:&error];
        
    }progress:progress completion:^(id model, NSError *error) {
        DLog(@"upload video response %@", model);

        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];

}
-(void)uploadThumbnailAtFileURL:(NSURL *)fileURL videoID:(NSString *)videoID progress:(WaxAPIClientBlockTypeProgressUpload)progress completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    
    NSParameterAssert(fileURL);
    NSParameterAssert(videoID);
    
    [self postMultiPartPath:@"videos/put_thumbnail" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:fileURL name:@"thumbnail" fileName:videoID mimeType:@"image/jpg" error:&error];
        
    }progress:progress completion:^(id model, NSError *error) {
        DLog(@"upload thumbnail response %@", model);

        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
        
    }];
}
-(void)uploadVideoMetadataWithVideoID:(NSString *)videoID videoLength:(NSNumber *)videoLength tag:(NSString *)tag category:(NSString *)category lat:(NSNumber *)lat lon:(NSNumber *)lon completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    
    NSParameterAssert(videoID);
    NSParameterAssert(videoLength);
    NSParameterAssert(tag);
    NSParameterAssert(category);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:videoID, @"videoid", videoLength, @"videolength", tag, @"tag", category, @"category", lat, @"lat", lon, @"lon", nil];
  
    [self postPath:@"videos/put_data" parameters:params modelClass:nil completionBlock:^(id model, NSError *error) {
        DLog(@"upload meta response %@", model);
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];
}
-(void)cancelVideoUploadingOperationWithVideoID:(NSString *)videoID{
    
    [self cancelAllHTTPOperationsWithMethod:@"POST" path:@"videos/put_data"];
    [self cancelAllHTTPOperationsWithMethod:@"POST" path:@"videos/put_thumbnail"];
    [self cancelAllHTTPOperationsWithMethod:@"POST" path:@"videos/put_video"];
    
    if (videoID) {
        [self postPath:@"videos/cancel_upload" parameters:@{@"videoid": videoID} modelClass:nil completionBlock:^(id model, NSError *error) {
            [AIKErrorManager logMessageToAllServices:@"User canceled the upload of video"];
        }];
    }
}
-(void)fetchMetadataForVideoID:(NSString *)videoID completion:(WaxAPIClientBlockTypeCompletionVideo)completion{
    
    NSParameterAssert(videoID);
    
    [self postPath:@"videos/get" parameters:@{@"videoid":videoID} modelClass:[VideoObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error); 
        }
    }];
}
-(void)voteUpVideoID:(NSString *)videoID ofUser:(NSString *)personID completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    
    NSParameterAssert(videoID);
    NSParameterAssert(personID);
        
    [self postPath:@"videos/vote" parameters:@{@"videoid":videoID, @"personid":personID} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];
}
-(void)performAction:(WaxAPIClientVideoActionType)actionType onVideoID:(NSString *)videoID completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    
    NSParameterAssert(actionType);
    NSParameterAssert(videoID);
            
    NSString *path = @"videos/";
    
    switch (actionType) {
        case WaxAPIClientVideoActionTypeView:{
            path = [path stringByAppendingString:@"view"]; 
        }break;
        case WaxAPIClientVideoActionTypeReport:{
            path = [path stringByAppendingString:@"flag"];
        }break;
        case WaxAPIClientVideoActionTypeDelete:{
            path = [path stringByAppendingString:@"delete"];
        }break;
    }
    [self postPath:path parameters:@{@"videoid": videoID} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error);
        }
    }];
}
-(void)fetchCategoriesWithCompletion:(WaxAPIClientBlockTypeCompletionList)completion{
    [self postPath:@"categories/get" parameters:nil modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error); 
        }
    }];
}
-(void)fetchDiscoverWithCompletion:(WaxAPIClientBlockTypeCompletionList)completion{
    [self postPath:@"categories/discover" parameters:nil modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

#pragma mark - Tags
-(void)searchForTagsWithSearchTerm:(NSString *)searchTerm infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(searchTerm);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:searchTerm, @"tag", infiniteScrollingID, @"lastitem", nil];
    
    [self postPath:@"tags/search" parameters:params modelClass:[TagObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error); 
        }
    }];
}
-(void)sendChallengeTag:(NSString *)tag toUserID:(NSString *)userID completion:(WaxAPIClientBlockTypeCompletionSimple)completion{
    NSParameterAssert(tag);
    NSParameterAssert(userID);
    
    [self postPath:@"tags/send" parameters:@{@"personid": userID, @"tag": tag} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error); 
        }
    }];
}

#pragma mark - Settings
-(void)fetchSettingsWithCompletion:(WaxAPIClientBlockTypeCompletionSettings)completion{
    [self postPath:@"settings/get" parameters:nil modelClass:[SettingsObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error); 
        }
    }];
}
-(void)updateSettingsWithEmail:(NSString *)email fullName:(NSString *)fullName pushSettings:(NSDictionary *)pushSettings completion:(WaxAPIClientBlockTypeCompletionSettings)completion{
    
    NSParameterAssert(email);
    NSParameterAssert(fullName);
    NSParameterAssert(pushSettings);
    
    [self postPath:@"settings/update" parameters:@{@"email":email, @"name":fullName, @"pushsettings":pushSettings} modelClass:[SettingsObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}
-(void)connectFacebookAccountWithFacebookID:(NSString *)facebookID completion:(WaxAPIClientBlockTypeCompletionSimple)completion{

    NSParameterAssert(facebookID);
    
    [self postPath:@"settings/facebook_connect" parameters:@{@"facebookid": facebookID} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(SimpleReturnFromAPIResponse(model), error); 
        }
    }]; 
}
-(void)fetchNotificationsWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:infiniteScrollingID, @"lastitem", nil]; 
    
    [self postPath:@"notes/get" parameters:params modelClass:[NotificationObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}
-(void)fetchNoteCountWithCompletion:(void (^)(NSNumber *, NSError *))completion{
    [self postPath:@"notes/unread" parameters:nil modelClass:nil completionBlock:^(id model, NSError *error) {
        
        NSNumber *count = [[model objectAtIndexOrNil:0] objectForKeyOrNil:@"unread"];
        
        if (completion) {
            completion(count, error);
        }
   }]; 
}

#pragma mark - Internal Methods
-(void)fetchFeedFromPath:(NSString *)path tagOrPersonID:(NSString *)tagOrPersonID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{

    NSParameterAssert(tagOrPersonID);
            
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:tagOrPersonID, @"feedid", infiniteScrollingID, @"lastitem", nil];

    [self postPath:path parameters:params modelClass:[VideoObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

-(void)fetchPeopleFromPath:(NSString *)path personId:(NSString *)personId infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientBlockTypeCompletionList)completion{
    
    NSParameterAssert(personId);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:personId, @"personid", infiniteScrollingID, @"lastitem", nil];

    [self postPath:path parameters:params modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}
-(void)postPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass completionBlock:(void (^)(id model, NSError *error))completion{
    
    NSParameterAssert(path);
    
    [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject forModelClass:modelClass forceArray:PathRequiresArray(path) withCompletionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"standard post request failure %@", error);
        if (error.domain == NSURLErrorDomain && error.code == -999) {
            if (completion) {
                completion(nil, error);
            }
        }else{
            [AIKErrorManager showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion buttonHandler:^{
                if (completion) {
                    completion(nil, error);
                }
            } logError:NO];
        }
    }];
}
-(void)postMultiPartPath:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block progress:(WaxAPIClientBlockTypeProgressUpload)progress completion:(void (^)(id, NSError *))completion{
    
    NSParameterAssert(path);    
    NSParameterAssert(block);
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:block];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    if (progress) {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            CGFloat proggy = (float)totalBytesWritten/totalBytesExpectedToWrite;
            
            progress(proggy, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            
        }];
    }
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject forModelClass:nil forceArray:NO withCompletionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"multipart form request failure %@", error);
        if (error.domain == NSURLErrorDomain && error.code == -999) {
            if (completion) {
                completion(nil, error);
            }
        }else{
            [AIKErrorManager showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion buttonHandler:^{
                if (completion) {
                    completion(nil, error);
                }
            } logError:NO];
        }
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}
-(void)processResponseObject:(id)responseObject forModelClass:(Class)modelClass forceArray:(BOOL)forceArray withCompletionBlock:(void (^)(id model, NSError *error))completion{

        [self validateResponseObject:responseObject completion:^(id validated) {
            
            if ([validated isKindOfClass:[NSError class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil, validated);
                    }
                });
            }else{
                id returnModel = validated;
                if (modelClass) { //if there's no model class, we simply return the entire 'validated' object! 
                    if ([validated respondsToSelector:@selector(objectAtIndexOrNil:)] && [validated respondsToSelector:@selector(count)]) {
                        if ([validated count] > 1 || forceArray) {
                            NSArray *rawDictionaries = validated;
                            NSMutableArray *modelObjectArray = [NSMutableArray arrayWithCapacity:rawDictionaries.count];
                            
                            for(NSDictionary *dictionary in rawDictionaries) {
                                id modelObject = [[modelClass alloc] initWithDictionary:dictionary];
                                [modelObjectArray addObject:modelObject];
                            }
                            returnModel = modelObjectArray; 
                        }else{
                            returnModel = [[modelClass alloc] initWithDictionary:[validated objectAtIndexOrNil:0]];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(returnModel, nil);
                    }
                });
            }
        }];
}
-(void)validateResponseObject:(id)responseObject completion:(void (^)(id validated))completion{
    
//    VLog(@"response %@", responseObject);
    
    dispatch_async(self.jsonProcessingQueue, ^{

        id returnObject = nil;
        
        if (responseObject) {
            if ([responseObject respondsToSelector:@selector(objectForKeyOrNil:)]) {
                if ([[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"complete"] boolValue]) {
                    returnObject = [[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"data"];
                }else{
                    DLog(@"error on api %@", responseObject);
                    NSError *error = [NSError waxAPIErrorFromResponse:[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"error"]];
                    if (error.code == 9001) {
                        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Logged out for security", @"Logged out for security") error:error buttonHandler:^{
                            [[WaxUser currentUser] logOut];
                        } logError:YES];
                    }else if (error.code > 9001){
                        returnObject = error; //perhaps handle these differently! 
                    }else{
                        returnObject = error;
                    }
                }
            }
        }
        if (completion) {
            completion(returnObject); 
        }
    });
}
























@end