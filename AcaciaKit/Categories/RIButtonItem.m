//
//  RIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "RIButtonItem.h"
#import "NSString+AcaciaKit.h"

@implementation RIButtonItem
@synthesize label, action; 

+(id)item{
    return [self new];
}
+(id)itemWithLabel:(NSString *)inLabel action:(void (^)(void))action{
    RIButtonItem *newItem = [RIButtonItem item];
    newItem.label = inLabel;
    newItem.action = action;
    return newItem;
}
+(id)itemWithLabel:(NSString *)inLabel{
    RIButtonItem *newItem = [RIButtonItem item];
    newItem.label = inLabel;
    newItem.action = nil;
    return newItem;
}
+(id)cancelButton{
    return [self itemWithLabel:@"Cancel" action:nil];
}
+(id)okayButton{
    return [self itemWithLabel:@"OK" action:nil];
}
+(id)dismissButton{
    return [self itemWithLabel:@"Dismiss" action:nil];
}
+(id)randomDismissalButton{
    return [self itemWithLabel:[NSString randomDismissalMessage] action:nil]; 
}

@end

