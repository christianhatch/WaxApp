//
//  PersonListViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "PersonListViewController.h"
#import "PersonTableView.h"
#import "ProfileViewController.h"


@interface PersonListViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *challengeTag; 
@property (nonatomic, readwrite) PersonTableViewType tableViewType;
@property (nonatomic, readwrite) BOOL addSearchBar;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *personSearchResults;
@property (nonatomic, strong) PersonTableView *tableView; 
@end

@implementation PersonListViewController
@synthesize userID = _userID, tableViewType = _tableViewType, addSearchBar, searchBar, personSearchResults, tableView; 

+(PersonListViewController *)personListViewControllerForFollowersFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] init];
    plvc.tableViewType = PersonTableViewTypeFollowers;
    plvc.addSearchBar = NO;
    plvc.userID = userID; 
    return plvc;
}
+(PersonListViewController *)personListViewControllerForFollowingFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] init];
    plvc.tableViewType = PersonTableViewTypeFollowing;
    plvc.addSearchBar = NO;
    plvc.userID = userID;
    return plvc;
}
+(PersonListViewController *)personListViewControllerForSendingChallengeWithTag:(NSString *)tag{
    PersonListViewController *plv = initViewControllerWithIdentifier(@"PersonListVC");
    plv.tableViewType = PersonTableViewTypeFollowing;
    plv.challengeTag = tag;
    plv.addSearchBar = YES;
    plv.userID = [[WaxUser currentUser] userID]; 
    return plv; 
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    [self setUpView];
}

#pragma mark - Setters
-(void)setUserID:(NSString *)userID{

    NSParameterAssert(userID);
    
    if (_userID != userID) {
        _userID = userID;
        [self setUpView];
    }
}

-(void)setUpView{
    PersonTableViewDidSelectPersonBlock selectBlock = ^(PersonObject *person) {
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromPersonObject:person];
        [self.navigationController pushViewController:pvc animated:YES];
    };
    
    if (!self.addSearchBar) {
        if (self.tableViewType == PersonTableViewTypeFollowing) {
            self.navigationItem.title = NSLocalizedString(@"Following", @"Following");
            self.tableView = [PersonTableView personTableViewForFollowingWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]; 
        }else if (self.tableViewType == PersonTableViewTypeFollowers){
            self.navigationItem.title = NSLocalizedString(@"Followers", @"Followers");
            self.tableView = [PersonTableView personTableViewForFollowersWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]; 
        }
    }else{
        self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Send %@", @"Send tag VC title"), self.challengeTag];
       
        self.tableView = [PersonTableView personTableViewForFollowersWithUserID:self.userID didSelectBlock:^(PersonObject *person) {

            [self didSelectPersonCellWithPerson:person]; 
            
        } frame:self.view.bounds];
       
        self.tableView.hidesFollowButtonOnCells = YES;
        
        [self addSearchFunctionality]; 
    }
    
    [self.view addSubview:self.tableView]; 
}

-(void)addSearchFunctionality{
    self.searchBar.placeholder = NSLocalizedString(@"search for @users", @"search for @users");
    self.tableView.tableHeaderView = self.searchBar;
}

#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearch]; 
}

#pragma mark - UISearchDisplayController Delegate
-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    self.searchDisplayController.searchResultsTableView.rowHeight = kPersonCellHeight; 
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self performSearch];
    return NO;
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personSearchResults.count;
}
-(UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCell *cell = [atableView dequeueReusableCellWithIdentifier:kPersonCellID];
    cell.person = [self.personSearchResults objectAtIndexOrNil:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonObject *person = [self.personSearchResults objectAtIndexOrNil:indexPath.row];
    [self didSelectPersonCellWithPerson:person]; 
}


#pragma mark - Internal Methods
-(void)performSearch{
    NSString *searchString = self.searchBar.text;
    
    if (searchString.length > 1) {
        [self searchUsersWithSearchTerm:searchString];
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

-(void)didSelectPersonCellWithPerson:(PersonObject *)person{
    RIButtonItem *send = [RIButtonItem itemWithLabel:NSLocalizedString(@"Send", @"Send")];
    [send setAction:^{
        [self sendChallengeToUser:person];
    }];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send Challenge?", @"Send challenge alertview title")  message:[NSString stringWithFormat:NSLocalizedString(@"Challenge %@ to %@?", @"Send challenge confirmation message"), self.challengeTag, person.username] cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:send, nil] show];
}
-(void)sendChallengeToUser:(PersonObject *)person{
        
    [[WaxAPIClient sharedClient] sendChallengeTag:self.challengeTag toUserID:person.userID completion:^(BOOL complete, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Sent %@ to %@!", @"Sent tag success message"), self.challengeTag, person.username]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Sending Challenge", @"Error Sending Challenge") message:error.localizedDescription buttonTitle:NSLocalizedString(@"Try Again", @"Try Again") showsCancelButton:NO buttonHandler:^{
                
                [self sendChallengeToUser:person]; 
                
            } logError:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}


@end
