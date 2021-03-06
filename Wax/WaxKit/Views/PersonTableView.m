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
@synthesize userID = _userID, didSelectBlock = _didSelectBlock;

+(PersonTableView *)personTableViewForFollowingWithUserID:(NSString *)userID didSelectBlock:(PersonTableViewDidSelectPersonBlock)selectBlock frame:(CGRect)frame{
    PersonTableView *persony = [[PersonTableView alloc] initWithPersonTableViewType:PersonTableViewTypeFollowing userID:userID didSelectBlock:selectBlock frame:frame];
    return persony;
}
+(PersonTableView *)personTableViewForFollowersWithUserID:(NSString *)userID didSelectBlock:(PersonTableViewDidSelectPersonBlock)selectBlock frame:(CGRect)frame{
    PersonTableView *persony = [[PersonTableView alloc] initWithPersonTableViewType:PersonTableViewTypeFollowers userID:userID didSelectBlock:selectBlock frame:frame];
    return persony;
}
-(instancetype)initWithPersonTableViewType:(PersonTableViewType)tableViewType userID:(NSString *)userID didSelectBlock:(PersonTableViewDidSelectPersonBlock)selectBlock frame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.tableViewType = tableViewType;
        self.userID = userID;
        self.didSelectBlock = selectBlock;

        self.rowHeight = kPersonCellHeight;
        [self registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:kPersonCellID];
        
        __block PersonTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [blockSelf reFetchDataWithInfiniteScroll:NO];
        }];
        [self addInfiniteScrollingWithActionHandler:^{
            [blockSelf reFetchDataWithInfiniteScroll:YES];
        }];
    }
    return self;
}

#pragma mark - Internal Methods
-(void)reFetchDataWithInfiniteScroll:(BOOL)infiniteScroll{
    [super reFetchDataWithInfiniteScroll:infiniteScroll];
    
    switch (self.tableViewType) {
        case PersonTableViewTypeFollowers:{
            [[WaxDataManager sharedManager] updatePersonListForFollowersWithUserID:self.userID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self finishDataReFetchWithReFetchError:error];
            }];
        }break;
        case PersonTableViewTypeFollowing:{
            [[WaxDataManager sharedManager] updatePersonListForFollowingWithUserID:self.userID withInfiniteScroll:infiniteScroll completion:^(NSError *error) {
                [self finishDataReFetchWithReFetchError:error];
            }];
        }break;
    }
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.proxyDataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCell *cell = [self dequeueReusableCellWithIdentifier:kPersonCellID];
    
    PersonObject *person = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];
    cell.cellType = PersonCellTypeDefault; 
    cell.person = person;
    
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (self.didSelectBlock) {
        PersonObject *person = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];
        self.didSelectBlock(person); 
    }
}




#pragma mark - Convenience Methods
-(NSMutableArray *)proxyDataSourceArray{
    return [WaxDataManager sharedManager].personList;
}
-(void)finishDataReFetchWithReFetchError:(NSError *)error{
    [super finishDataReFetchWithReFetchError:error];
    
    /*
    if (!error) {

    }else{        
        switch (self.tableViewType) {
            case PersonTableViewTypeFollowers:{
                
            }break;
            case PersonTableViewTypeFollowing:{
                
            }break;
        }
    }
     */
}



@end
