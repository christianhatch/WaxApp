//
//  FeedTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//



#import "FeedTableView.h"
#import "FeedCell.h"
#import "ProfileHeaderView.h"

@interface FeedTableView ()
@property (nonatomic, strong) NSString *dataSourceID; 
@end

@implementation FeedTableView
@synthesize dataSourceID; 


#pragma mark - Alloc & Init
+(FeedTableView *)feedTableViewForCategory:(NSString *)tag frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFeedTableViewType:FeedTableViewTypeCategoryFeed tagOrUserID:tag frame:frame];
    return feedy; 
}
+(FeedTableView *)feedTableViewForTag:(NSString *)tag frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFeedTableViewType:FeedTableViewTypeTagFeed tagOrUserID:tag frame:frame];
    return feedy;
}
+(FeedTableView *)feedTableViewForProfileWithUserID:(NSString *)userID frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFeedTableViewType:FeedTableViewTypeUserFeed tagOrUserID:userID frame:frame];
    return feedy;
}
+(FeedTableView *)feedTableViewForHomeWithFrame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFeedTableViewType:FeedTableViewTypeHomeFeed tagOrUserID:nil frame:frame];
    return feedy;
}
+(FeedTableView *)feedTableViewForMyProfileWithFrame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFeedTableViewType:FeedTableViewTypeMyFeed tagOrUserID:[[WaxUser currentUser] userID] frame:frame];
    return feedy;
}
+(FeedTableView *)feedTableViewForSingleVideoWithVideoID:(NSString *)videoID frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFeedTableViewType:FeedTableViewTypeSingleVideo tagOrUserID:videoID frame:frame];
    return feedy; 
}
-(instancetype)initWithFeedTableViewType:(FeedTableViewType)feedtype tagOrUserID:(NSString *)tagOrUserID frame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.tableViewType = feedtype;
        self.dataSourceID = tagOrUserID;
        self.automaticallyHideInfiniteScrolling = YES;
        
        self.rowHeight = kFeedCellHeight;
        [self registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:kFeedCellID];
        
        if (feedtype == FeedTableViewTypeMyFeed || feedtype == FeedTableViewTypeUserFeed) {
            self.tableHeaderView = [ProfileHeaderView profileHeaderViewForUserID:self.dataSourceID];
        }

        __block FeedTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            if (feedtype == FeedTableViewTypeMyFeed || feedtype == FeedTableViewTypeUserFeed) {
                ProfileHeaderView *header = (ProfileHeaderView *)blockSelf.tableHeaderView;
                [header refreshData]; 
            }
            [blockSelf refreshDataWithInfiniteScroll:NO];
        }];
        [self addInfiniteScrollingWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:YES];
        }];
        
    }
    return self; 
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self triggerPullToRefresh]; 
}
-(void)deleteCellAtIndexPath:(NSIndexPath *)indexPath{
    [[self proxyDataSourceArray] removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft]; 
}
#pragma mark - Internal Methods
-(void)refreshDataWithInfiniteScroll:(BOOL)infiniteScroll{
    switch (self.tableViewType) {
        case FeedTableViewTypeMyFeed:{
            [[WaxDataManager sharedManager] updateMyFeedWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error]; 
            }];
        }break;
        case FeedTableViewTypeHomeFeed:{
            [[WaxDataManager sharedManager] updateHomeFeedWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case FeedTableViewTypeUserFeed:{
            [[WaxDataManager sharedManager] updateProfileFeedForUserID:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case FeedTableViewTypeTagFeed:{
            [[WaxDataManager sharedManager] updateFeedForTag:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case FeedTableViewTypeCategoryFeed:{
            [[WaxDataManager sharedManager] updateFeedForCategory:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case FeedTableViewTypeSingleVideo:{
            [[WaxDataManager sharedManager] updateFeedForVideoID:self.dataSourceID completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error]; 
            }];
        }break;
    }
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self proxyDataSourceArray].count; 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedCell *cell = [self dequeueReusableCellWithIdentifier:kFeedCellID];
    cell.videoObject = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO; 
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mark - Convenience Methods
-(NSMutableArray *)proxyDataSourceArray{
    switch (self.tableViewType) {
        case FeedTableViewTypeMyFeed:{
            return [WaxDataManager sharedManager].myFeed;
        }break;
        case FeedTableViewTypeHomeFeed:{
            return [WaxDataManager sharedManager].homeFeed;
        }break;
        case FeedTableViewTypeUserFeed:{
            return [WaxDataManager sharedManager].profileFeed;
        }break;
        case FeedTableViewTypeCategoryFeed:{
            return [WaxDataManager sharedManager].tagFeed;
        }break;
        case FeedTableViewTypeTagFeed:{
            return [WaxDataManager sharedManager].tagFeed;
        }break;
        case FeedTableViewTypeSingleVideo:{
            return [WaxDataManager sharedManager].tagFeed;
        }break;
    }
}
-(void)handleUpdatingFeedWithError:(NSError *)error{
        
    if (!error) {
        switch (self.tableViewType) {
            case FeedTableViewTypeMyFeed:{
                [self setEmptyViewMessageText:[NSString stringWithFormat:NSLocalizedString(@"You haven't made any videos yet", @"you have no videos")]];
            }break;
            case FeedTableViewTypeHomeFeed:{
                
            }break;
            case FeedTableViewTypeUserFeed:{
                [self setEmptyViewMessageText:[NSString stringWithFormat:NSLocalizedString(@"This user hasn't made any videos yet", @"user has no videos")]];
            }break;
            case FeedTableViewTypeTagFeed:{
                [self setEmptyViewMessageText:[NSString stringWithFormat:NSLocalizedString(@"No Videos for %@", @"no videos for tag"), self.dataSourceID]];
            }break;
            case FeedTableViewTypeCategoryFeed:{
                
            }break;
            case FeedTableViewTypeSingleVideo:{
                
            }break;
        }
    }else{
        VLog(@"error updating feed %@", error);

        switch (self.tableViewType) {
            case FeedTableViewTypeMyFeed:{
                [self setEmptyViewMessageText:[NSString stringWithFormat:NSLocalizedString(@"Error loading your videos", @"error loading your videos")]];
            }break;
            case FeedTableViewTypeHomeFeed:{
                
            }break;
            case FeedTableViewTypeUserFeed:{
                [self setEmptyViewMessageText:[NSString stringWithFormat:NSLocalizedString(@"Error loading this users videos", @"error loading a users videos")]];
            }break;
            case FeedTableViewTypeTagFeed:{
                [self setEmptyViewMessageText:[NSString stringWithFormat:NSLocalizedString(@"Error loading videos for %@", @"No videos text"), self.dataSourceID]];
            }break;
            case FeedTableViewTypeCategoryFeed:{
                
            }break;
            case FeedTableViewTypeSingleVideo:{
                
            }break; 
        }
    }
    
    [super handleUpdatingFeedWithError:error];
}






@end
