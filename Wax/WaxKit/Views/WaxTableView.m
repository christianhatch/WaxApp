//
//  WaxTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#define isInitialRefresh !self.hasRefreshedOnce

#import "WaxTableView.h"

@interface WaxTableView ()
@property (nonatomic, strong) WaxEmptyView *emptyView;
@property (nonatomic, readonly) CGRect rectForEmptyView; 
@property (nonatomic, assign) BOOL hasRefreshedOnce; 
@end

@implementation WaxTableView
@synthesize automaticallyDeselectRow = _automaticallyDeselectRow, automaticallyHideInfiniteScrolling = _automaticallyHideInfiniteScrolling, emptyView = _emptyView, hasRefreshedOnce = _hasRefreshedOnce, automaticallyReFetchDataWhenAddedToSuperview = _automaticallyReFetchDataWhenAddedToSuperview; 

#pragma mark - Alloc & Init
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        self.delegate = self;
        self.dataSource = self;
        self.automaticallyHideInfiniteScrolling = YES;
        self.automaticallyDeselectRow = YES;
        self.automaticallyReFetchDataWhenAddedToSuperview = YES; 
    }
    return self; 
}

#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil; 
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.automaticallyDeselectRow) [self deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Public API
-(void)reFetchDataWithInfiniteScroll:(BOOL)infiniteScroll{
    self.hasRefreshedOnce = YES;
}

-(void)finishDataReFetchWithReFetchError:(NSError *)error{
    
    [self stopAnimatingFetchViews];
    [self reloadData];
}

-(NSMutableArray *)proxyDataSourceArray{
    return nil;
}

#pragma mark - (Internal) Overrides
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    if (self.superview == nil && newSuperview != nil) {
        
        [self reloadData];
        
        if (self.automaticallyReFetchDataWhenAddedToSuperview) {
            [self reFetchDataWithInfiniteScroll:NO];
        }
    }
}

-(void)reloadData{
    [super reloadData];
    [self updateEmptyView];
}
-(void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self updateEmptyView];
}



#pragma mark - EmptyView

-(void)setEmptyView:(WaxEmptyView *)emptyView{

    if (_emptyView == emptyView) return;

    WaxEmptyView *oldView = _emptyView;
    _emptyView = emptyView;
    
    [oldView removeFromSuperview];
    
    [self updateEmptyView];
}

-(WaxEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [WaxEmptyView emptyViewWithFrame:self.rectForEmptyView];
    }
    return _emptyView;
}

#pragma mark - Internal Methods
-(void)updateEmptyView{
    
    //first update the state of the empty view, regardless of whether or not the emptyview is shown currently or should be shown
    self.emptyView.state = self.hasRefreshedOnce ? EmptyViewStateStandard : EmptyViewStateInitial;
    self.scrollEnabled = self.hasRefreshedOnce;
    
    const bool shouldShowEmptyView = self.proxyDataSourceArray.count == 0;
    const bool emptyViewShown      = self.emptyView.superview != nil;

    if (shouldShowEmptyView == emptyViewShown) return;
    
    shouldShowEmptyView ? [self showEmptyView] : [self hideEmptyView]; 
}

-(void)showEmptyView{
    self.emptyView.frame = self.rectForEmptyView;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve |
     UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        [self addSubview:self.emptyView];
                    } completion:nil];
}
-(void)hideEmptyView{
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve |
     UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        [self.emptyView removeFromSuperview];
                        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    } completion:^(BOOL finished) {
                        self.scrollEnabled = YES;
                    }];

}
#pragma mark - Convenience
-(void)stopAnimatingFetchViews {
    if (self.pullToRefreshView.state != SVPullToRefreshStateStopped) [self.pullToRefreshView stopAnimating];
    if (self.infiniteScrollingView.state != SVInfiniteScrollingStateStopped) [self.infiniteScrollingView stopAnimating];

    if (self.automaticallyHideInfiniteScrolling) {
        
        BOOL dataSourceIsEmpty = [NSArray isEmptyOrNil:self.proxyDataSourceArray];
        BOOL dataSourceIsBatchOfTen = [self.proxyDataSourceArray countIsDivisibleBy:kAPIBatchCountDefault];
        
        self.showsInfiniteScrolling = (dataSourceIsBatchOfTen && !dataSourceIsEmpty);
    }
}

-(CGRect)rectForEmptyView{
    
    if (self.tableHeaderView) {
        CGRect frame = self.bounds;
        frame.origin.y = self.tableHeaderView.frame.size.height;
        frame.size.height -= self.tableHeaderView.bounds.size.height;
        return frame;
    }
    
    return self.bounds;
}



@end
