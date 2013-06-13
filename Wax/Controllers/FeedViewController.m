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
@property (nonatomic, readwrite) WaxFeedTableViewType feedType; 
@end

@implementation FeedViewController
@synthesize feedID = _feedID, feedType = _feedType;

#pragma mark - Alloc & Init
+(FeedViewController *)feedViewControllerWithTag:(NSString *)tag{
    FeedViewController *feedy = [[FeedViewController alloc] initWithFeedID:tag];
    feedy.feedType = WaxFeedTableViewTypeTagFeed; 
    return feedy; 
}
+(FeedViewController *)feedViewControllerWithCategory:(NSString *)category{
    FeedViewController *feedy = [[FeedViewController alloc] initWithFeedID:category];
    feedy.feedType = WaxFeedTableViewTypeCategoryFeed; 
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

-(void)setUpView{
    self.navigationItem.title = self.feedID;
    if (self.feedType == WaxFeedTableViewTypeCategoryFeed) {
        [self.view addSubview:[FeedTableView feedTableViewForCategory:self.feedID frame:self.view.bounds]];
    }else if (self.feedType == WaxFeedTableViewTypeTagFeed){
        [self.view addSubview:[FeedTableView feedTableViewForTag:self.feedID frame:self.view.bounds]];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
