//
//  WaxAPIErrorManagerService.m
//  Wax
//
//  Created by Christian Hatch on 8/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxAPIErrorManagerService.h"

@interface WaxAPIErrorManagerService ()
@property (nonatomic, strong) dispatch_queue_t callbackQueue;
@end

@implementation WaxAPIErrorManagerService

-(void)logMessage:(NSString *)message{
    WaxAPIBugObject *bug = [WaxAPIBugObject bugForIOSWithError:nil description:message];
    [[WaxAPIErrorManagerService sharedInstance] postBugToAPI:bug];
}
-(void)logError:(NSError *)error{
    WaxAPIBugObject *bug = [WaxAPIBugObject bugForIOSWithError:error description:nil];
    [[WaxAPIErrorManagerService sharedInstance] postBugToAPI:bug];
}
-(void)logError:(NSError *)error withMessage:(NSString *)message{
    WaxAPIBugObject *bug = [WaxAPIBugObject bugForIOSWithError:error description:message];
    [[WaxAPIErrorManagerService sharedInstance] postBugToAPI:bug]; 
}
-(void)logNetworkErrorWithRequestOperation:(AFHTTPRequestOperation *)request error:(NSError *)error description:(NSString *)description{
    WaxAPIBugObject *bug = [WaxAPIBugObject bugForAPIWithRequestOperation:request error:error description:description];
    [[WaxAPIErrorManagerService sharedInstance] postBugToAPI:bug];
}




#pragma mark - Master Methods
-(void)postBugToAPI:(WaxAPIBugObject *)bugObject{
    
    DDLogWarn(@"Bug %@", bugObject);
    
    [self postPath:@"bugs" parameters:[bugObject dictionaryRepresentation] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogWarn(@"WaxAPIErrorManagerService Error:\nOperation=%@. Error=%@", operation, error);
    }];
}








#pragma mark - Overrides
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.allowsInvalidSSLCertificate = NO;
    self.callbackQueue = dispatch_queue_create("com.wax.apierrormanagerservice.callbackqueue", NULL);
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

- (NSDictionary *)addAuthenticationToParameters:(NSDictionary *)parameters {
    
    NSDictionary *authDict = @{@"username":CollectionSafeObject([WaxUser currentUser].username), @"userid":CollectionSafeObject([WaxUser currentUser].userID)};
    
    if ([NSDictionary isEmptyOrNil:parameters]) {
        return authDict;
    }
    
    NSMutableDictionary *authentication = [NSMutableDictionary dictionaryWithDictionary:authDict];
    [authentication addEntriesFromDictionary:parameters];
    return authentication;
}

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters{
    return [super requestWithMethod:method path:path parameters:[self addAuthenticationToParameters:parameters]];
}

-(void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation{
    operation.failureCallbackQueue = self.callbackQueue;
    operation.successCallbackQueue = self.callbackQueue;
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        //TODO: add an 'upload operation expired block' to this method so I can handle this on the videouploadmanager
    }];
    [super enqueueHTTPRequestOperation:operation];
}

#pragma mark - Boilerplate
+ (WaxAPIErrorManagerService *)sharedInstance{
    static WaxAPIErrorManagerService *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[WaxAPIErrorManagerService alloc] initWithBaseURL:[NSURL URLWithString:kWaxAPIBaseURL]];
    });
    return _sharedClient;
}





@end