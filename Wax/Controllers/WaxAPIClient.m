//
//  KiwiNetClient.m
//  Kiwi
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

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
-(void)createAccountWithUsername:(NSString *)username fullName:(NSString *)fullName email:(NSString *)email passwordOrFacebookID:(NSString *)passwordOrFacebookID completion:(WaxAPIClientCompletionBlockTypeLogin)completion{
 
    if (username && fullName && email && passwordOrFacebookID) {
       
        [self postPath:@"logins/signup" parameters:@{@"username":username, @"name":fullName, @"email":email, ([[AIKFacebookManager sharedManager] sessionIsActive] ? @"facebookid" : @"password"):passwordOrFacebookID} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)loginWithFacebookID:(NSString *)facebookID fullName:(NSString *)fullName email:(NSString *)email completion:(WaxAPIClientCompletionBlockTypeLogin)completion{
    if (facebookID && fullName && email) {
        
        [self postPath:@"logins/facebook" parameters:@{@"name":fullName, @"email":email, @"facebookid":facebookID} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(WaxAPIClientCompletionBlockTypeLogin)completion{
    if (username && password) {
        
        [self postPath:@"logins/login" parameters:@{@"username":username, @"password":password} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
        
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}

#pragma mark - Feeds
-(void)fetchFeedForUser:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (personID) {
        [self fetchFeedFromPath:@"feeds/user" tagOrPersonID:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error); 
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)fetchHomeFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if ([[WaxUser currentUser] isLoggedIn]) {
        [self fetchFeedFromPath:@"feeds/home" tagOrPersonID:[[WaxUser currentUser] userID] infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }
}
-(void)fetchFeedForTag:(NSString *)tag sortedBy:(WaxAPIClientTagSortType)sortedBy infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (tag && sortedBy) {
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
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}

#pragma mark - Users
-(void)toggleFollowUser:(NSString *)personID completion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    if (personID) {
        
        [self postPath:@"users/put" parameters:@{@"personid":personID} modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion([[model objectForKeyOrNil:@"complete"] boolValue], error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)fetchProfileInformationForUser:(NSString *)personID completion:(WaxAPIClientCompletionBlockTypeUser)completion{
    if (personID) {
        
        [self postPath:@"users/profile" parameters:@{@"personid": personID} modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
        
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)fetchFollowersForUser:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (personID) {
        [self fetchPeopleFromPath:@"users/followers" personId:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)fetchFollowingForUser:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (personID) {
        [self fetchPeopleFromPath:@"users/following" personId:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)searchForUser:(NSString *)searchTerm infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (searchTerm) {
        [self fetchPeopleFromPath:@"users/search" personId:searchTerm infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)syncFacebookProfilePictureWithCompletion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    [self postPath:@"settings/update_picture" parameters:@{@"facebook": @1} modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion([[model objectForKeyOrNil:@"complete"] boolValue], error);
        }
    }];
}
-(void)uploadProfilePicture:(UIImage *)profilePicture progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
        
    UIImage *square = [UIImage cropImageToSquare:profilePicture];
    NSData *picData = UIImageJPEGRepresentation(square, 0.01);
        
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:@"settings/update_picture" parameters:@{@"facebook": @0} constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:picData name:@"profile_picture" fileName:@"profile_picture.jpg" mimeType:@"image/jpeg"];
    }];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat proggy = (float)(totalBytesWritten/totalBytesExpectedToWrite);
        
        if (progress) {
            progress(proggy, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite); 
        }
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject forModelClass:nil withCompletionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(responseObject, error);
            }
        }]; 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}


#pragma mark - Videos
-(void)uploadVideoMetadata:(NSString *)videoLink videoLength:(NSNumber *)videoLength tag:(NSString *)tag category:(NSString *)category caption:(NSString *)caption location:(CLLocation *)location completion:(WaxAPIClientCompletionBlockTypeVideoUpload)completion{
    
    if (videoLink && videoLength && tag && category) {
       
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:videoLink, @"videolink", videoLength, @"videolength", tag, @"tag", category, @"category", caption, @"caption", [NSNumber numberWithDouble:location.coordinate.latitude], @"lat", [NSNumber numberWithDouble:location.coordinate.longitude], @"lon", nil];
      
        [self postPath:@"videos/put" parameters:params modelClass:nil completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion([model objectForKeyOrNil:@"shareid"], error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)fetchMetadataForVideo:(NSString *)videoID completion:(WaxAPIClientCompletionBlockTypeVideo)completion{
    
    if (videoID) {
        [self postPath:@"videos/get" parameters:@{@"videoid":videoID} modelClass:[VideoObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error); 
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)voteUpVideo:(NSString *)videoID ofUser:(NSString *)personID completion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    
    if (videoID && personID) {
        
        [self postPath:@"videos/vote" parameters:@{@"videoid":videoID, @"personid":personID} modelClass:nil completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion([[model objectForKeyOrNil:@"complete"] boolValue], error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)performAction:(WaxAPIClientVideoActionType)actionType onVideoID:(NSString *)videoID completion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    
    if (actionType && videoID) {
        
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
                completion([[model objectForKeyOrNil:@"complete"] boolValue], error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}

#pragma mark - Settings
-(void)fetchSettingsWithCompletion:(WaxAPIClientCompletionBlockTypeSettings)completion{
    [self postPath:@"settings/get" parameters:nil modelClass:[SettingsObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error); 
        }
    }];
}
-(void)updateSettings:(NSString *)email fullName:(NSString *)fullName pushSettings:(NSDictionary *)pushSettings completion:(WaxAPIClientCompletionBlockTypeSettings)completion{
    
    if (email && fullName && pushSettings) {
        [self postPath:@"settings/update" parameters:@{@"email":email, @"name":fullName, @"pushsettings":pushSettings} modelClass:[SettingsObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}


#pragma mark - Internal Methods
-(void)fetchFeedFromPath:(NSString *)path tagOrPersonID:(NSString *)tagOrPersonID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{

    if (path && tagOrPersonID) {
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:tagOrPersonID, @"feedid", infiniteScrollingID, @"lastitem", nil];

        [self postPath:path parameters:params modelClass:[VideoObject class] completionBlock:^(id model, NSError *error) {
                if (completion) {
                    completion(model, error);
                }
            }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}

-(void)fetchPeopleFromPath:(NSString *)path personId:(NSString *)personId infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
        
    if (path && personId) {

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:personId, @"personid", infiniteScrollingID, @"lastitem", nil];

        [self postPath:path parameters:params modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke %@ with nil paramaters!", NSStringFromSelector(@selector(_cmd))];
    }
}
-(void)postPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass completionBlock:(void (^)(id model, NSError *error))completion{
    
    if (path) {
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObject:responseObject forModelClass:modelClass withCompletionBlock:^(id model, NSError *error) {
                if (completion) {
                    completion(model, error);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([error.domain isEqualToString:(NSString *)kCFErrorDomainCFNetwork] || [error.domain isEqualToString:NSURLErrorDomain]) {
                [[AIKErrorManager sharedManager] showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion buttonHandler:^{
                    if (completion) {
                        completion(nil, error);
                    }
                }];
            }else{
                if (completion) {
                    completion(nil, error);
                } 
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot post without a path!"];
    }
}
-(void)processResponseObject:(id)responseObject forModelClass:(Class)modelClass withCompletionBlock:(void (^)(id model, NSError *error))completion{

//    dispatch_async(self.jsonProcessingQueue, ^{
    
        [self validateResponseObject:responseObject completion:^(id response) {
            id validated = response;
            
            if ([validated isKindOfClass:[NSError class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil, validated);
                    }
                });
            }else{
                id returnModel = validated;
                if (modelClass) {
                    if ([validated respondsToSelector:@selector(objectAtIndexOrNil:)] && [validated respondsToSelector:@selector(count)]) {
                        if ([validated count] > 1) {
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
//    });
}
-(void)validateResponseObject:(id)responseObject completion:(void (^)(id response))completion{
    
    DLog(@"response %@", responseObject);
    
    dispatch_async(self.jsonProcessingQueue, ^{

        id returnObject = nil;
        
        if (responseObject) {
            if ([responseObject respondsToSelector:@selector(objectForKeyOrNil:)]) {
                if ([[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"complete"] boolValue]) {
                    returnObject = [[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"data"];
                }else{
                    NSError *error = [NSError waxAPIErrorFromResponse:[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"error"]];
                    if (error.code == 9001) {
                        [[AIKErrorManager sharedManager] logErrorWithMessage:NSLocalizedString(@"Logged out for security", @"Logged out for security") error:error andShowAlertWithButtonHandler:^{
                            [[WaxUser currentUser] logOut];
                        }];
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