//
//  FeedTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, WaxFeedTableViewType){
    WaxFeedTableViewTypeMyFeed = 1,
    WaxFeedTableViewTypeHomeFeed,
    WaxFeedTableViewTypeUserFeed,
    WaxFeedTableViewTypeTagFeed,
};


#import <UIKit/UIKit.h>

@interface FeedTableView : UITableView

+(FeedTableView *)feedTableViewForMeWithFrame:(CGRect)frame;
+(FeedTableView *)feedTableViewForHomeWithFrame:(CGRect)frame;

+(FeedTableView *)feedTableViewForUserID:(NSString *)userID frame:(CGRect)frame;
+(FeedTableView *)feedTableViewForTag:(NSString *)tag frame:(CGRect)frame;

-(instancetype)initWithWaxFeedTableViewType:(WaxFeedTableViewType)feedtype tagOrUserID:(NSString *)tagOrUserID frame:(CGRect)frame;


@property (nonatomic) WaxFeedTableViewType feedType;


@end
