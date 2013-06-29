//
//  CategoryTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "CategoryTableView.h"
#import "WaxTableViewCell.h"

@interface CategoryTableView ()

@end

@implementation CategoryTableView
@synthesize tableViewType = _categoryType, didSelectBlock = _didSelectBlock;

+(CategoryTableView *)categoryTableViewForCategoriesWithFrame:(CGRect)frame didSelectCategoryBlock:(CategoryTableViewDidSelectCategoryBlock)selectBlock{
    CategoryTableView *cats = [[CategoryTableView alloc] initWithCategoryTableViewType:CategoryTableViewTypeCategories frame:frame didSelectCategoryBlock:selectBlock];
    return cats;
}
+(CategoryTableView *)categoryTableViewForDiscoverWithFrame:(CGRect)frame didSelectCategoryBlock:(CategoryTableViewDidSelectCategoryBlock)selectBlock{
    CategoryTableView *cats = [[CategoryTableView alloc] initWithCategoryTableViewType:CategoryTableViewTypeDiscover frame:frame didSelectCategoryBlock:selectBlock];
    return cats;
}
-(instancetype)initWithCategoryTableViewType:(CategoryTableViewType)categoryType frame:(CGRect)frame didSelectCategoryBlock:(CategoryTableViewDidSelectCategoryBlock)selectBlock{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.tableViewType = categoryType;
        self.didSelectBlock = selectBlock;
        
        self.rowHeight = kCategoryCellHeight; 
        [self registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:kCategoryCellID];
        
        __block CategoryTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [blockSelf refreshData];
        }];
    }
    return self;
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    switch (self.tableViewType) {
        case CategoryTableViewTypeCategories:{
            [self reloadData];
        }break;
        case CategoryTableViewTypeDiscover:{
            [self triggerPullToRefresh];
        }break;
    }
}
#pragma mark - Internal Methods
-(void)refreshData{
    switch (self.tableViewType) {
        case CategoryTableViewTypeCategories:{
            [[WaxDataManager sharedManager] updateCategoriesWithCompletion:^(NSError *error) {
                [self handleUpdatingFeedWithError:error];
            }]; 
        }break;
        case CategoryTableViewTypeDiscover:{
            [[WaxDataManager sharedManager] updateDiscoverWithCompletion:^(NSError *error) {
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
    
    CategoryCell *cell = [self dequeueReusableCellWithIdentifier:kCategoryCellID];
    
    cell.category = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row]; 
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (self.didSelectBlock) {
        NSString *cat = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row];
        self.didSelectBlock(cat);
    }
}



#pragma mark - Convenience Methods
-(NSMutableArray *)proxyDataSourceArray{
    switch (self.tableViewType) {
        case CategoryTableViewTypeCategories:{
            return [WaxDataManager sharedManager].categories;
        }break;
        case CategoryTableViewTypeDiscover:{
            return [WaxDataManager sharedManager].discoverArray;
        }break;
    }
}
-(void)handleUpdatingFeedWithError:(NSError *)error{
    [super handleUpdatingFeedWithError:error];
    
    if (!error) {

    }else{
        DLog(@"error updating category %@", error);
        
        switch (self.tableViewType) {
            case CategoryTableViewTypeCategories:{
                
            }break;
            case CategoryTableViewTypeDiscover:{
                
            }break;
        }
    }
}


@end
