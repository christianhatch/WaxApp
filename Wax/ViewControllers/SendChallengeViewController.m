//
//  SendChallengeViewController.m
//  Wax
//
//  Created by Christian Hatch on 7/16/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SendChallengeViewController.h"
#import <MessageUI/MessageUI.h>

@interface SendChallengeViewController () <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSString *challengeTag;
@property (nonatomic, strong) NSString *challengeVideoID;
@property (nonatomic, strong) NSURL *challengeShareURL;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) SendChallengeTableView *waxTableView;
@property (nonatomic, strong) SendChallengeTableView *contactsTableView;
//@property (nonatomic, strong) SendChallengeTableView *facebookTableView;

@property (nonatomic, readonly) SendChallengeTableView *proxyTableView; 
@end

@implementation SendChallengeViewController
@synthesize challengeTag, challengeVideoID, challengeShareURL, waxTableView = _waxTableView, contactsTableView = _contactsTableView, searchBar, searchResults;

+(SendChallengeViewController *)sendChallengeViewControllerWithChallengeTag:(NSString *)tag challengeVideoID:(NSString *)videoID shareURL:(NSURL *)shareURL{
    
    NSParameterAssert(tag);
    NSParameterAssert(videoID);
    
    SendChallengeViewController *sender = initViewControllerWithIdentifier(@"SendChallengeVC");
    sender.challengeTag = tag;
    sender.challengeVideoID = videoID;
    sender.challengeShareURL = shareURL;
    
    return sender;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendViaText) name:@"wax.sendChallenge" object:nil];
}

-(void)setUpView{
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Send %@", @"Send tag VC title"), self.challengeTag];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"Send") style:UIBarButtonItemStyleDone target:self action:@selector(sendChallengeButtonAction:)]; 
    
    [self.view addSubview:self.waxTableView];
    
    self.searchBar.placeholder = NSLocalizedString(@"search for @users on wax", @"search for @users on wax");
    self.waxTableView.tableHeaderView = self.searchBar;
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
    return self.searchResults.count;
}
-(UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCell *cell = [atableView dequeueReusableCellWithIdentifier:kPersonCellID];
    cell.cellType = PersonCellTypeSendChallenge; 
    cell.person = [self.searchResults objectAtIndexOrNil:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonObject *person = [self.searchResults objectAtIndexOrNil:indexPath.row];
    [self askToSendChallengeToUsers:@[person]];
}


#pragma mark - IBActions/API
-(void)sendChallengeButtonAction:(id)sender{
    
    NSArray *selectedPersons = self.proxyTableView.selectedPersons;
        
    if ([NSArray isEmptyOrNil:selectedPersons]) {
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Users Selected :(", @"No Users Selected") message:NSLocalizedString(@"Please select at least one user to challenge!", @"Please select at least one user to challenge") buttonTitle:NSLocalizedString(@"OK", @"OK") showsCancelButton:NO buttonHandler:nil logError:YES];
    }else{
        [self askToSendChallengeToUsers:selectedPersons];
    }
}
-(void)performSearch{
    NSString *searchString = self.searchBar.text;
    
    if (searchString.length > 1) {
        [self searchUsersWithSearchTerm:searchString];
    }
}
-(void)askToSendChallengeToUsers:(NSArray *)users{
    
    RIButtonItem *send = [RIButtonItem itemWithLabel:NSLocalizedString(@"Send", @"Send")];
    [send setAction:^{
        [self sendChallengeToUsers:users];
    }];
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Challenge %@ to %@?", @"Send challenge confirmation message"), [self usernameStringOfSelectedUsers:users], self.challengeTag];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send Challenge?", @"Send challenge alertview title")  message:message cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:send, nil] show];
}

#pragma mark - Internal Methods
-(void)searchUsersWithSearchTerm:(NSString *)searchTerm{
    
    [[WaxAPIClient sharedClient] searchForUsersWithSearchTerm:searchTerm infiniteScrollingID:nil completion:^(NSMutableArray *list, NSError *error) {
        if (!error) {
            self.searchResults = list;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error searching", @"Error searching") error:error buttonHandler:^{
                
            } logError:YES];
        }
    }];
}
-(void)sendChallengeToUsers:(NSArray *)users{
        
    [[WaxAPIClient sharedClient] sendChallengeTag:self.challengeTag videoID:self.challengeVideoID toUserIDs:[self arrayOfUserIDsFromArrayOfPersonObjects:users] completion:^(BOOL complete, NSError *error) {

        if (!error) {
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Sent %@ to %@!", @"Sent tag success message"), self.challengeTag, [self usernameStringOfSelectedUsers:users]]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Sending Challenge", @"Error Sending Challenge") message:error.localizedDescription buttonTitle:NSLocalizedString(@"Try Again", @"Try Again") showsCancelButton:YES buttonHandler:^{
                
                [self sendChallengeToUsers:users];
                
            } logError:YES];
        }
    }];
}

-(NSString *)usernameStringOfSelectedUsers:(NSArray *)users{
    
    NSParameterAssert(users);
    
    switch (users.count) {
        case 0:
            return nil;
            break;
        case 1:
            return [(PersonObject *)users.firstObject username];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@ and %@", [(PersonObject *)users.firstObject username], [(PersonObject *)[users objectAtIndexOrNil:1] username]];
        default:{
            
            NSMutableString *usernames = [NSMutableString stringWithCapacity:15];
            
            for (PersonObject *person in users) {
                if (person == users.lastObject) {
                    [usernames appendFormat:@"and %@", person.username];
                }else{
                    [usernames appendFormat:@"%@, ", person.username];
                }
            }
            return usernames;
            
        }break;
    }
}

-(NSArray *)arrayOfUserIDsFromArrayOfPersonObjects:(NSArray *)users{
    NSMutableArray *userIDs = [NSMutableArray arrayWithCapacity:users.count];
    for (PersonObject *person in users) {
        if ([person respondsToSelector:@selector(userID)]) {
            [userIDs addObject:person.userID];
        }
    }
    return userIDs;
}
-(void)sendViaText{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *texter = [[MFMessageComposeViewController alloc] init];
        
        texter.body = [NSString stringWithFormat:NSLocalizedString(@"I think you could be #1 at %@ on Wax! \nCheck out your competition here: %@ \n\n\nDon't have Wax? Download it: http://wax.li", @"send challenge via text"), self.challengeTag, self.challengeShareURL];
        
        texter.messageComposeDelegate = self;
        
        [self presentViewController:texter animated:YES completion:nil];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Send Text", @"Cannot Send Text") message:NSLocalizedString(@"Messaging is not available on this device at this time.", @"Messaging is not available on this device at this time.") cancelButtonItem:[RIButtonItem randomDismissalButton] otherButtonItems:nil, nil] show];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];

    switch (result) {
        case MessageComposeResultCancelled:
            [AIKErrorManager logMessageToAllServices:@"user canceled challenging via text message"];
            break;
        case MessageComposeResultFailed:
            [AIKErrorManager logMessageToAllServices:@"sending challenge via text failed"];
            break;
        case MessageComposeResultSent:
            [AIKErrorManager logMessageToAllServices:@"user challenged via text message"];
            break;
    }
}

#pragma mark - Getters
-(SendChallengeTableView *)waxTableView{
    if (!_waxTableView) {
        _waxTableView = [SendChallengeTableView sendChallengeTableViewForWaxWithFrame:self.view.bounds];
    }
    return _waxTableView;
}


-(SendChallengeTableView *)proxyTableView{
    return self.waxTableView; 
}




-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}



@end
