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
    }
    return self; 
}


-(void)handleUpdatingFeedWithError:(NSError *)error{
    [self finishLoading]; 
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
        BOOL dataSourceIsEmptyOrNotABatchOfTen = ([[self proxyDataSourceArray] countIsNotDivisibleBy10] || [[self proxyDataSourceArray] count]); 
        self.showsInfiniteScrolling = !dataSourceIsEmptyOrNotABatchOfTen;
    }
}
-(NSMutableArray *)proxyDataSourceArray{
    return [NSMutableArray array]; //override in subclasses!
}



@end
