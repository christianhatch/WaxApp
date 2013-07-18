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
        
        self.rowHeight = kNotificationCellHeight; 
        [self registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:kNotificationCellID];
        
        __block NotificationsTableView *blockSelf = self;
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
    [[WaxDataManager sharedManager] updateNotificationsWithInfiniteScroll:infiniteScroll completion:^(NSError *error) {
        [self handleUpdatingFeedWithError:error]; 
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
    
    VLog(@"selected note object %@", note);

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

-(void)handleUpdatingFeedWithError:(NSError *)error{
    
    [self setEmptyViewMessageText:NSLocalizedString(@"No Notifications", @"No Notifications")]; 
    
    
    if (!error) {
        
    }else{
        VLog(@"error updating feed %@", error);
    }
    
    [super handleUpdatingFeedWithError:error];
}



@end
