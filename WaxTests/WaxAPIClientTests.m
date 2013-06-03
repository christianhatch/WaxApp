//
//  WaxAPIClientTests.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxAPIClientTests.h"
#import "WaxTests.h"
#import "WaxAPIClient.h"

@interface WaxAPIClientTests ()
@end

@implementation WaxAPIClientTests

-(void)setUp{
    [super setUp];

}

-(void)tearDown{
    
    [super tearDown];
}

-(void)testJSONPersonProcessing{
//    [[WaxAPIClient sharedClient] processArrayOf:[PersonObject class] fromResponseObject:[WaxTests JSONFromFileNamed:@"persons"] withCompletionBlock:^(NSMutableArray *processedResponse) {
//        
//        for (PersonObject *person in processedResponse) {
//            STAssertFalse([person isMemberOfClass:[PersonObject class]], @"Did not return an array of non-null PersonObjects!");
//            STAssertTrue([person isKindOfClass:[NSNull class]], @"Did not return an array of non-null PersonObjects!");
//        }
//        
//    }];
}
-(void)testJSONFeedProcessing{
//    [[WaxAPIClient sharedClient] processArrayOf:[VideoObject class] fromResponseObject:[WaxTests JSONFromFileNamed:@"videos"] withCompletionBlock:^(NSMutableArray *processedResponse) {
//
//        for (VideoObject *video in processedResponse) {
//            STAssertFalse([video isMemberOfClass:[VideoObject class]], @"Did not return an array of non-null VideoObjects!");
//            STAssertTrue([video isKindOfClass:[NSNull class]], @"Did not return an array of non-null VideoObjects!");
//        }
//
//    }];
}



@end
