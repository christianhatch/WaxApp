//
//  HomeViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/8/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kShowUploadViewFrame CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 60)
#define kHideUploadViewFrame CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 0)

#import "HomeViewController.h"
#import "FeedTableView.h"

@interface HomeViewController ()
@property (nonatomic, strong) FeedTableView *tableView;
@property (nonatomic, strong) VideoUploadView *uploadView; 
@end

@implementation HomeViewController
@synthesize tableView = _tableView, uploadView = _uploadView; 

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Wax", @"Wax");
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.uploadView]; 
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //TODO: test this!!!
    if (self.uploadView.shouldBeVisible) {
        [self showUploadView];
    }else{
        [self hideUploadView]; 
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView.pullToRefreshView stopAnimating]; 
}


#pragma mark - Getters
-(FeedTableView *)tableView{
    if (!_tableView) {
        _tableView = [FeedTableView feedTableViewForHomeWithFrame:self.view.bounds]; 
    }
    return _tableView; 
}
-(VideoUploadView *)uploadView{
    if (!_uploadView) {
        
        _uploadView = [VideoUploadView videoUploadViewWithShowBlock:^(VideoUploadView *view) {
            [self showUploadView];
        } shouldHideBlock:^(VideoUploadView *view) {
            [self hideUploadView]; 
        }];
        _uploadView.frame = kHideUploadViewFrame;
    }
    return _uploadView; 
}

#pragma mark - Convenience Methods
-(void)showUploadView{
    CGRect newUploadViewFrame = kShowUploadViewFrame;
    CGRect newTableViewFrame = CGRectMake(self.view.bounds.origin.x, newUploadViewFrame.size.height, self.view.bounds.size.width, (self.view.bounds.size.height - newUploadViewFrame.size.height));
    
    [UIView animateWithDuration:AIKDefaultAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.uploadView.frame = newUploadViewFrame;
        self.tableView.frame = newTableViewFrame;
    } completion:nil];
}
-(void)hideUploadView{
    CGRect newUploadViewFrame = kHideUploadViewFrame;
    CGRect newTableViewFrame = self.view.bounds;
    
    [UIView animateWithDuration:AIKDefaultAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.uploadView.frame = newUploadViewFrame;
        self.tableView.frame = newTableViewFrame;
    } completion:nil];
}





- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
