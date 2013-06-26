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
    FeedTableViewTypeSingleVideo,
};

static inline NSString * StringFromFeedTableViewType(FeedTableViewType feedtype) {
    switch (feedtype) {
        case FeedTableViewTypeMyFeed:
            return @"MyFeed";
            break;
        case FeedTableViewTypeHomeFeed:
            return @"HomeFeed";
            break;
        case FeedTableViewTypeUserFeed:
            return @"UserFeed";
            break;
        case FeedTableViewTypeCategoryFeed:
            return @"CategoryFeed";
            break;
        case FeedTableViewTypeTagFeed:
            return @"TagFeed";
            break;
        case FeedTableViewTypeSingleVideo:
            return @"SingleVideoFeed";
            break; 
    }
}


#import "WaxTableView.h"

@interface FeedTableView : WaxTableView

+(FeedTableView *)feedTableViewForMyProfileWithFrame:(CGRect)frame;
+(FeedTableView *)feedTableViewForHomeWithFrame:(CGRect)frame;

+(FeedTableView *)feedTableViewForProfileWithUserID:(NSString *)userID frame:(CGRect)frame;
+(FeedTableView *)feedTableViewForTag:(NSString *)tag frame:(CGRect)frame;
+(FeedTableView *)feedTableViewForCategory:(NSString *)tag frame:(CGRect)frame;
+(FeedTableView *)feedTableViewForSingleVideoWithVideoID:(NSString *)videoID frame:(CGRect)frame; 

-(instancetype)initWithFeedTableViewType:(FeedTableViewType)feedtype tagOrUserID:(NSString *)tagOrUserID frame:(CGRect)frame;

-(void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic) FeedTableViewType tableViewType;


@end
