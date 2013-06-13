//
//  CategoryTableView.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "CategoryTableView.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import "WaxTableViewCell.h"

@interface CategoryTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CategoryTableView
@synthesize categoryType = _categoryType, didSelectBlock = _didSelectBlock;

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
        self.categoryType = categoryType;
        self.didSelectBlock = selectBlock;
                
        __block CategoryTableView *blockSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [blockSelf refreshData];
        }];
    }
    return self;
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    switch (self.categoryType) {
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
    switch (self.categoryType) {
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

    static NSString *cellID = @"CategoryCell";
    
    WaxTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WaxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *cat = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row];
    cell.textLabel.text = cat;
    [cell.imageView setImageWithURL:[NSURL categoryImageURLWithCategoryTitle:cat] placeholderImage:[UIImage imageNamed:@"record_flash"] animated:YES completion:nil];
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectBlock) {
        NSString *cat = [[self proxyDataSourceArray] objectAtIndexOrNil:indexPath.row];
        if (self.automaticallyDeselectRow) {
            [self deselectRowAtIndexPath:indexPath animated:YES];
        }
        self.didSelectBlock(cat);
    }
}



#pragma mark - Convenience Methods
-(NSMutableArray *)proxyDataSourceArray{
    NSMutableArray *array = nil;
    switch (self.categoryType) {
        case CategoryTableViewTypeCategories:{
            array = [WaxDataManager sharedManager].categories;
        }break;
        case CategoryTableViewTypeDiscover:{
            array = [WaxDataManager sharedManager].discoverArray;
        }break;
    }
    return array;
}
-(void)handleUpdatingFeedWithError:(NSError *)error{
    [self stopAnimatingReloaderViews];
    if (!error) {
        [self reloadData];
    }else{
        DLog(@"error updating category %@", error);
        
        switch (self.categoryType) {
            case CategoryTableViewTypeCategories:{
                
            }break;
            case CategoryTableViewTypeDiscover:{
                
            }break;
        }
    }
}


@end
