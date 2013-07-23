//
//  SendChallengeTableView.m
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SendChallengeTableView.h"

@interface SendChallengeTableView ()
@property (nonatomic, strong) NSMutableSet *selectedPersonSet;
@property (nonatomic, strong) NSString *challengeTag;
@property (nonatomic, strong) NSURL *challengeShareURL;
@end

@implementation SendChallengeTableView
@synthesize selectedPersonSet = _selectedPersonSet, tableViewType, challengeTag, challengeShareURL; 

+(SendChallengeTableView *)sendChallengeTableViewForWaxWithChallengeTag:(NSString *)challengeTag shareURL:(NSURL *)shareURL frame:(CGRect)frame{
    SendChallengeTableView *sendy = [[SendChallengeTableView alloc] initWithSendChallengeTableViewType:SendChallengeTableViewTypeWax challengeTag:challengeTag shareURL:shareURL frame:frame];
    return sendy;
}
+(SendChallengeTableView *)sendChallengeTableViewForContactsWithChallengeTag:(NSString *)challengeTag shareURL:(NSURL *)shareURL frame:(CGRect)frame{
    SendChallengeTableView *sendy = [[SendChallengeTableView alloc] initWithSendChallengeTableViewType:SendChallengeTableViewTypeContacts challengeTag:challengeTag shareURL:shareURL frame:frame];
    return sendy;
}
+(SendChallengeTableView *)sendChallengeTableViewForFacebookWithChallengeTag:(NSString *)challengeTag shareURL:(NSURL *)shareURL frame:(CGRect)frame{
    SendChallengeTableView *sendy = [[SendChallengeTableView alloc] initWithSendChallengeTableViewType:SendChallengeTableViewTypeFacebook challengeTag:challengeTag shareURL:shareURL frame:frame];
    return sendy;
}

-(instancetype)initWithSendChallengeTableViewType:(SendChallengeTableViewType)type challengeTag:(NSString *)tag shareURL:(NSURL *)shareURL frame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        NSParameterAssert(type);
        NSParameterAssert(tag);
        NSParameterAssert(shareURL); 
        
        self.tableViewType = type;
        self.challengeTag = tag;
        self.challengeShareURL = shareURL; 
        
        self.rowHeight = kPersonCellHeight;
        [self registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
        [self registerNib:[UINib nibWithNibName:@"SendChallengeCell" bundle:nil] forCellReuseIdentifier:kSendChallengeCellID];
        
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
        
        SendChallengeCell *cell = [self dequeueReusableCellWithIdentifier:kSendChallengeCellID];
        [cell setChallengeTag:self.challengeTag shareURL:self.challengeShareURL];
        cell.cellType = SendChallengeCellTypeContacts;
        return cell;
        
    }else{
        PersonCell *cell = [self dequeueReusableCellWithIdentifier:kPersonCellID];
        
        PersonObject *person = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];
        cell.cellType = PersonCellTypeSendChallenge;
        cell.person = person;
        cell.accessoryType = UITableViewCellAccessoryNone; 
        
        return cell;
    }
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        SendChallengeCell *cell = (SendChallengeCell *)[self cellForRowAtIndexPath:indexPath];
        [cell didSelect]; 
        
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
