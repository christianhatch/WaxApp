//
//  PersonTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "PersonTableView.h"
#import "PersonCell.h"

@interface PersonTableView ()
@property (nonatomic, strong) NSString *userID; 
@end

@implementation PersonTableView
@synthesize userID = _userID; 

+(PersonTableView *)personTableViewForFollowingWithUserID:(NSString *)userID frame:(CGRect)frame{
    PersonTableView *persony = [[PersonTableView alloc] initWithPersonTableViewType:PersonTableViewTypeFollowing userID:userID frame:frame];
    return persony;
}
+(PersonTableView *)personTableViewForFollowwersWithUserID:(NSString *)userID frame:(CGRect)frame{
    PersonTableView *persony = [[PersonTableView alloc] initWithPersonTableViewType:PersonTableViewTypeFollowers userID:userID frame:frame];
    return persony;
}
-(instancetype)initWithPersonTableViewType:(PersonTableViewType)tableViewType userID:(NSString *)userID frame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.tableViewType = tableViewType;
        self.userID = userID;
        
        [self registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
        
        __block PersonTableView *blockSelf = self;
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
#pragma mark - Internal Methods
-(void)refreshDataWithInfiniteScroll:(BOOL)infiniteScroll{
    switch (self.tableViewType) {
        case PersonTableViewTypeFollowers:{
            [[WaxDataManager sharedManager] updatePersonListForFollowersWithUserID:self.userID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
        case PersonTableViewTypeFollowing:{
            [[WaxDataManager sharedManager] updatePersonListForFollowingWithUserID:self.userID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }];
        }break;
    }
}
#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self proxyDataSourceArray].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCell *cell = [self dequeueReusableCellWithIdentifier:kPersonCellID];
    
    PersonObject *person = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row];
    cell.person = person;
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mark - Convenience Methods
-(NSMutableArray *)proxyDataSourceArray{
    switch (self.tableViewType) {
        case PersonTableViewTypeFollowing:{
            return [WaxDataManager sharedManager].personList;
        }break;
        case PersonTableViewTypeFollowers:{
            return [WaxDataManager sharedManager].personList;
        }break;
    }
}
-(void)handleUpdatingFeedWithError:(NSError *)error{
    [super handleUpdatingFeedWithError:error];
    
    if (!error) {

    }else{        
        switch (self.tableViewType) {
            case PersonTableViewTypeFollowers:{
                
            }break;
            case PersonTableViewTypeFollowing:{
                
            }break;
        }
    }
}



@end
