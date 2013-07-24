//
//  WaxEmptyView.h
//  Wax
//
//  Created by Christian Hatch on 7/24/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, WaxEmptyViewState){
    EmptyViewStateInitial = 1,
    EmptyViewStateStandard,
};

#import <UIKit/UIKit.h>

@interface WaxEmptyView : UIView

+(WaxEmptyView *)emptyViewWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSString *labelText; //Default is @"No Content :(" If overriding, must set this before calling handleUpdatingFeedWithError:

@property (nonatomic, assign) WaxEmptyViewState state;


@end
