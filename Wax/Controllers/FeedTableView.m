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

@interface FeedTableView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *dataSourceID; 
@end

@implementation FeedTableView
@synthesize dataSourceID; 

+(FeedTableView *)feedTableViewForTag:(NSString *)tag frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFrame:frame];
    feedy.feedType = WaxFeedTableViewTypeTagFeed;
    feedy.dataSourceID = tag; 
    return feedy; 
}
+(FeedTableView *)feedTableViewForUserID:(NSString *)userID frame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFrame:frame];
    feedy.feedType = WaxFeedTableViewTypeUserFeed;
    feedy.dataSourceID = userID;
    return feedy;
}
+(FeedTableView *)feedTableViewForHomeWithFrame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFrame:frame];
    feedy.feedType = WaxFeedTableViewTypeHomeFeed;
    return feedy;
}
+(FeedTableView *)feedTableViewForMeWithFrame:(CGRect)frame{
    FeedTableView *feedy = [[FeedTableView alloc] initWithFrame:frame];
    feedy.feedType = WaxFeedTableViewTypeMyFeed;
    return feedy;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = kFeedCellHeight; 
        
        __block FeedTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:NO];
        }];
        [self addInfiniteScrollingWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:YES];
        }];
    }
    return self;
}
#pragma mark - Internal Methods
-(void)refreshDataWithInfiniteScroll:(BOOL)infiniteScroll{
    switch (self.feedType) {
        case WaxFeedTableViewTypeMyFeed:{
            [[WaxDataManager sharedManager] updateMyFeedWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeed:error]; 
            }];
        }break;
        case WaxFeedTableViewTypeHomeFeed:{
            [[WaxDataManager sharedManager] updateHomeFeedWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeed:error];
            }];
        }break;
        case WaxFeedTableViewTypeUserFeed:{
            [[WaxDataManager sharedManager] updateProfileFeedForUserID:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeed:error];
            }];
        }break;
        case WaxFeedTableViewTypeTagFeed:{
            [[WaxDataManager sharedManager] updateFeedForTag:self.dataSourceID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeed:error];
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
 
    static NSString *CellID = @"FeedCellID";
    FeedCell *cell = [self dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
        cell = [topObjects objectAtIndexOrNil:0];
    }
    cell.videoObject = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row]; 
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kFeedCellHeight;
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
-(void)handleUpdatingFeed:(NSError *)error{
    if (!error) {
        [self reloadData];
        [self stopAnimatingReloaderViews];
        if ([[self proxyDataSourceArray] countIsNotDivisibleBy10]) {
            self.showsInfiniteScrolling = NO;
        }
    }else{
        [self stopAnimatingReloaderViews];
        
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
