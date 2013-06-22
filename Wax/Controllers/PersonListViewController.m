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


@interface PersonListViewController ()
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *challengeTag; 
@property (nonatomic, readwrite) PersonTableViewType tableViewType;
@property (nonatomic, readwrite) BOOL addSearchBar; 
@end

@implementation PersonListViewController
@synthesize userID = _userID, tableViewType = _tableViewType, addSearchBar; 

+(PersonListViewController *)personListViewControllerForFollowersFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] initWithUserID:userID];
    plvc.tableViewType = PersonTableViewTypeFollowers;
    return plvc; 
}
+(PersonListViewController *)personListViewControllerForFollowingFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] initWithUserID:userID];
    plvc.tableViewType = PersonTableViewTypeFollowing;
    return plvc;
}
+(PersonListViewController *)personListViewControllerForSendingChallengeWithTag:(NSString *)tag{
    PersonListViewController *plvc = [[PersonListViewController alloc] initWithUserID:[[WaxUser currentUser] userID]];
    plvc.tableViewType = PersonTableViewTypeFollowing;
    plvc.addSearchBar = YES;
    plvc.challengeTag = tag; 
    return plvc; 
}
-(instancetype)initWithUserID:(NSString *)userID{
   
    NSParameterAssert(userID);
    
    self = [super init];
    if (self) {
        self.userID = userID; 
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    [self setUpView];
}

-(void)setUpView{
    PersonTableViewDidSelectPersonBlock selectBlock = ^(PersonObject *person) {
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromPersonObject:person];
        [self.navigationController pushViewController:pvc animated:YES];
    };
    
    if (!self.addSearchBar) {
        if (self.tableViewType == PersonTableViewTypeFollowing) {
            self.navigationItem.title = NSLocalizedString(@"Following", @"Following");
            [self.view addSubview:[PersonTableView personTableViewForFollowingWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]];
        }else if (self.tableViewType == PersonTableViewTypeFollowers){
            self.navigationItem.title = NSLocalizedString(@"Followers", @"Followers");
            [self.view addSubview:[PersonTableView personTableViewForFollowersWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]];
        }
    }else{
        self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Send %@", @"Send tag VC title"), self.challengeTag];
       
        PersonTableView *table = [PersonTableView personTableViewForFollowersWithUserID:self.userID didSelectBlock:^(PersonObject *person) {
            [self sendChallengeToUser:person];
        } frame:self.view.bounds];
       
        table.hidesFollowButtonOnCells = YES;
        [self.view addSubview:table];
    }
}
-(void)sendChallengeToUser:(PersonObject *)person{
    [[WaxAPIClient sharedClient] sendChallengeTag:self.challengeTag toUserID:person.userID completion:^(BOOL complete, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Sent %@ to %@!", @"Sent tag success message"), self.challengeTag, person.username]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Sending Challenge", @"Error Sending Challenge") message:error.localizedDescription buttonTitle:NSLocalizedString(@"Try Again", @"Try Again") buttonHandler:^{
                
                [self sendChallengeToUser:person]; 
                
            } logError:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}


@end
