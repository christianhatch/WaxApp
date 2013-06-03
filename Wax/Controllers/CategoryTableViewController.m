//
//  CategoryTableViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "CategoryTableViewController.h"

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
        
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Choose Category", @"Choose Category");
}


#pragma mark - TableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1; 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CategoryCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"cattygooree";
    [cell.imageView setImageWithURL:[NSURL categoryImageURLWithCategoryTitle:@"category"] placeholderImage:nil animated:YES completion:nil];
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES]; 
    if (self.completionBlock) {
        self.completionBlock([self.tableView cellForRowAtIndexPath:indexPath].textLabel.text); 
    }
}


@end
