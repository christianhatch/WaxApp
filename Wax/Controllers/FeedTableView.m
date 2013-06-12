//
//  FeedTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//



#import "FeedTableView.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import "FeedCell.h"
#import "ProfileHeaderView.h"

@interface FeedTableView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *dataSourceID; 
@end

@implementation FeedTableView
@synthesize dataSourceID; 


#pragma mark - Alloc & Init
+(FeedTableView *)feedTableViewForTag:(NSString *)tag frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithWaxFeedTableViewType:WaxFeedTableViewTypeTagFeed tagOrUserID:tag frame:frame];
    return feedy; 
}
+(FeedTableView *)feedTableViewForUserID:(NSString *)userID frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithWaxFeedTableViewType:WaxFeedTableViewTypeUserFeed tagOrUserID:userID frame:frame];
    return feedy;
}
+(FeedTableView *)feedTableViewForHomeWithFrame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithWaxFeedTableViewType:WaxFeedTableViewTypeHomeFeed tagOrUserID:nil frame:frame];
    return feedy;
}
+(FeedTableView *)feedTableViewForMeWithFrame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithWaxFeedTableViewType:WaxFeedTableViewTypeMyFeed tagOrUserID:[[WaxUser currentUser] userID] frame:frame];
    return feedy;
}
-(instancetype)initWithWaxFeedTableViewType:(WaxFeedTableViewType)feedtype tagOrUserID:(NSString *)tagOrUserID frame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.feedType = feedtype;
        self.dataSourceID = tagOrUserID;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
        
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = kFeedCellHeight;
        
        [self registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:kFeedCellID];
        
        __block FeedTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:NO];
        }];
        [self addInfiniteScrollingWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:YES];
        }];
        
        if (feedtype == WaxFeedTableViewTypeMyFeed || feedtype == WaxFeedTableViewTypeUserFeed) {
            self.tableHeaderView = [ProfileHeaderView profileHeaderViewForUserID:self.dataSourceID];
        }
    }
    return self; 
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self triggerPullToRefresh]; 
}
#pragma mark - Internal Methods
-(void)refreshDataWithInfiniteScroll:(BOOL)infiniteScroll{
    switch (self.feedType) {
        case WaxFeedTableViewTypeMyFeed:{
            [[WaxDataManager sharedManager] updateMyFeedWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error]; 
            }];
        }break;
        case WaxFeedTableViewTypeHomeFeed:{
            [[WaxDataManager sharedManager] updateHomeFeedWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case WaxFeedTableViewTypeUserFeed:{
            [[WaxDataManager sharedManager] updateProfileFeedForUserID:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case WaxFeedTableViewTypeTagFeed:{
            [[WaxDataManager sharedManager] updateFeedForTag:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
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
    NSMutableArray *array = nil; 
    switch (self.feedType) {
        case WaxFeedTableViewTypeMyFeed:{
            array = [WaxDataManager sharedManager].myFeed;
        }break;
        case WaxFeedTableViewTypeHomeFeed:{
            array = [WaxDataManager sharedManager].homeFeed;
        }break;
        case WaxFeedTableViewTypeUserFeed:{
            array = [WaxDataManager sharedManager].profileFeed;
        }break;
        case WaxFeedTableViewTypeTagFeed:{
            array = [WaxDataManager sharedManager].tagFeed;
        }break;
    }
    return array; 
}
-(void)handleUpdatingFeedWithError:(NSError *)error{
    if (!error) {
        [self reloadData];
        [self stopAnimatingReloaderViews];
        if ([[self proxyDataSourceArray] countIsNotDivisibleBy10]) {
            self.showsInfiniteScrolling = NO;
        }
    }else{
        [self stopAnimatingReloaderViews];
        DLog(@"error updating feed %@", error);
        //handle error?
        switch (self.feedType) {
            case WaxFeedTableViewTypeMyFeed:{
                
            }break;
            case WaxFeedTableViewTypeHomeFeed:{
                
            }break;
            case WaxFeedTableViewTypeUserFeed:{
                
            }break;
            case WaxFeedTableViewTypeTagFeed:{
                
            }break;
        }
    }
}
-(void)stopAnimatingReloaderViews{
    if (self.pullToRefreshView.state == SVPullToRefreshStateLoading) {
        [self.pullToRefreshView stopAnimating];
    }
    if (self.infiniteScrollingView.state == SVPullToRefreshStateLoading) {
        [self.pullToRefreshView stopAnimating]; 
    }
}






@end
