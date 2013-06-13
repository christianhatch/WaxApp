//
//  PersonTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, PersonTableViewType){
    PersonTableViewTypeFollowing = 1,
    PersonTableViewTypeFollowers,
};

//typedef void(^CategoryTableViewDidSelectCategoryBlock)(NSString *category);


#import "WaxTableView.h"

@interface PersonTableView : WaxTableView

+(PersonTableView *)personTableViewForFollowingWithUserID:(NSString *)userID frame:(CGRect)frame;
+(PersonTableView *)personTableViewForFollowwersWithUserID:(NSString *)userID frame:(CGRect)frame;

-(instancetype)initWithPersonTableViewType:(PersonTableViewType)tableViewType userID:(NSString *)userID frame:(CGRect)frame;


@property (nonatomic) PersonTableViewType tableViewType;



@end
