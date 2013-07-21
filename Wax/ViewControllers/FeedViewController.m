//
//  FeedViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableView.h"

@interface FeedViewController ()
@property (nonatomic, strong) NSString *feedID;
@property (nonatomic, strong) NSString *tag; 
@property (nonatomic, readwrite) FeedTableViewType feedType;
@property (nonatomic, strong) FeedTableView *tableView; 
@end

@implementation FeedViewController
@synthesize feedID = _feedID, feedType = _feedType, tag = _tag, tableView = _tableView; 

#pragma mark - Alloc & Init
+(FeedViewController *)feedViewControllerWithTag:(NSString *)tag{
    FeedViewController *feedy = [[FeedViewController alloc] initWithFeedID:tag];
    feedy.feedType = FeedTableViewTypeTagFeed; 
    return feedy; 
}
+(FeedViewController *)feedViewControllerWithCategory:(NSString *)category{
    FeedViewController *feedy = [[FeedViewController alloc] initWithFeedID:category];
    feedy.feedType = FeedTableViewTypeCategoryFeed; 
    return feedy;
}
+(FeedViewController *)feedViewControllerForSingleVideoWithVideoID:(NSString *)videoID tag:(NSString *)tag{
    FeedViewController *feedy = [[FeedViewController alloc] initWithFeedID:videoID];
    feedy.tag = tag; 
    feedy.feedType = FeedTableViewTypeSingleVideo;
    return feedy; 
}
-(instancetype)initWithFeedID:(NSString *)feedID{
    self = [super init];
    if (self) {
        self.feedID = feedID; 
    }
    return self; 
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES]; 
    
    [self setUpView];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView.pullToRefreshView stopAnimating];
}

-(void)setUpView{

    if (self.feedType == FeedTableViewTypeSingleVideo) {
        self.navigationItem.title = self.tag;
    }else{
        self.navigationItem.title = self.feedID;
    }
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters
-(FeedTableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[FeedTableView alloc] initWithFeedTableViewType:self.feedType tagOrUserID:self.feedID frame:self.view.bounds]; 
        
//        switch (self.feedType) {
//            case FeedTableViewTypeCategoryFeed:{
//                _tableView = [FeedTableView feedTableViewForCategory:self.feedID frame:self.view.bounds];
//            }break;
//            case FeedTableViewTypeTagFeed:{
//                _tableView = [FeedTableView feedTableViewForTag:self.feedID frame:self.view.bounds];
//            }break;
//            case FeedTableViewTypeSingleVideo:{
//                _tableView = [FeedTableView feedTableViewForSingleVideoWithVideoID:self.feedID frame:self.view.bounds];
//            }break;
//            default:{
//                
//            }break; 
//        }
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
