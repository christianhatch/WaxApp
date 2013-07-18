//
//  SendChallengeTableView.m
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SendChallengeTableView.h"
#import "InviteFriendsHeaderView.h"

@interface SendChallengeTableView ()
@property (nonatomic, strong) NSMutableSet *selectedPersonSet;
@end

@implementation SendChallengeTableView
@synthesize selectedPersonSet = _selectedPersonSet, tableViewType;

+(SendChallengeTableView *)sendChallengeTableViewForWaxWithFrame:(CGRect)frame{
    SendChallengeTableView *sendy = [[SendChallengeTableView alloc] initWithSendChallengeTableViewType:SendChallengeTableViewTypeWax frame:frame];
    return sendy;
}
+(SendChallengeTableView *)sendChallengeTableViewForContactsWithFrame:(CGRect)frame{
    SendChallengeTableView *sendy = [[SendChallengeTableView alloc] initWithSendChallengeTableViewType:SendChallengeTableViewTypeContacts frame:frame];
    return sendy;
}
+(SendChallengeTableView *)sendChallengeTableViewForFacebookWithFrame:(CGRect)frame{
    SendChallengeTableView *sendy = [[SendChallengeTableView alloc] initWithSendChallengeTableViewType:SendChallengeTableViewTypeFacebook frame:frame];
    return sendy;
}

-(instancetype)initWithSendChallengeTableViewType:(SendChallengeTableViewType)type frame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        self.tableViewType = type;
        
        self.rowHeight = kPersonCellHeight;
        [self registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
        [self registerNib:[UINib nibWithNibName:@"InviteFriendsCell" bundle:nil] forCellReuseIdentifier:kInviteFriendsCellID];
        
        if (self.tableViewType == SendChallengeTableViewTypeContacts) {
            self.tableHeaderView = [InviteFriendsHeaderView inviteFriendsHeaderViewForContacts];
        }else if (self.tableViewType == SendChallengeTableViewTypeFacebook){
            self.tableHeaderView = [InviteFriendsHeaderView inviteFriendsHeaderViewForFacebook];
        }
        
        __block SendChallengeTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:NO];
        }];
        [self addInfiniteScrollingWithActionHandler:^{
            [blockSelf refreshDataWithInfiniteScroll:YES];
        }];
    }
    return self;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self triggerPullToRefresh];
}


-(void)refreshDataWithInfiniteScroll:(BOOL)infiniteScroll{
    [[WaxDataManager sharedManager] updatePersonListForFollowingWithUserID:[WaxUser currentUser].userID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
        [self handleUpdatingFeedWithError:error];
    }];
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1; 
    }
    
    return self.proxyDataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        InviteFriendsCell *cell = [self dequeueReusableCellWithIdentifier:kInviteFriendsCellID];
        return cell;
        
    }else{
        PersonCell *cell = [self dequeueReusableCellWithIdentifier:kPersonCellID];
        
        PersonObject *person = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];
        cell.cellType = PersonCellTypeSendChallenge;
        cell.person = person;
        
        return cell;
    }
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"wax.sendChallenge" object:self]; 
        
        
    }else{
        [self updateCheckmarkForCellAtIndexPath:indexPath];
        [self updateSelectedPersonsForIndexPath:indexPath]; 
    }
}

#pragma mark - Internal Methods
-(void)updateCheckmarkForCellAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCell *cell = (PersonCell *)[self cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
-(void)updateSelectedPersonsForIndexPath:(NSIndexPath *)indexPath{
    
    PersonObject *person = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];

    if ([self.selectedPersonSet containsObject:person]) {
        [self.selectedPersonSet removeObject:person];
    }else{
        [self.selectedPersonSet addObject:person];
    }
}

#pragma mark - Overrides
-(NSMutableArray *)proxyDataSourceArray{
    return [WaxDataManager sharedManager].personList;
}
-(void)handleUpdatingFeedWithError:(NSError *)error{
    [super handleUpdatingFeedWithError:error];
    
    if (!error) {
        
    }else{
        //TODO: handle error updating feed
    }
}

#pragma mark - Getters
-(NSMutableSet *)selectedPersonSet{
    if (!_selectedPersonSet) {
        _selectedPersonSet = [NSMutableSet set];
    }
    return _selectedPersonSet;
}

-(NSArray *)selectedPersons{
    return [self.selectedPersonSet allObjects];
}



@end
