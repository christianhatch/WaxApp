//
//  DiscoverViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CategoryTableView.h"
#import "FeedViewController.h"

@interface DiscoverViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) CategoryTableView *tableView;
@property (nonatomic, strong) NSMutableArray *personSearchResults;
@property (nonatomic, strong) NSMutableArray *tagSearchResults;
@end

@implementation DiscoverViewController
@synthesize tableView = _tableView, searchBar = _searchBar, personSearchResults, tagSearchResults; 

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Discover", @"Discover");
    [self.view addSubview:self.tableView];
    self.searchBar.placeholder = NSLocalizedString(@"search for @users or #tags", @"search for @users or #tags");
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[NSLocalizedString(@"@users", @"@users"), NSLocalizedString(@"#tags", @"#tags")];
    self.tableView.tableHeaderView = self.searchBar;

    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:kCategoryCellID];
}

#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}
#pragma mark - UISearchDisplayController Delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return NO;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    return YES; 
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
        return self.personSearchResults.count;
    }else{
        return self.tagSearchResults.count; 
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCellID];
        cell.person = [self.personSearchResults objectAtIndexOrNil:indexPath.row];
        return cell;
    }else{
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellID];
        cell.category = [self.tagSearchResults objectAtIndexOrNil:indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
        [self.navigationController pushViewController:[ProfileViewController profileViewControllerFromPersonObject:[self.personSearchResults objectAtIndexOrNil:indexPath.row]] animated:YES];
    }else{
        [self.navigationController pushViewController:[FeedViewController feedViewControllerWithTag:[self.tagSearchResults objectAtIndexOrNil:indexPath.row]] animated:YES];
    }
}


#pragma mark - Getters
-(CategoryTableView *)tableView{
    if (!_tableView) {
        _tableView = [CategoryTableView categoryTableViewForDiscoverWithFrame:self.view.bounds didSelectCategoryBlock:^(NSString *category) {
            [self.navigationController pushViewController:[FeedViewController feedViewControllerWithCategory:category] animated:YES];
        }];
        _tableView.automaticallyDeselectRow = YES; 
    }
    return _tableView;
}




- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
