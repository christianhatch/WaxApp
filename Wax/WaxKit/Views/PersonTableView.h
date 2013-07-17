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

typedef void(^PersonTableViewDidSelectPersonBlock)(PersonObject *person);


#import "WaxTableView.h"

@interface PersonTableView : WaxTableView

+(PersonTableView *)personTableViewForFollowingWithUserID:(NSString *)userID didSelectBlock:(PersonTableViewDidSelectPersonBlock)selectBlock frame:(CGRect)frame;
+(PersonTableView *)personTableViewForFollowersWithUserID:(NSString *)userID didSelectBlock:(PersonTableViewDidSelectPersonBlock)selectBlock frame:(CGRect)frame;

-(instancetype)initWithPersonTableViewType:(PersonTableViewType)tableViewType userID:(NSString *)userID didSelectBlock:(PersonTableViewDidSelectPersonBlock)selectBlock frame:(CGRect)frame;

@property (nonatomic) PersonTableViewType tableViewType;
@property (nonatomic, strong) PersonTableViewDidSelectPersonBlock didSelectBlock; 
@property (nonatomic) BOOL hidesFollowButtonOnCells;

@end
