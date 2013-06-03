//
//  WaxTests.m
//  WaxTests
//
//  Created by Christian Hatch on 4/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTests.h"
#import "WaxKit.h"

@implementation WaxTests

- (void)setUp{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testJSONFromFileNamed{
    id json = [WaxTests JSONFromFileNamed:@"persons"];
    STAssertNotNil(json, @"json should not be nil!");
    STAssertFalse([json isKindOfClass:[NSError class]], @"json should not be an error!");
    STAssertTrue([NSJSONSerialization isValidJSONObject:json], @"json object is valid");
}

+(id)JSONFromFileNamed:(NSString *)fileName{

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    
    NSError *dataError = nil;
    NSError *jsonError = nil;
    
    NSData *data = [NSData dataWithContentsOfFile:resource options:kNilOptions error:&dataError];
    if (dataError) {
        return dataError;
    }else{
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError) {
            return jsonError;
        }else{
            return jsonData;
        }
    }
}





@end
