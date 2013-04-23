//
//  NSNotificationCenter+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 12/26/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSNotificationCenter+AcaciaKit.h"

@implementation NSNotificationCenter (AcaciaKit)

- (void)postNotificationOnMainThread:(NSNotification *)notification{
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
}

- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
	[self postNotificationOnMainThread:notification];
}

- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
	[self postNotificationOnMainThread:notification];
}


@end
