//
//  WaxTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import "WaxTableViewCell.h"


@interface WaxTableView : UITableView <UITableViewDataSource, UITableViewDelegate> 


-(void)handleUpdatingFeedWithError:(NSError *)error; 
-(void)finishLoading;
-(NSMutableArray *)proxyDataSourceArray; 

@property (nonatomic, readwrite) BOOL automaticallyDeselectRow;
@property (nonatomic, readwrite) BOOL automaticallyHideInfiniteScrolling; 


@end
