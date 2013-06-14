//
//  FeedTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, FeedTableViewType){
    FeedTableViewTypeMyFeed = 1,
    FeedTableViewTypeHomeFeed,
    FeedTableViewTypeUserFeed,
    FeedTableViewTypeCategoryFeed,
    FeedTableViewTypeTagFeed,
};


#import "WaxTableView.h"

@interface FeedTableView : WaxTableView

+(FeedTableView *)feedTableViewForMeWithFrame:(CGRect)frame;
+(FeedTableView *)feedTableViewForHomeWithFrame:(CGRect)frame;

+(FeedTableView *)feedTableViewForUserID:(NSString *)userID frame:(CGRect)frame;
+(FeedTableView *)feedTableViewForTag:(NSString *)tag frame:(CGRect)frame;
+(FeedTableView *)feedTableViewForCategory:(NSString *)tag frame:(CGRect)frame;

-(instancetype)initWithFeedTableViewType:(FeedTableViewType)feedtype tagOrUserID:(NSString *)tagOrUserID frame:(CGRect)frame;

-(void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic) FeedTableViewType tableViewType;


@end
