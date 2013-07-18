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
    
#ifdef DEBUG
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testThings)];
#endif
}

-(void)testThings{
    [[WaxUser currentUser] fetchMatchedContactsWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (error) {
            [AIKErrorManager showAlertWithTitle:@"matching contacts error!" message:[NSString stringWithFormat:@"%@", error] buttonHandler:nil logError:NO];
        }
        VLog(@"matched contacts %@", list);
    }];
    [[WaxUser currentUser] fetchMatchedFacebookFriendsWithCompletion:^(NSMutableArray *list, NSError *error) {
        if (error) {
            [AIKErrorManager showAlertWithTitle:@"matching facebook error!" message:[NSString stringWithFormat:@"%@", error] buttonHandler:nil logError:NO];
        }
        VLog(@"matched fb friends %@", list);
    }];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Wax", @"Wax");
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters
-(FeedTableView *)tableView{
    if (!_tableView) {
        _tableView = [FeedTableView feedTableViewForHomeWithFrame:self.view.bounds]; 
    }
    return _tableView; 
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
