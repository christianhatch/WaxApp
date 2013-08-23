//
//  NotificationsTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationsTableView.h"

@implementation NotificationsTableView

+(NotificationsTableView *)notificationsTableViewWithFrame:(CGRect)frame{
    NotificationsTableView *notey = [[NotificationsTableView alloc] initWithFrame:frame];
    return notey;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:WaxUserDidLogOutNotification object:nil];
        
        self.rowHeight = kNotificationCellHeight; 
        [self registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:kNotificationCellID];
        
        __block NotificationsTableView *blockSelf = self;
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
    [[WaxDataManager sharedManager] updateNotificationsWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
        [self finishDataReFetchWithReFetchError:error]; 
    }];
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.proxyDataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationCell *cell = [self dequeueReusableCellWithIdentifier:kNotificationCellID];
    cell.noteObject = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NotificationObject *note = [self.proxyDataSourceArray objectAtIndexOrNil:indexPath.row];
    
//    DDLogVerbose(@"selected note object %@", note);

    note.unread = NO;
    NotificationCell *cell = (NotificationCell *)[self cellForRowAtIndexPath:indexPath];
    cell.noteObject = note; 
    
    switch (note.noteType) {
        case NotificationTypeVote:
        case NotificationTypeChallenged:
        case NotificationTypeChallengeResponse:{
            FeedViewController *feedy = [FeedViewController feedViewControllerForSingleVideoWithVideoID:note.videoID tag:note.tag];
            [self.nearestNavigationController pushViewController:feedy animated:YES]; 
        }break;
        case NotificationTypeTitleEarned:
        case NotificationTypeTitleStolen:{
            FeedViewController *feedy = [FeedViewController feedViewControllerWithTag:note.tag];
            [self.nearestNavigationController pushViewController:feedy animated:YES];
        }break;
        case NotificationTypeFollow:{
            ProfileViewController *profy = [ProfileViewController profileViewControllerFromUserID:note.userID username:note.username];
            [self.nearestNavigationController pushViewController:profy animated:YES]; 
        }break;
    }
}




#pragma mark - Convenience Methods
-(NSMutableArray *)proxyDataSourceArray{
    return [WaxDataManager sharedManager].notifications;
}

-(void)finishDataReFetchWithReFetchError:(NSError *)error{

    if (!error) {
        self.emptyView.labelText = NSLocalizedString(@"No Notifications", @"No Notifications");

    }else{
        self.emptyView.labelText = NSLocalizedString(@"Error Loading Notifications", @"No Notifications");

        DDLogError(@"error updating notes %@", error);
    }
    
    [super finishDataReFetchWithReFetchError:error];
}



@end
