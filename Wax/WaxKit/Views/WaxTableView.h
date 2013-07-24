//
//  WaxTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "WaxTableViewCell.h"

@class WaxEmptyView;

@interface WaxTableView : UITableView <UITableViewDataSource, UITableViewDelegate> 

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style; //Designated initalizer, required to properly initalize the class

-(void)reFetchDataWithInfiniteScroll:(BOOL)infiniteScroll; //MUST call this method to re-fetch data, MUST call super!
-(void)finishDataReFetchWithReFetchError:(NSError *)error; //MUST call this method to finish refreshing data, MUST call super!

@property (nonatomic, readonly) NSMutableArray *proxyDataSourceArray; //MUST override getter

@property (nonatomic, assign) BOOL automaticallyDeselectRow; //Default is YES
@property (nonatomic, assign) BOOL automaticallyHideInfiniteScrolling; //Default is YES
@property (nonatomic, assign) BOOL automaticallyReFetchDataWhenAddedToSuperview; //Default is YES

@property (nonatomic, readonly) WaxEmptyView *emptyView;



@end
