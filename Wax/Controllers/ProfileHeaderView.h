//
//  ProfileHeaderView.h
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kProfileHeaderViewHeight 222


#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView

+(ProfileHeaderView *)profileHeaderViewForUserID:(NSString *)userID;

@property (nonatomic, strong) PersonObject *person;

-(void)refreshData;

@end
