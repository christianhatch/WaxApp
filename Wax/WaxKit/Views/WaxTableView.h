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


@interface WaxTableView : UITableView <UITableViewDataSource, UITableViewDelegate> 

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style; //designated initalizer, required to properly initalize the class

-(void)handleUpdatingFeedWithError:(NSError *)error; //must implement this and call super when loading is finished


-(NSMutableArray *)proxyDataSourceArray; //must implement this and ovveride 
@property (nonatomic, readwrite) BOOL automaticallyDeselectRow; //default is YES
@property (nonatomic, readwrite) BOOL automaticallyHideInfiniteScrolling; //default is YES

-(void)setEmptyViewMessageText:(NSString *)message;


@end
