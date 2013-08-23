//
//  WaxAPIBugObject.m
//  Wax
//
//  Created by Christian Hatch on 8/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxAPIBugObject.h"

@interface WaxAPIBugObject ()

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic) WaxAPIBugObjectType bugType;

@end

@implementation WaxAPIBugObject

+(WaxAPIBugObject *)bugForAPIWithRequestOperation:(AFHTTPRequestOperation *)requestion error:(NSError *)error description:(NSString *)description{
    WaxAPIBugObject *bug = [[WaxAPIBugObject alloc] initWithBugType:WaxAPIBugObjectTypeAPI error:error description:description];
    bug.APIRequestOperation = requestion;
    return bug; 
}
+(WaxAPIBugObject *)bugForIOSWithError:(NSError *)error description:(NSString *)description{
    return [[WaxAPIBugObject alloc] initWithBugType:WaxAPIBugObjectTypeIOS error:error description:description];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.userID = [WaxUser currentUser].userID;
        self.username = [WaxUser currentUser].username;
        self.appVersion = [WaxAPIBugObject appVersion];
        self.systemVersion = [WaxAPIBugObject systemVersion];
    }
    return self;
}
-(instancetype)initWithBugType:(WaxAPIBugObjectType)type error:(NSError *)error description:(NSString *)description{
    self = [self init];
    if (self) {
        self.bugType = type;
        self.error = error;
        self.bugDescription = description;
    }
    return self;
}

-(NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *dictionaryRep = [NSMutableDictionary dictionaryWithDictionary:
                                        @{@"type": CollectionSafeObject([NSNumber numberWithInteger:self.bugType]),
                                          @"description": CollectionSafeObject(self.bugDescription),
                                          @"ios_version":CollectionSafeObject(self.systemVersion),
                                          @"app_version":CollectionSafeObject(self.appVersion),
                                          @"userid":CollectionSafeObject(self.userID),
                                          @"username":CollectionSafeObject(self.username),
                                          @"data" :CollectionSafeObject(self.error)
                                          }];
    
    if (self.bugType == WaxAPIBugObjectTypeAPI) {
        [dictionaryRep setObject:CollectionSafeObject(self.APIRequestOperation.description) forKey:@"data"];
        [dictionaryRep setObject:CollectionSafeObject(self.error.description) forKey:@"error"];
    }else{
        [dictionaryRep setObject:CollectionSafeObject(self.error) forKey:@"data"]; 
    }
    return dictionaryRep;
}





#pragma mark - Helper Methods
+(NSString *)appVersion{
    return [UIApplication appVersionAndBuildString];
}
+(NSString *)systemVersion{
    return [UIDevice deviceModelAndVersionString];
}





@end
