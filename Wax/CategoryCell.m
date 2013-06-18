//
//  CategoryCell.m
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize categoryIconView, categoryLabel; 
@synthesize category = _category;


-(void)setUpView{
    
    NSString *cat = self.category; 
    
    self.categoryLabel.text = cat;
    [self.categoryIconView setImageWithURL:[NSURL categoryImageURLWithCategoryTitle:cat] placeholderImage:[UIImage imageNamed:@"record_flash"] animated:YES completion:nil]; 
    
}


#pragma mark - Setters
-(void)setCategory:(NSString *)category{
    if (_category != category) {
        _category = category;
        [self setUpView]; 
    }
}



@end
