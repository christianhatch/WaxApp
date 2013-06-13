//
//  WaxTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTableView.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>

@implementation WaxTableView
@synthesize automaticallyDeselectRow = _automaticallyDeselectRow; 


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


-(void)stopAnimatingReloaderViews{
    if (self.pullToRefreshView.state != SVPullToRefreshStateStopped) {
        [self.pullToRefreshView stopAnimating];
    }
    if (self.infiniteScrollingView.state != SVPullToRefreshStateStopped) {
        [self.pullToRefreshView stopAnimating];
    }
}



@end
