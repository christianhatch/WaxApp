//
//  WaxTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTableView.h"

@interface WaxTableView ()
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) NSString *emptyViewText;
@end

@implementation WaxTableView
@synthesize automaticallyDeselectRow = _automaticallyDeselectRow, automaticallyHideInfiniteScrolling = _automaticallyHideInfiniteScrolling, emptyView = _emptyView, emptyViewText = _emptyViewText; 

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

#pragma mark - Public API
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
        BOOL dataSourceIsEmpty = [NSArray isEmptyOrNil:[self proxyDataSourceArray]];        
        if (dataSourceIsEmpty) {
            self.showsInfiniteScrolling = NO; 
        }
        
        BOOL dataSourceIsBatchOfTen = [[self proxyDataSourceArray] countIsDivisibleBy:kAPIBatchCountDefault];
        if (!dataSourceIsBatchOfTen) {
            self.showsInfiniteScrolling = NO; 
        }
        if (dataSourceIsBatchOfTen && !dataSourceIsEmpty) {
            self.showsInfiniteScrolling = YES; 
        }
    }
    [self updateEmptyView];
}
-(void)setEmptyViewMessageText:(NSString *)message{
    self.emptyViewText = message;
    [self updateEmptyView];
}


#pragma mark - Setters
-(void)setEmptyView:(UIView *)emptyView{

    if (_emptyView == emptyView) return;

    UIView *oldView = _emptyView;
    _emptyView = emptyView;
    
    [oldView removeFromSuperview];
    
    [self updateEmptyView];
}

#pragma mark - Getters
-(UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:[self rectForEmptyView]];
        _emptyView.autoresizesSubviews = YES;
        _emptyView.backgroundColor = [UIColor whiteColor];
        
    //for debugging
//        _emptyView.backgroundColor = [UIColor greenColor]; 
//        _emptyView.layer.borderWidth = 5;
//        _emptyView.layer.borderColor = [UIColor blueColor].CGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(_emptyView.bounds, (_emptyView.bounds.size.width/10), (_emptyView.bounds.size.height/10))];
        [label setWaxHeaderFontOfSize:15 color:[UIColor waxHeaderFontColor]];
        label.text = self.emptyViewText;
        label.center = _emptyView.center;
        label.textAlignment = NSTextAlignmentCenter;
        label.minimumScaleFactor = 0.2;
        label.numberOfLines = 0;
        
    //for debugging
//        label.backgroundColor = [UIColor redColor];
//        label.layer.borderWidth = 5; 
//        label.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [_emptyView addSubview:label];
    }
    return _emptyView;
}
-(NSString *)emptyViewText{
    if (!_emptyViewText) {
        _emptyViewText = NSLocalizedString(@"No Content :(", @"No Content :("); 
    }
    return _emptyViewText; 
}

#pragma mark - Internal Methods
-(void)updateEmptyView{
    
    self.emptyView.frame  = [self rectForEmptyView];
    
    const bool shouldShowEmptyView = [[self proxyDataSourceArray] count] == 0;
    const bool emptyViewShown      = self.emptyView.superview != nil;
    
    if (shouldShowEmptyView == emptyViewShown) return;
    
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:AIKDefaultAnimationDuration];
//    [animation setType:kCATransitionFade];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [[self layer] addAnimation:animation forKey:kCATransitionReveal];
    
    if (shouldShowEmptyView){
        for (UILabel *label in self.emptyView.subviews) {
            if ([label respondsToSelector:@selector(setText:)]) {
                label.text = self.emptyViewText;
                label.frame = [self rectForLabel];
                label.center = CGPointMake(self.emptyView.bounds.size.width/2, self.emptyView.bounds.size.height/2);
            }
        }
        [self addSubview:self.emptyView];
    }else{
        [self.emptyView removeFromSuperview];
    }
}
-(CGRect)rectForEmptyView{
    if (self.tableHeaderView) {
        CGRect frame = self.frame;
        frame.origin.y = self.tableHeaderView.frame.size.height;
        frame.size.height -= self.tableHeaderView.frame.size.height;
        return frame; 
    }else{
        return self.frame;
    }
}
-(CGRect)rectForLabel{
    return CGRectInset(_emptyView.bounds, (_emptyView.bounds.size.width/10), (_emptyView.bounds.size.height/10)); 
}



@end
