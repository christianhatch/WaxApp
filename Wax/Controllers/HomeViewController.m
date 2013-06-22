//
//  HomeViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/8/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedTableView.h"

@interface HomeViewController ()
@property (nonatomic, strong) FeedTableView *tableView; 
@end

@implementation HomeViewController
@synthesize tableView = _tableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Home", @"Home");
    [self.view addSubview:self.tableView];
    [[WaxDataManager sharedManager] addObserver:self forKeyPath:@"homeFeed" options:NSKeyValueObservingOptionNew context:nil]; 
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"homeFeed"]) {
        [self.tableView reloadData]; 
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Getters
-(FeedTableView *)tableView{
    if (!_tableView) {
        _tableView = [FeedTableView feedTableViewForHomeWithFrame:self.view.bounds]; 
    }
    return _tableView; 
}




-(void)dealloc{
    [[WaxDataManager sharedManager] removeObserver:self forKeyPath:@"homeFeed"]; 
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
