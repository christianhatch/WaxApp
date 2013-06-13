//
//  CategoryTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, CategoryTableViewType){
    CategoryTableViewTypeCategories = 1,
    CategoryTableViewTypeDiscover,
};

typedef void(^CategoryTableViewDidSelectCategoryBlock)(NSString *category);


#import "WaxTableView.h"

@interface CategoryTableView : WaxTableView

+(CategoryTableView *)categoryTableViewForDiscoverWithFrame:(CGRect)frame didSelectCategoryBlock:(CategoryTableViewDidSelectCategoryBlock)selectBlock;
+(CategoryTableView *)categoryTableViewForCategoriesWithFrame:(CGRect)frame didSelectCategoryBlock:(CategoryTableViewDidSelectCategoryBlock)selectBlock;

-(instancetype)initWithCategoryTableViewType:(CategoryTableViewType)categoryType frame:(CGRect)frame didSelectCategoryBlock:(CategoryTableViewDidSelectCategoryBlock)selectBlock;

@property (nonatomic) CategoryTableViewType categoryType;
@property (nonatomic, strong) CategoryTableViewDidSelectCategoryBlock didSelectBlock;


@end
