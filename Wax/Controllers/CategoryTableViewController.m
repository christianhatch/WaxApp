//
//  CategoryTableViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "CategoryTableViewController.h"

@interface CategoryTableViewController ()
@property (nonatomic, strong) CategoryViewControllerCompletionBlock completionBlock;
@end

@implementation CategoryTableViewController
@synthesize completionBlock = _completionBlock; 

#pragma mark - Class Methods
+(void)chooseCategoryWithCompletionBlock:(CategoryViewControllerCompletionBlock)completion sender:(UINavigationController *)sender{
    CategoryTableViewController *cats = initViewControllerWithIdentifier(@"CategoryVC");
    cats.completionBlock = completion;
    [sender pushViewController:cats animated:YES];
}

#pragma mark - View Lifecycle
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        return self; 
    }
    return self; 
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    DLog(@"cats %@", [WaxDataManager sharedManager].categories);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Choose Category", @"Choose Category");
}


#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [WaxDataManager sharedManager].categories.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CategoryCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *cat = [[WaxDataManager sharedManager].categories objectAtIndexOrNil:indexPath.row];
    cell.textLabel.text = cat;
    [cell.imageView setImageWithURL:[NSURL categoryImageURLWithCategoryTitle:cat] placeholderImage:nil animated:YES completion:nil];
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.completionBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        self.completionBlock([[WaxDataManager sharedManager].categories objectAtIndexOrNil:indexPath.row]);
    }
}


@end
