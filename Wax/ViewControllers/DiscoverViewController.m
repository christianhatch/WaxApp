//
//  DiscoverViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define USER_SCOPE_SELECTED self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0

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
    [self updatePlaceholder];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[NSLocalizedString(@"@users", @"@users"), NSLocalizedString(@"#tags", @"#tags")];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo; 
}

#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearch];
}
#pragma mark - UISearchDisplayController Delegate
-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"TagCell" bundle:nil] forCellReuseIdentifier:kTagCellID];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self performSearch];
    return NO;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self updatePlaceholder];
    return YES;
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    [self updatePlaceholder];
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [self updatePlaceholder];
}


#pragma mark - UITableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (USER_SCOPE_SELECTED) {
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
        TagCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagCellID];
        cell.tagObject = [self.tagSearchResults objectAtIndexOrNil:indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (USER_SCOPE_SELECTED) {
        [self.navigationController pushViewController:[ProfileViewController profileViewControllerFromPersonObject:[self.personSearchResults objectAtIndexOrNil:indexPath.row]] animated:YES];
    }else{
        TagObject *tagObject = [self.tagSearchResults objectAtIndexOrNil:indexPath.row];
        [self.navigationController pushViewController:[FeedViewController feedViewControllerWithTag:tagObject.tag] animated:YES];
    }
}

#pragma mark - Internal Methods
-(void)updatePlaceholder{
    if (self.searchDisplayController.isActive) {
        if (USER_SCOPE_SELECTED) {
            self.searchBar.placeholder = NSLocalizedString(@"search for @users", @"search for @users");
        }else{
            self.searchBar.placeholder = NSLocalizedString(@"search for #tags", @"search for #tags");
        }
    }else{
        self.searchBar.placeholder = NSLocalizedString(@"search for @users or #tags", @"search for @users or #tags");
    }
}
-(void)performSearch{
    NSString *searchString = self.searchBar.text;
    
    if (searchString.length > 1) {
        if (self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
            [self searchUsersWithSearchTerm:searchString];
        }else{
            [self searchTagsWithSearchTerm:searchString];
        }
    }
}
-(void)searchUsersWithSearchTerm:(NSString *)searchTerm{
    [[WaxAPIClient sharedClient] searchForUsersWithSearchTerm:searchTerm infiniteScrollingID:nil completion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.personSearchResults = list;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error searching", @"Error searching") error:error buttonHandler:^{
                
            } logError:YES];
        }
    }];
}
-(void)searchTagsWithSearchTerm:(NSString *)searchTerm{
    [[WaxAPIClient sharedClient] searchForTagsWithSearchTerm:searchTerm infiniteScrollingID:nil completion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.tagSearchResults = list;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error searching", @"Error searching") error:error buttonHandler:^{
                
            } logError:YES];
        }
        
    }];
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
