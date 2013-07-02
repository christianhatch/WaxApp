//
//  WaxTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTableView.h"

@implementation WaxTableView
@synthesize automaticallyDeselectRow = _automaticallyDeselectRow, automaticallyHideInfiniteScrolling = _automaticallyHideInfiniteScrolling; 


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        self.delegate = self;
        self.dataSource = self;
        self.automaticallyHideInfiniteScrolling = YES;
        self.automaticallyDeselectRow = YES; 
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
    if (self.automaticallyDeselectRow) {
        [self deselectRowAtIndexPath:indexPath animated:YES]; 
    }
}

-(void)handleUpdatingFeedWithError:(NSError *)error{
    [self finishLoading]; 
}
-(NSMutableArray *)proxyDataSourceArray{
    return [NSMutableArray array]; 
}
-(void)finishLoading{
    [self reloadData];
    if (self.pullToRefreshView.state != SVPullToRefreshStateStopped) {
        [self.pullToRefreshView stopAnimating];
    }
    if (self.infiniteScrollingView.state != SVPullToRefreshStateStopped) {
        [self.pullToRefreshView stopAnimating];
    }
    if (self.automaticallyHideInfiniteScrolling) {
        BOOL dataSourceIsEmptyOrNotABatchOfTen = ([[self proxyDataSourceArray] countIsNotDivisibleBy10] || ([[self proxyDataSourceArray] count] == 0));
        self.showsInfiniteScrolling = !dataSourceIsEmptyOrNotABatchOfTen;
    }
}



@end
